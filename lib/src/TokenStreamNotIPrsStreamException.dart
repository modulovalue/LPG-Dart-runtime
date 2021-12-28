class TokenStreamNotIPrsStreamException implements Exception {
  ///

  String? str;

  TokenStreamNotIPrsStreamException([String? str]) {
    this.str = str;
  }

  @override
  String toString() {
    return str ?? 'TokenStreamNotIPrsStreamException';
  }
}
