class NullTerminalSymbolsException implements Exception {
  /**
     * 
     */

  String? str;

  NullTerminalSymbolsException([String? str]) {
    this.str = str;
  }
  String toString() {
    return str ?? "NullTerminalSymbolsException";
  }
}
