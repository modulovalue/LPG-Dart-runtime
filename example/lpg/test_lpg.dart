import 'package:lpg2/lpg2.dart';


import 'LPGLexer.dart';
import 'LPGParser.dart';
class LpgVisitor extends AbstractVisitor{
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
void main(List<String> arguments) {
  var filename = 'jikespg.g';
  var lexer = LPGLexer(filename); // Create the lexer

  var parser = LPGParser(lexer.getILexStream()); // Create the parser
  //lexer.printTokens = true;
  lexer.lexer(parser.getIPrsStream());
  var ast = parser.parser();
  if(null != ast){
    var visitor = LpgVisitor();
    //visitor.visitLPG(n)
    //visitor.visit(ast as ASTNode);
    (ast as ASTNode).accept(visitor);
  }

}
