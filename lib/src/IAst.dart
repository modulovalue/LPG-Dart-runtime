import 'IAstVisitor.dart';
import 'Protocol.dart';
import 'Util.dart';

abstract class IAst {
  IAst? getNextAst();
  IAst? getParent();
  IToken getLeftIToken();
  IToken getRightIToken();
  List<IToken> getPrecedingAdjuncts();
  List<IToken> getFollowingAdjuncts();
  ArrayList getChildren();
  ArrayList getAllChildren();
  void accept(IAstVisitor v);
}
