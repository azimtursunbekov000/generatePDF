// file_handle_api_stub.dart
import 'file_handle_api.dart';

class FileHandleApiStub implements FileHandleApi {
  @override
  Future<String> saveDocument({required String name, required List<int> pdfBytes}) async {
    throw UnsupportedError("This platform is not supported");
  }

  @override
  Future<void> openFile(String filePath) async {
    throw UnsupportedError("This platform is not supported");
  }
}
