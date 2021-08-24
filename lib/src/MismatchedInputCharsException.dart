class MismatchedInputCharsException implements Exception {
  /**
     * 
     */

  String? str;

  MismatchedInputCharsException(String str) {
    this.str = str;
  }
  String toString() {
    return str ?? "MismatchedInputCharsException";
  }
}
