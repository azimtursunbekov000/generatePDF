// file_handle_api_android.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'file_handle_api.dart';

class FileHandleApiAndroid implements FileHandleApi {
  @override
  Future<String> saveDocument({required String name, required List<int> pdfBytes}) async {
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory!.path}/$name';
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);
    return filePath;
  }

  @override
  Future<void> openFile(String filePath) async {
    // Implement file opening logic for Android
  }
}
