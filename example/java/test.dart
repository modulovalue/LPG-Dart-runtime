import 'JavaLexer.dart';
import 'JavaParser.dart';

void test() {
  //var _lexer = JavaLexer('test2.java'); // Create the lexer
  //var parser = JavaParser(_lexer.getILexStream());
  //_lexer.printTokens = true;
  //_lexer.lexer(parser.getIPrsStream());

  var parser = JavaParser();
  var now = DateTime.now();
  print('begin to call ruleAction at:' + now.toUtc().toString());
  parser.ruleAction(1000);
}

void main(List<String> arguments) {
  test();
  test();
}
