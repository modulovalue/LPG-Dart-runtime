class BadParseException implements Exception {

 late int error_token;
  BadParseException(int error_token) {
    this.error_token = error_token;
  }
}
