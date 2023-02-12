import 'LPGLexer.dart';
import 'LPGParser.dart';

void main(
  final List<String> arguments,
) {
  final lexer = LPGLexer('jikespg.g'); // Create the lexer
  final parser = LPGParser(lexer.getILexStream()); // Create the parser
  // lexer.printTokens = true;
  lexer.lexer(parser.getIPrsStream());
  final ast = parser.parser();
  if (null != ast) {
    var visitor = LpgVisitor();
    visitor.visit(ast as ASTNode);
    (ast as ASTNode).accept(visitor);
  }
}

class LpgVisitor extends AbstractVisitor {
  @override
  void unimplementedVisitor(String s) {
    // TODO: implement unimplementedVisitor
    print(s);
  }

  @override
  bool visitLPG(LPG n) {
    // TODO: implement visitLPG
    print(n.toString());
    print(n.getAllChildren().size());
    return true;
  }
}
