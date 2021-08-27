import 'LPGLexer.dart';
import 'LPGParser.dart';

void main(List<String> arguments) {
  var filename = 'jikespg.g';
  var lexer = LPGLexer(filename); // Create the lexer

  var parser = LPGParser(lexer.getILexStream()); // Create the parser
  lexer.printTokens = true;
  lexer.lexer(parser.getIPrsStream());
  var ast = parser.parser();
  print(ast.toString());
}
