//!

abstract class ApiConsumer {
  Future<dynamic> get(
    String path, {
    required Map<String, String>headers,
  });
  Future<dynamic> post(
    String path, {
    required Map<String, String> headers ,
    required Map<String, dynamic> data,
    bool isFormData = false,
  });
  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  });
  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  });
}