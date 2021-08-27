class NotDeterministicParseTableException implements Exception {


  String? str;

  NotDeterministicParseTableException([String? str]) {
    this.str = str;
  }
  @override
  String toString() {
    return str ?? 'NotDeterministicParseTableException';
  }
}
