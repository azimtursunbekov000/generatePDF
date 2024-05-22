import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'file_handle_api.dart';

class FileHandleApiMacOS implements FileHandleApi {
  @override
  Future<String> saveDocument({required String name, required List<int> pdfBytes}) async {
    final downloadsDirectory = await getDownloadsDirectory();
    final filePath = '${downloadsDirectory!.path}/$name';
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);
    return filePath;
  }

  @override
  Future<void> openFile(String filePath) async {
    final result = await Process.run('open', [filePath]);
    if (result.exitCode != 0) {
      print('Failed to open file: ${result.stderr}');
      // Здесь можно добавить дополнительную логику в случае неудачи
    }
  }
}
