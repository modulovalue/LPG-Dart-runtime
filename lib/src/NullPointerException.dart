class NullPointerException implements Exception {

  String? str;

  NullPointerException([String? str_]) {
    str= str_;
  }
  @override
  String toString() {
    return str ?? 'NullPointerException';
  }
}
