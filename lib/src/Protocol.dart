import 'IMessageHandler.dart';
import 'TokenStream.dart';
import 'Util.dart';

abstract class IToken {
  static const int EOF = 0xffff;

  int getKind();
  void setKind(int kind);

  int getStartOffset();
  void setStartOffset(int startOffset);

  int getEndOffset();
  void setEndOffset(int endOffset);

  int getTokenIndex();
  void setTokenIndex(int i);

  int getAdjunctIndex();
  void setAdjunctIndex(int i);

  List<IToken> getPrecedingAdjuncts();
  List<IToken> getFollowingAdjuncts();

  ILexStream? getILexStream();

  IPrsStream? getIPrsStream();

  int getLine();
  int getColumn();
  int getEndLine();
  int getEndColumn();


}

abstract class ILexStream extends TokenStream
{
    IPrsStream? getIPrsStream();

    
    void setPrsStream(IPrsStream stream);

    int getLineCount();

    List<String>? orderedExportedSymbols();

    int getLineOffset(int i);
    
    int getLineNumberOfCharAt(int i);

    int getColumnOfCharAt(int i);
    
    String getCharValue(int i);

    int getIntValue(int i);

    void makeToken(int startLoc, int endLoc, int kind);
    
    void setMessageHandler(IMessageHandler errMsg);
    IMessageHandler? getMessageHandler();

    /// See IMessaageHandler for a description of the List<int> return value.
    List<int> getLocation(int left_loc, int right_loc);


    void reportLexicalError(int left_loc, int right_loc,[int? errorCode,  int? error_left_loc,
    int? error_right_loc, List<String>? errorInfo]);


    String toStringWithOffset(int startOffset, int endOffset);
}
class EscapeStrictPropertyInitializationLexStream implements ILexStream{
  @override
  bool afterEol(int i) {
    // TODO: implement afterEol
    throw UnimplementedError();
  }

  @override
  int badToken() {
    // TODO: implement badToken
    throw UnimplementedError();
  }

  @override
  String getCharValue(int i) {
    // TODO: implement getCharValue
    throw UnimplementedError();
  }

  @override
  int getColumn(int i) {
    // TODO: implement getColumn
    throw UnimplementedError();
  }

  @override
  int getColumnOfCharAt(int i) {
    // TODO: implement getColumnOfCharAt
    throw UnimplementedError();
  }

  @override
  int getEndColumn(int i) {
    // TODO: implement getEndColumn
    throw UnimplementedError();
  }

  @override
  int getEndLine(int i) {
    // TODO: implement getEndLine
    throw UnimplementedError();
  }

  @override
  String getFileName() {
    // TODO: implement getFileName
    throw UnimplementedError();
  }

  @override
  int getFirstRealToken(int i) {
    // TODO: implement getFirstRealToken
    throw UnimplementedError();
  }

  @override
  IPrsStream getIPrsStream() {
    // TODO: implement getIPrsStream
    throw UnimplementedError();
  }

  @override
  int getIntValue(int i) {
    // TODO: implement getIntValue
    throw UnimplementedError();
  }

  @override
  int getKind(int i) {
    // TODO: implement getKind
    throw UnimplementedError();
  }

  @override
  int getLastRealToken(int i) {
    // TODO: implement getLastRealToken
    throw UnimplementedError();
  }

  @override
  int getLine(int i) {
    // TODO: implement getLine
    throw UnimplementedError();
  }

  @override
  int getLineCount() {
    // TODO: implement getLineCount
    throw UnimplementedError();
  }

  @override
  int getLineNumberOfCharAt(int i) {
    // TODO: implement getLineNumberOfCharAt
    throw UnimplementedError();
  }

  @override
  int getLineOffset(int i) {
    // TODO: implement getLineOffset
    throw UnimplementedError();
  }

  @override
  List<int> getLocation(int left_loc, int right_loc) {
    // TODO: implement getLocation
    throw UnimplementedError();
  }

  @override
  IMessageHandler getMessageHandler() {
    // TODO: implement getMessageHandler
    throw UnimplementedError();
  }

