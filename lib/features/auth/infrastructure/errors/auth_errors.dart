class ConnectionTimeout implements Exception {}
class IncorrectCredentials implements Exception {}
class InvalidToken implements Exception {}

class CustomError implements Exception {
  final String message;

  CustomError(this.message);
}