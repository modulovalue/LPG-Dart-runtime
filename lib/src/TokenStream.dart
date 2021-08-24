abstract class TokenStream {
  int getToken([int? end_token]);

  int getKind(int i);

  int getNext(int i);

  int getPrevious(int i);

  String getName(int i);

  int peek();

  void reset([int? i]);

  int badToken();

  int getLine(int i);

  int getColumn(int i);

  int getEndLine(int i);

  int getEndColumn(int i);

  bool afterEol(int i);

  String getFileName();

  int getStreamLength();

  int getFirstRealToken(int i);

  int getLastRealToken(int i);

  void reportError(
      int errorCode, int leftToken, int rightToken, errorInfo, [int errorToken=0]);
}
