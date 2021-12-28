class UndefinedEofSymbolException implements Exception {

  String? str;


  UndefinedEofSymbolException([String? str]) {
    this.str = str;
  }
  @override
  String toString() {
    return str??'UndefinedEofSymbolException';
  }
}
