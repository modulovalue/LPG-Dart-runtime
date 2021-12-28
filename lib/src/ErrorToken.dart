import 'Protocol.dart';
import 'Token.dart';

class ErrorToken extends Token {
  late IToken firstToken, lastToken, errorToken;

  ErrorToken(IToken firstToken, IToken lastToken, IToken errorToken,
      int startOffset, int endOffset, int kind)
      : super(startOffset, endOffset, kind, firstToken.getIPrsStream()) {
    this.firstToken = firstToken;
    this.lastToken = lastToken;
    this.errorToken = errorToken;
  }

  /// @deprecated replaced by {@link #getFirstRealToken()}
  ///
  IToken getFirstToken() {
    return getFirstRealToken();
  }

  IToken getFirstRealToken() {
    return firstToken;
  }

  /// @deprecated replaced by {@link #getLastRealToken()}
  ///
  IToken getLastToken() {
    return getLastRealToken();
  }

  IToken getLastRealToken() {
    return lastToken;
  }

  IToken getErrorToken() {
    return errorToken;
  }

  @override
  List<IToken> getPrecedingAdjuncts() {
    return firstToken.getPrecedingAdjuncts();
  }

  @override
  List<IToken> getFollowingAdjuncts() {
    return lastToken.getFollowingAdjuncts();
  }
}
