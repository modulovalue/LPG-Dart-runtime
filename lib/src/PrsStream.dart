

//
// PrsStream holds an arraylist of tokens "lexed" from the input stream.
//
 import 'dart:io';
import 'dart:js_util';

import 'Adjunct.dart';
import 'ErrorToken.dart';
import 'IMessageHandler.dart';
import 'LexStream.dart';
import 'NullExportedSymbolsException.dart';
import 'NullPointerException.dart';
import 'NullTerminalSymbolsException.dart';
import 'Protocol.dart';
import 'Token.dart';
import 'UndefinedEofSymbolException.dart';
import 'UnimplementedTerminalsException.dart';
import 'Util.dart';

class PrsStream implements IPrsStream
{
     ILexStream iLexStream = EscapeStrictPropertyInitializationLexStream();
     List<int> kindMap=[];
     ArrayList tokens = ArrayList();
     ArrayList adjuncts = ArrayList();
     int index = 0;
     int len = 0;


    
     PrsStream(ILexStream? iLexStream)
    {
        if (iLexStream != null) {
          this.iLexStream = iLexStream;
          iLexStream.setPrsStream(this);
          resetTokenStream();
        }

    }

     List<String> orderedExportedSymbols() { return []; }
    
     void remapTerminalSymbols(List<String>? ordered_parser_symbols, int eof_symbol)
    {
    	// SMS 12 Feb 2008
    	// lexStream might be null, maybe only erroneously, but it has happened
    	if (iLexStream is EscapeStrictPropertyInitializationLexStream) {
    	  throw  NullPointerException(
    			"PrsStream.remapTerminalSymbols(..):  lexStream is null");
    	}
    	
        var ordered_lexer_symbols = iLexStream.orderedExportedSymbols();
        if (ordered_lexer_symbols == null) {
          throw NullExportedSymbolsException();
        }
        if (ordered_parser_symbols == null) {
          throw NullTerminalSymbolsException();
        }

      var unimplemented_symbols =  ArrayList();
        if (ordered_lexer_symbols != ordered_parser_symbols)
        {
            kindMap = List.filled(ordered_lexer_symbols.length, 0) ;

            var terminal_map =   <String, int>{};
            for (var i = 0; i < ordered_lexer_symbols.length; i++) {
              terminal_map[ordered_lexer_symbols[i]] = i;
            }
            for (var i = 0; i < ordered_parser_symbols.length; i++)
            {
                if (terminal_map.containsValue(ordered_parser_symbols[i])) {
                  var k = terminal_map[ ordered_parser_symbols[i]];
                    kindMap[k!] = i;
                }
                else
                {
                    if (i == eof_symbol) {
                      throw UndefinedEofSymbolException();
                    }
                    unimplemented_symbols.add(i);
                }
            }
        }

        if (unimplemented_symbols.size() > 0) {
          throw UnimplementedTerminalsException(unimplemented_symbols);
        }
    }

      int mapKind(int kind) {
       return (kindMap.isEmpty ? kind : kindMap[kind]); }

     @override
    void resetTokenStream()
    {
        tokens = ArrayList();
        index = 0;

        adjuncts = ArrayList();
    }

     void setLexStream(ILexStream lexStream) 
    { 
        this.iLexStream = lexStream; 
        resetTokenStream();
    }
    
    /**
     * @deprecated function
     */
     void resetLexStream(LexStream? lexStream)
    {
      if (lexStream != null) {
        lexStream.setPrsStream(this);
        iLexStream = lexStream ;
      }
    }
    
     @override
  void makeToken(int startLoc, int endLoc, int kind)
    {
        var token = new Token(startLoc, endLoc, mapKind(kind),this);
        token.setTokenIndex(tokens.size());
        tokens.add(token);
        token.setAdjunctIndex(adjuncts.size());
    }
    
     @override
  void removeLastToken()
    {
        var last_index = tokens.size() - 1;
        Token token = tokens.get(last_index);
        var adjuncts_size = adjuncts.size();
        while(adjuncts_size > token.getAdjunctIndex()) {
          adjuncts.remove(--adjuncts_size);
        }
        tokens.remove(last_index);
    }
    
     @override
  int makeErrorToken(int firsttok, int lasttok, int errortok, int kind)
    {
        var index = tokens.size(); // the next index

        //
        // Note that when creating an error token, we do not remap its kind.
        // Since this is not a lexical operation, it is the responsibility of
        // the calling program (a parser driver) to pass to us the proper kind
        // that it wants for an error token.
        //
        Token token = ErrorToken(getIToken(firsttok),
                                     getIToken(lasttok),
                                     getIToken(errortok),
                                     getStartOffset(firsttok),
                                     getEndOffset(lasttok),
                                     kind);
        token.setTokenIndex(tokens.size());
        tokens.add(token);
        token.setAdjunctIndex(adjuncts.size());

        return index;
    }
    
     @override
  void addToken(IToken token)
    {
        token.setTokenIndex(tokens.size());
        tokens.add(token);
        token.setAdjunctIndex(adjuncts.size());
    }

