class NullExportedSymbolsException implements Exception {

  String? str;

  NullExportedSymbolsException([String? str_]) {
    str = str_;
  }
  @override
  String toString() {
    return str ?? 'NullExportedSymbolsException';
  }
}
