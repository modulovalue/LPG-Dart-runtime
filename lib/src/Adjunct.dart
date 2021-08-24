import 'AbstractToken.dart';
import 'Protocol.dart';

class Adjunct extends AbstractToken {

  Adjunct(int startOffset, int endOffset, int kind,IPrsStream? prsStream)
      :super(startOffset, endOffset, kind,prsStream);
  List<IToken> getFollowingAdjuncts() {
    return [];
  }

  List<IToken> getPrecedingAdjuncts() {
    return [];
  }
}
