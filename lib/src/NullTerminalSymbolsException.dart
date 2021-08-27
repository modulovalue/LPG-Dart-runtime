class NullTerminalSymbolsException implements Exception {


  String? str;

  NullTerminalSymbolsException([String? str]) {
    this.str = str;
  }
  @override
  String toString() {
    return str ?? 'NullTerminalSymbolsException';
  }
}
