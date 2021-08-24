import 'AbstractToken.dart';
import 'Protocol.dart';

class Adjunct extends AbstractToken {

  Adjunct(int startOffset, int endOffset, int kind,IPrsStream? prsStream)
      :super(startOffset, endOffset, kind,prsStream);
  @override
  List<IToken> getFollowingAdjuncts() {
    return [];
  }

  @override
  List<IToken> getPrecedingAdjuncts() {
    return [];
  }
}
