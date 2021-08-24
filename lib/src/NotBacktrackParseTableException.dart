class NotBacktrackParseTableException implements Exception {
  /**
     * 
     */
  String? str;

  NotBacktrackParseTableException([String? str]) {
    this.str = str;
  }
  String toString() {
    return str ?? 'NotBacktrackParseTableException';
  }
}