     @override
  void makeAdjunct(int startLoc, int endLoc, int kind)
    {
        var token_index = tokens.size() - 1; // index of last token processed
        var adjunct =  Adjunct(startLoc, endLoc, mapKind(kind),this);
        adjunct.setAdjunctIndex(adjuncts.size());
        adjunct.setTokenIndex(token_index);
        adjuncts.add(adjunct);
    }
    
     @override
  void addAdjunct(IToken adjunct)
    {
        var token_index = tokens.size() - 1; // index of last token processed
        adjunct.setTokenIndex(token_index);
        adjunct.setAdjunctIndex(adjuncts.size());
        adjuncts.add(adjunct);
    }

     @override
  String getTokenText(int i)
    {
        IToken t = tokens.get(i);
        return t.toString();
    }

     @override
  int getStartOffset(int i)
    {
        IToken t = tokens.get(i);
        return t.getStartOffset();
    }

     @override
  int getEndOffset(int i)
    {
        IToken t = tokens.get(i);
        return t.getEndOffset();
    }

     @override
  int getTokenLength(int i)
    {
        IToken t = tokens.get(i);
        return t.getEndOffset() - t.getStartOffset() + 1;
    }

     @override
  int getLineNumberOfTokenAt(int i)
    {
        IToken t = tokens.get(i);
        return iLexStream.getLineNumberOfCharAt(t.getStartOffset());
    }

     @override
  int getEndLineNumberOfTokenAt(int i)
    {
        IToken t = tokens.get(i);
        return iLexStream.getLineNumberOfCharAt(t.getEndOffset());
    }

     @override
  int getColumnOfTokenAt(int i)
    {
        IToken t = tokens.get(i);
        return iLexStream.getColumnOfCharAt(t.getStartOffset());
    }

     @override
  int getEndColumnOfTokenAt(int i)
    {
        IToken t = tokens.get(i);
        return iLexStream.getColumnOfCharAt(t.getEndOffset());
    }

     @override
  List<String> orderedTerminalSymbols() { return []; }

     @override
  int getLineOffset(int i) { return iLexStream.getLineOffset(i); }

     @override
  int getLineCount() { return iLexStream.getLineCount(); }

     @override
  int getLineNumberOfCharAt(int i) { return iLexStream.getLineNumberOfCharAt(i); }

     @override
  int getColumnOfCharAt(int i) { return getColumnOfCharAt(i); }
    
    /// @deprecated replaced by {@link #getFirstRealToken()}
    ///
     @override
  int getFirstErrorToken(int i) { return getFirstRealToken(i); }
     @override
  int getFirstRealToken(int i)
    {
        while (i >= len) {
          i = (tokens.get(i)).getFirstRealToken().getTokenIndex();
        }
        return i;
    }

    /// @deprecated replaced by {@link #getLastRealToken()}
    ///
     @override
  int getLastErrorToken(int i) { return getLastRealToken(i); }
     @override
     int getLastRealToken(int i)
    {
        while (i >= len) {
          i = (tokens.get(i)).getLastRealToken().getTokenIndex();
        }
        return i;
    }

    // TODO: should this function throw an exception instead of returning null?
     @override
     String getInputChars()
    {
        return (iLexStream is LexStream
                ? (iLexStream as LexStream) .getInputChars()
                : '');
    }

    // TODO: should this function throw an exception instead of returning null?
     @override
  List getInputBytes()
    {
       return [];
    }
    
     @override
  String toStringFromIndex(int first_token, int last_token)
    {
        return toStringFromToken(tokens.get(first_token), tokens.get(last_token));
    }

     @override
    String toStringFromToken(IToken t1, IToken t2)
    {
    	return iLexStream.toStringWithOffset(t1.getStartOffset(), t2.getEndOffset());
    }

     @override
  int getSize() { return tokens.size(); }

    /// @deprecated replaced by {@link #setStreamLength()}
    ///
     void setSize() { len = tokens.size(); }

    //
    // This function returns the index of the token element
    // containing the offset specified. If such a token does
    // not exist, it returns the negation of the index of the 
    // element immediately preceding the offset.
    //
     int getTokenIndexAtCharacter(int offset)
    {
        var low = 0,
            high = tokens.size();
        while (high > low)
        {
            var mid = ((high + low) / 2).floor();
            IToken mid_element = tokens.get(mid);
            if (offset >= mid_element.getStartOffset() &&
                offset <= mid_element.getEndOffset()) {
              return mid;
            } else if (offset < mid_element.getStartOffset()) {
              high = mid;
            } else {
              low = mid + 1;
            }
        }

        return -(low - 1);
    }
    
     @override
  IToken? getTokenAtCharacter(int offset)
    {
        var tokenIndex = getTokenIndexAtCharacter(offset);
        return (tokenIndex < 0) ? null : getTokenAt(tokenIndex);
    }
    
     @override
  IToken getTokenAt(int i) { return tokens.get(i); }

     @override
  IToken getIToken(int i)  { return tokens.get(i); }

     @override
  ArrayList getTokens() { return tokens; }

     @override
  int getStreamIndex() { return index; }

