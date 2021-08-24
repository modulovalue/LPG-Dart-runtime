import 'AbstractToken.dart';
import 'Protocol.dart';

class Token extends AbstractToken {


  Token(int startOffset, int endOffset, int kind,IPrsStream? iPrsStream)
      :super(startOffset, endOffset, kind,iPrsStream);

  //
  // Return an iterator for the adjuncts that follow token i.
  //
  @override
  List<IToken> getFollowingAdjuncts() {
    return getIPrsStream()!.getFollowingAdjuncts(getTokenIndex());
  }

  @override
  List<IToken> getPrecedingAdjuncts() {
    return getIPrsStream()!.getPrecedingAdjuncts(getTokenIndex());
  }
}