  @override
  String getName(int i) {
    // TODO: implement getName
    throw UnimplementedError();
  }

  @override
  int getNext(int i) {
    // TODO: implement getNext
    throw UnimplementedError();
  }

  @override
  int getPrevious(int i) {
    // TODO: implement getPrevious
    throw UnimplementedError();
  }

  IPrsStream getPrsStream() {
    // TODO: implement getPrsStream
    throw UnimplementedError();
  }

  @override
  int getStreamLength() {
    // TODO: implement getStreamLength
    throw UnimplementedError();
  }

  @override
  int getToken([int? end_token]) {
    // TODO: implement getToken
    throw UnimplementedError();
  }

  @override
  void makeToken(int startLoc, int endLoc, int kind) {
    // TODO: implement makeToken
  }

  @override
  List<String> orderedExportedSymbols() {
    // TODO: implement orderedExportedSymbols
    throw UnimplementedError();
  }

  @override
  int peek() {
    // TODO: implement peek
    throw UnimplementedError();
  }

  @override
  void reportError(int errorCode, int leftToken, int rightToken, errorInfo, [int errorToken=0]) {
    throw UnimplementedError();
  }

  @override
  void reportLexicalError(int left_loc, int right_loc,[int? errorCode, int? error_left_loc, int? error_right_loc, List<String>? errorInfo]) {
    throw UnimplementedError();
  }

  @override
  void reset([int? i]) {
    throw UnimplementedError();
  }

  @override
  void setMessageHandler(IMessageHandler errMsg) {
    throw UnimplementedError();
  }

  @override
  void setPrsStream(IPrsStream stream) {
    throw UnimplementedError();
  }

  @override
  String toStringWithOffset(int startOffset, int endOffset) {
    // TODO: implement toStringWithOffset
    throw UnimplementedError();
  }

}
abstract class IPrsStream extends TokenStream
{
    IMessageHandler? getMessageHandler();
    void setMessageHandler(IMessageHandler errMsg);

    ILexStream getILexStream();


    void setLexStream(ILexStream lexStream);
    
    /// @deprecated replaced by {@link #getFirstRealToken()}
    ///
    int getFirstErrorToken(int i);

    /// @deprecated replaced by {@link #getLastRealToken()}
    ///
    int getLastErrorToken(int i);

    void makeToken(int startLoc, int endLoc, int kind);

    void makeAdjunct(int startLoc, int endLoc, int kind);
    
    void removeLastToken();

    int getLineCount();

    int getSize();
    
    void remapTerminalSymbols(List<String> ordered_parser_symbols, int eof_symbol);
    List<String> orderedTerminalSymbols();
    
    int mapKind(int kind);
    
    void resetTokenStream();

    int getStreamIndex();
    
    void setStreamIndex(int index);

    void setStreamLength(int? len);

    void addToken(IToken token);
    
    void addAdjunct(IToken adjunct);
    
    List<String> orderedExportedSymbols();

    ArrayList getTokens();

    ArrayList getAdjuncts();

    List<IToken> getFollowingAdjuncts(int i);

    List<IToken> getPrecedingAdjuncts(int i);

    IToken getIToken(int i);

    String getTokenText(int i);
    
    int getStartOffset(int i);
    
    int getEndOffset(int i);
    
    int getLineOffset(int i);
    
    int getLineNumberOfCharAt(int i);

    int getColumnOfCharAt(int i);
    
    int getTokenLength(int i);

    int getLineNumberOfTokenAt(int i);

    int getEndLineNumberOfTokenAt(int i);

    int getColumnOfTokenAt(int i);

    int getEndColumnOfTokenAt(int i);

    String getInputChars();

    List getInputBytes();
    
    String toStringFromIndex(int first_token, int last_token);

    String toStringFromToken(IToken t1, IToken t2);

    int getTokenIndexAtCharacter(int offset);
    
    IToken? getTokenAtCharacter(int offset);
    
    IToken getTokenAt(int i);
    
    void dumpTokens();
    
    void dumpToken(int i);
    
    int makeErrorToken(int first, int last, int error, int kind);
}
