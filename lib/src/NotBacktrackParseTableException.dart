class NotBacktrackParseTableException implements Exception {

  String? str;

  NotBacktrackParseTableException([String? str]) {
    this.str = str;
  }
  @override
  String toString() {
    return str ?? 'NotBacktrackParseTableException';
  }
}
