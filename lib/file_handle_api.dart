// file_handle_api.dart
abstract class FileHandleApi {
  Future<String> saveDocument({required String name, required List<int> pdfBytes});
  Future<void> openFile(String filePath);
}
