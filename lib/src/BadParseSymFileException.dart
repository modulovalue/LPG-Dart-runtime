class BadParseSymFileException implements Exception {

  String? str;

  BadParseSymFileException([String? str]) {
    this.str = str;
  }
  @override
  String toString() {
    return str ?? 'BadParseSymFileException';
  }
}
