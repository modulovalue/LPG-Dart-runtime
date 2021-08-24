

 import 'Protocol.dart';

abstract class AbstractToken implements IToken
{
     int kind = 0,
                startOffset = 0,
                endOffset = 0,
                tokenIndex = 0,
                adjunctIndex=0;
     IPrsStream? iPrsStream;


     AbstractToken(int startOffset, int endOffset, int kind,IPrsStream? iPrsStream)
    {
        this.iPrsStream = iPrsStream;
        this.startOffset = startOffset;
        this.endOffset = endOffset;
        this.kind = kind;
    }

     int getKind() { return kind; }
     void setKind(int kind) { this.kind = kind; }

     int getStartOffset() { return startOffset; }
     void setStartOffset(int startOffset)
    {
        this.startOffset = startOffset;
    }

     int getEndOffset() { return endOffset; }
     void setEndOffset(int endOffset)
    {
        this.endOffset = endOffset;
    }

     int getTokenIndex() { return tokenIndex; }
     void setTokenIndex(int tokenIndex) { this.tokenIndex = tokenIndex; }

     void setAdjunctIndex(int adjunctIndex) { this.adjunctIndex = adjunctIndex; }
     int getAdjunctIndex() { return adjunctIndex; }
    
     IPrsStream? getIPrsStream() { return iPrsStream; }
     ILexStream? getILexStream() { return iPrsStream == null ? null : iPrsStream!.getILexStream(); }

     int getLine() { return (iPrsStream == null ? 0 : iPrsStream!.getILexStream().getLineNumberOfCharAt(startOffset)); }
     int getColumn() { return (iPrsStream == null ? 0 : iPrsStream!.getILexStream().getColumnOfCharAt(startOffset)); }
     int getEndLine() { return (iPrsStream == null ? 0 : iPrsStream!.getILexStream().getLineNumberOfCharAt(endOffset)); }
     int getEndColumn() { return (iPrsStream == null ? 0 : iPrsStream!.getILexStream().getColumnOfCharAt(endOffset)); }


     @override
  String toString()
    {

        return (iPrsStream == null
                           ? "<toString>"
                           : iPrsStream!.toStringFromToken(this, this));
    }
}