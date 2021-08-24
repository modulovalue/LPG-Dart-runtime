class BadParseSymFileException implements Exception {
  /**
     * 
     */

  String? str;

  BadParseSymFileException([String? str]) {
    this.str = str;
  }
  String toString() {
    return str ?? "BadParseSymFileException";
  }
}
