import 'Util.dart';

class UnimplementedTerminalsException implements Exception {
  late ArrayList? symbols;

  UnimplementedTerminalsException(ArrayList? symbols) {
    this.symbols = symbols;
  }

  ArrayList? getSymbols() {
    return symbols;
  }
}
