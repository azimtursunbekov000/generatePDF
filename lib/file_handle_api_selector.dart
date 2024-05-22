// file_handle_api_selector.dart
export 'file_handle_api_stub.dart' if (dart.library.html) 'file_handle_api_stub.dart'
if (dart.library.io) 'file_handle_api_android.dart'
if (dart.library.io) 'file_handle_api_ios.dart'
if (dart.library.io) 'file_handle_api_macos.dart'
if (dart.library.io) 'file_handle_api_windows.dart';
