class NotDeterministicParseTableException implements Exception {
  /**
     * 
     */

  String? str;

  NotDeterministicParseTableException([String? str]) {
    this.str = str;
  }
  String toString() {
    return str ?? 'NotDeterministicParseTableException';
  }
}
