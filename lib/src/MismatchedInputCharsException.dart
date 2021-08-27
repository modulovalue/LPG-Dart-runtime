class MismatchedInputCharsException implements Exception {


  String? str;

  MismatchedInputCharsException(String str) {
    this.str = str;
  }
  @override
  String toString() {
    return str ?? 'MismatchedInputCharsException';
  }
}
