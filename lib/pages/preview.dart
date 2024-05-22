import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdf_gen/file_handle_api.dart';
import 'package:flutter_pdf_gen/helper/pdf_helper.dart';
import 'package:flutter_pdf_gen/models/bill_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import '../file_handle_api_android.dart';
import '../file_handle_api_ios.dart';
import '../file_handle_api_macos.dart'; // Импортируем класс для работы с файлами на macOS
import '../file_handle_api_stub.dart';
import '../file_handle_api_windows.dart';
import 'package:flutter_pdf_gen/file_handle_api_selector.dart';

class PdfPreviewPage extends StatelessWidget {
  final BillModel bill;

  const PdfPreviewPage({Key? key, required this.bill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Bill Preview'),
        actions: [
          if (!Platform.isIOS)
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () async {
                final pdfDocument = await pdfBuilder(bill);
                final pdfBytes = await pdfDocument;
                final fileName = 'bill_${DateTime.now().millisecondsSinceEpoch}.pdf';

                final fileHandleApi = _getFileHandleApi();
                final filePath = await fileHandleApi.saveDocument(
                  name: fileName,
                  pdfBytes: pdfBytes,
                );

                // Проверяем, существует ли файл
                final file = File(filePath);
                if (await file.exists()) {
                  // Копируем файл в директорию загрузок
                  final downloadsDirectory = await getDownloadsDirectory();
                  if (downloadsDirectory != null) {
                    final newFilePath = '${downloadsDirectory.path}/$fileName';
                    await file.copy(newFilePath);

                    // Показываем сообщение о том, что файл был сохранен
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('File saved to Downloads')),
                    );
                  } else {
                    // Если директория загрузок недоступна, показываем ошибку
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Downloads directory not available')),
                    );
                  }
                } else {
                  // Если файл не был сохранен, показываем ошибку
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error saving file')),
                  );
                }
              },
            ),
        ],
      ),
      body: InteractiveViewer(
        panEnabled: false,
        boundaryMargin: const EdgeInsets.all(80),
        minScale: 0.5,
        maxScale: 4,
        child: PdfPreview(
          loadingWidget: const CupertinoActivityIndicator(),
          build: (context) => pdfBuilder(bill),
        ),
      ),
    );
  }

  FileHandleApi _getFileHandleApi() {
    if (Platform.isWindows) {
      return FileHandleApiWindows();
    } else if (Platform.isMacOS) {
      return FileHandleApiMacOS(); // Возвращаем класс для работы с файлами на macOS
    } else if (Platform.isIOS) {
      return FileHandleApiIOS();
    } else if (Platform.isAndroid) {
      return FileHandleApiAndroid();
    } else {
      return FileHandleApiStub();
    }
  }
}
