/// Implements [Exception] class for handling exception
/// error messages received from server.
class HttpException implements Exception {
  /// The error message for this exception.
  final String message;

  HttpException(this.message);

  /// Returns the error message as an [Exception]
  @override
  String toString() {
    return message;
  }
}
