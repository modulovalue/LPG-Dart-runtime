import 'Protocol.dart';

abstract class AbstractToken implements IToken {
  int kind = 0,
      startOffset = 0,
      endOffset = 0,
      tokenIndex = 0,
      adjunctIndex = 0;
  IPrsStream? iPrsStream;

  AbstractToken(int startOffset, int endOffset, int kind, IPrsStream? iPrsStream) {
    this.iPrsStream = iPrsStream;
    this.startOffset = startOffset;
    this.endOffset = endOffset;
    this.kind = kind;
  }

  @override
  int getKind() {
    return kind;
  }

  @override
  void setKind(int kind) {
    this.kind = kind;
  }

  @override
  int getStartOffset() {
    return startOffset;
  }

  @override
  void setStartOffset(int startOffset) {
    this.startOffset = startOffset;
  }

  @override
  int getEndOffset() {
    return endOffset;
  }

  @override
  void setEndOffset(int endOffset) {
    this.endOffset = endOffset;
  }

  @override
  int getTokenIndex() {
    return tokenIndex;
  }

  @override
  void setTokenIndex(int tokenIndex) {
    this.tokenIndex = tokenIndex;
  }

  @override
  void setAdjunctIndex(int adjunctIndex) {
    this.adjunctIndex = adjunctIndex;
  }

  @override
  int getAdjunctIndex() {
    return adjunctIndex;
  }

  @override
  IPrsStream? getIPrsStream() {
    return iPrsStream;
  }

  @override
  ILexStream? getILexStream() {
    return iPrsStream == null ? null : iPrsStream!.getILexStream();
  }

  @override
  int getLine() {
    return (iPrsStream == null
        ? 0
        : iPrsStream!.getILexStream().getLineNumberOfCharAt(startOffset));
  }

  @override
  int getColumn() {
    return (iPrsStream == null
        ? 0
        : iPrsStream!.getILexStream().getColumnOfCharAt(startOffset));
  }

  @override
  int getEndLine() {
    return (iPrsStream == null
        ? 0
        : iPrsStream!.getILexStream().getLineNumberOfCharAt(endOffset));
  }

  @override
  int getEndColumn() {
    return (iPrsStream == null
        ? 0
        : iPrsStream!.getILexStream().getColumnOfCharAt(endOffset));
  }

  @override
  String toString() {
    return (iPrsStream == null
        ? '<toString>'
        : iPrsStream!.toStringFromToken(this, this));
  }
}