     @override
  int getStreamLength() { return len; }

     void setStreamIndex(int index) { this.index = index; }

     void setStreamLength2() { this.len = tokens.size(); }

     @override
  void setStreamLength([int? len]) {
       if(len == null){
         setStreamLength2();
         return;
       }
       this.len = len;
     }

     @override
  ILexStream getILexStream() { return iLexStream; }

    /// @deprecated replaced by {@link #getILexStream()}
     ILexStream getLexStream() { return iLexStream; }

     void dumpTokens()
    {
        if (getSize() <= 2) return;
        stdout.write(" Kind \tOffset \tLen \tLine \tCol \tText\n");
        for (var i = 1; i < getSize() - 1; i++) dumpToken(i);
    }

     void dumpToken(int i)
    {
        stdout.write( " (" + getKind(i).toString() + ")");
        stdout.write(" \t" + getStartOffset(i).toString());
        stdout.write(" \t" + getTokenLength(i).toString());
        stdout.write(" \t" + getLineNumberOfTokenAt(i).toString());
        stdout.write(" \t" + getColumnOfTokenAt(i).toString());
        stdout.write(" \t" + getTokenText(i));
        stdout.write('\n');
    }

     List<IToken> getAdjunctsFromIndex(int i)
    {
        int start_index = (tokens.get(i)).getAdjunctIndex(),
            end_index = (i + 1 == tokens.size()
                                ? adjuncts.size()
                                : (tokens.get(getNext(i))).getAdjunctIndex()),
            size = end_index - start_index;

        var slice = List<IToken>.filled(size,newObject());
        for (int j = start_index, k = 0; j < end_index; j++, k++) {
          slice[k] =  adjuncts.get(j);
        }
        return slice;
    }
    
    //
    // Return an iterator for the adjuncts that follow token i.
    //
     @override
  List<IToken> getFollowingAdjuncts(int i)
    {
        return getAdjunctsFromIndex(i);
    }

     @override
  List<IToken> getPrecedingAdjuncts(int i)
    {
        return getAdjunctsFromIndex(getPrevious(i));
    }

     @override
  ArrayList getAdjuncts() { return adjuncts; }

    //
    // Methods that implement the TokenStream Interface
    //
     int getToken2()
    {
        index = getNext(index);
        return index;
    }

     @override
  int getToken([int? end_token])
     {
       if (null == end_token) {
         return getToken2();
       }
       return index = (index < end_token ? getNext(index) : len - 1);
     }

     @override
  int getKind(int i)
    {
        IToken t = tokens.get(i);
        return t.getKind();
    }

     @override
  int getNext(int i) { return (++i < len ? i : len - 1); }

     @override
  int getPrevious(int i) { return (i <= 0 ? 0 : i - 1); }

     @override
  String getName(int i) { return getTokenText(i); }

     @override
  int peek() {
       return getNext(index);
     }

     void reset1() { index = 0; }
     void reset2(int i) {
       index = getPrevious(i);
     }
    @override
    void  reset([int? i]) {
       if (null == i) {
        reset1();
       }
       else{
        reset2(i);
       }
     }
     @override
  int badToken() { return 0; }

     @override
  int getLine(int i) {return getLineNumberOfTokenAt(i); }

     @override
  int getColumn(int i) { return getColumnOfTokenAt(i); }
     @override
     int getEndLine(int i) { return getEndLineNumberOfTokenAt(i); }
     @override
     int getEndColumn(int i) { return getEndColumnOfTokenAt(i); }
     @override
     bool afterEol(int i) { return (i < 1 ? true : getEndLineNumberOfTokenAt(i - 1) < getLineNumberOfTokenAt(i)); }
     @override
     String getFileName() { return iLexStream.getFileName(); }

    //
    // Here is where we report errors.  The default method is simply to print the error message to the console.
    // However, the user may supply an error message handler to process error messages.  To support that
    // a message handler interface is provided that has a single method handleMessage().  The user has his
    // error message handler class implement the IMessageHandler interface and provides an object of this type
    // to the runtime using the setMessageHandler(errorMsg) method. If the message handler object is set, 
    // the reportError methods will invoke its handleMessage() method.
    //
    // IMessageHandler errMsg = null; // the error message handler object is declared in LexStream
    //
     @override
     void setMessageHandler(IMessageHandler errMsg) {
        iLexStream.setMessageHandler(errMsg);
    }
     @override
     IMessageHandler? getMessageHandler() {
        return iLexStream.getMessageHandler();
    }


     @override
  void reportError(int errorCode, int leftToken, int rightToken, errorInfo,
         [int errorToken = 0]){
          late List<String>  tempInfo;
          if(errorInfo is String){
            tempInfo=[errorInfo];
          }
          else if(errorInfo is List<String>){
            tempInfo = errorInfo;
          }
          else{
            tempInfo = [];
          }
          iLexStream?.reportLexicalError(getStartOffset(leftToken),getEndOffset(rightToken),errorCode,
              getStartOffset(errorToken),
             getEndOffset(errorToken), tempInfo);
     }
}
