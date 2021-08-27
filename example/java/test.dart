import 'JavaLexer.dart';
import 'JavaParser.dart';

void test() {
  var _lexer = JavaLexer('test2.java'); // Create the lexer
  var parser = JavaParser(_lexer.getILexStream());
  _lexer.printTokens = true;
  _lexer.lexer(parser.getIPrsStream());
  var ast = parser.parser();
  if (null != ast) {
    // ignore: prefer_single_quotes
    print("good:" + ast.toString());
  } else {
    print('bad.');
  }
}

void main(List<String> arguments) {
  test();
}
