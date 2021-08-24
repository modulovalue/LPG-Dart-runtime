

//
// PrsStream holds an arraylist of tokens "lexed" from the input stream.
//
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
import 'UnimplementedTerminalsException.dart';
import 'Util.dart';

class PrsStream implements IPrsStream
{
     ILexStream iLexStream = EscapeStrictPropertyInitializationLexStream();
     List<int>? kindMap;
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

            HashMap terminal_map = new HashMap();
            for (var i = 0; i < ordered_lexer_symbols.length; i++)
                terminal_map.put(ordered_lexer_symbols[i], new Integer(i));
            for (var i = 0; i < ordered_parser_symbols.length; i++)
            {
                 k = terminal_map.get(ordered_parser_symbols[i]);
                if (k != null)
                     kindMap[k.intValue()] = i;
                else
                {
                    if (i == eof_symbol)
                        throw UndefinedEofSymbolException();
                    unimplemented_symbols.add(i);
                }
            }
        }

        if (unimplemented_symbols.size() > 0)
            throw UnimplementedTerminalsException(unimplemented_symbols);
    }

      int mapKind(int kind) { return (kindMap == null ? kind : kindMap[kind]); }

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
     void resetLexStream(LexStream lexStream) 
    { 
        this.iLexStream = lexStream; 
        if (lexStream != null) lexStream.setPrsStream(this);
    }
    
     void makeToken(int startLoc, int endLoc, int kind)
    {
        var token = new Token(this, startLoc, endLoc, mapKind(kind));
        token.setTokenIndex(tokens.size());
        tokens.add(token);
        token.setAdjunctIndex(adjuncts.size());
    }
    
     void removeLastToken()
    {
        var last_index = tokens.size() - 1;
        Token token = (Token) tokens.get(last_index);
        var adjuncts_size = adjuncts.size();
        while(adjuncts_size > token.getAdjunctIndex())
            adjuncts.remove(--adjuncts_size);
        tokens.remove(last_index);
    }
    
     int makeErrorToken(int firsttok, int lasttok, int errortok, int kind)
    {
        var index = tokens.size(); // the next index

        //
        // Note that when creating an error token, we do not remap its kind.
        // Since this is not a lexical operation, it is the responsibility of
        // the calling program (a parser driver) to pass to us the proper kind
        // that it wants for an error token.
        //
        Token token = new ErrorToken(getIToken(firsttok),
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
    
     void addToken(IToken token)
    {
        token.setTokenIndex(tokens.size());
        tokens.add(token);
        token.setAdjunctIndex(adjuncts.size());
    }

     void makeAdjunct(int startLoc, int endLoc, int kind)
    {
        var token_index = tokens.size() - 1; // index of last token processed
        var adjunct = new Adjunct(startLoc, endLoc, mapKind(kind),this);
        adjunct.setAdjunctIndex(adjuncts.size());
        adjunct.setTokenIndex(token_index);
        adjuncts.add(adjunct);
    }
    
     void addAdjunct(IToken adjunct)
    {
        var token_index = tokens.size() - 1; // index of last token processed
        adjunct.setTokenIndex(token_index);
        adjunct.setAdjunctIndex(adjuncts.size());
        adjuncts.add(adjunct);
    }

     String getTokenText(int i)
    {
        IToken t = tokens.get(i);
        return t.toString();
    }

     int getStartOffset(int i)
    {
        IToken t = tokens.get(i);
        return t.getStartOffset();
    }

     int getEndOffset(int i)
    {
        IToken t = tokens.get(i);
        return t.getEndOffset();
    }

     int getTokenLength(int i)
    {
        IToken t = tokens.get(i);
        return t.getEndOffset() - t.getStartOffset() + 1;
    }

     int getLineNumberOfTokenAt(int i)
    {
        IToken t = tokens.get(i);
        return iLexStream.getLineNumberOfCharAt(t.getStartOffset());
    }

     int getEndLineNumberOfTokenAt(int i)
    {
        IToken t = tokens.get(i);
        return iLexStream.getLineNumberOfCharAt(t.getEndOffset());
    }

     int getColumnOfTokenAt(int i)
    {
        IToken t = tokens.get(i);
        return iLexStream.getColumnOfCharAt(t.getStartOffset());
    }

     int getEndColumnOfTokenAt(int i)
    {
        IToken t = tokens.get(i);
        return iLexStream.getColumnOfCharAt(t.getEndOffset());
    }

     List<String> orderedTerminalSymbols() { return null; }

     int getLineOffset(int i) { return iLexStream.getLineOffset(i); }

     int getLineCount() { return iLexStream.getLineCount(); }

     int getLineNumberOfCharAt(int i) { return iLexStream.getLineNumberOfCharAt(i); }

     int getColumnOfCharAt(int i) { return getColumnOfCharAt(i); }
    
    /**
     * @deprecated replaced by {@link #getFirstRealToken()}
     *
     */
     int getFirstErrorToken(int i) { return getFirstRealToken(i); }
     int getFirstRealToken(int i)
    {
        while (i >= len)
            i = ((ErrorToken) tokens.get(i)).getFirstRealToken().getTokenIndex();
        return i;
    }

    /**
     * @deprecated replaced by {@link #getLastRealToken()}
     *
     */
     int getLastErrorToken(int i) { return getLastRealToken(i); }
     int getLastRealToken(int i)
    {
        while (i >= len)
            i = ((ErrorToken) tokens.get(i)).getLastRealToken().getTokenIndex();
        return i;
    }

    // TODO: should this function throw an exception instead of returning null?
     char [] getInputChars()
    {
        return (iLexStream instanceof LexStream
                ? ((LexStream) iLexStream).getInputChars()
                : null);
    }

    // TODO: should this function throw an exception instead of returning null?
     byte [] getInputBytes()
    {
        return (iLexStream instanceof Utf8LexStream
                ? ((Utf8LexStream) iLexStream).getInputBytes()
                : null);
    }
    
     String toString(int first_token, int last_token)
    {
        return toString((IToken)tokens.get(first_token), tokens.get(last_token));
    }

     String toString(IToken t1, IToken t2)
    {
    	return iLexStream.toString(t1.getStartOffset(), t2.getEndOffset());
    }

     int getSize() { return tokens.size(); }

    /**
     * @deprecated replaced by {@link #setStreamLength()}
     *
     */
     void setSize() { len = tokens.size(); }

    //
    // This function returns the index of the token element
    // containing the offset specified. If such a token does
    // not exist, it returns the negation of the index of the 
    // element immediately preceding the offset.
    //
     int getTokenIndexAtCharacter(int offset)
    {
        int low = 0,
            high = tokens.size();
        while (high > low)
        {
            int mid = (high + low) / 2;
            IToken mid_element = tokens.get(mid);
            if (offset >= mid_element.getStartOffset() &&
                offset <= mid_element.getEndOffset())
                 return mid;
            else if (offset < mid_element.getStartOffset())
                 high = mid;
            else low = mid + 1;
        }

        return -(low - 1);
    }
    
     IToken? getTokenAtCharacter(int offset)
    {
        var tokenIndex = getTokenIndexAtCharacter(offset);
        return (tokenIndex < 0) ? null : getTokenAt(tokenIndex);
    }
    
     IToken getTokenAt(int i) { return tokens.get(i); }

     IToken getIToken(int i)  { return tokens.get(i); }

     ArrayList getTokens() { return tokens; }

     int getStreamIndex() { return index; }

     int getStreamLength() { return len; }

     void setStreamIndex(int index) { this.index = index; }

     void setStreamLength() { this.len = tokens.size(); }

     void setStreamLength(int len) { this.len = len; }

     ILexStream getILexStream() { return iLexStream; }

    /**
     * @deprecated replaced by {@link #getILexStream()}
     */
     ILexStream getLexStream() { return iLexStream; }

     void dumpTokens()
    {
        if (getSize() <= 2) return;
        System.out.println(" Kind \tOffset \tLen \tLine \tCol \tText\n");
        for (var i = 1; i < getSize() - 1; i++) dumpToken(i);
    }

     void dumpToken(int i)
    {
        System.out.print( " (" + getKind(i) + ")");
        System.out.print(" \t" + getStartOffset(i));
        System.out.print(" \t" + getTokenLength(i));
        System.out.print(" \t" + getLineNumberOfTokenAt(i));
        System.out.print(" \t" + getColumnOfTokenAt(i));
        System.out.print(" \t" + getTokenText(i));
        System.out.println();
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

     int getToken([int? end_token])
     {
           return index = (index < end_token ? getNext(index) : len - 1);
     }

     int getKind(int i)
    {
        IToken t = tokens.get(i);
        return t.getKind();
    }

     int getNext(int i) { return (++i < len ? i : len - 1); }

     int getPrevious(int i) { return (i <= 0 ? 0 : i - 1); }

     String getName(int i) { return getTokenText(i); }

     int peek() { return getNext(index); }

     void reset([int i =0]) {
       if(i == 0){
         reset2();
         return;
       }
       index = getPrevious(i);
     }

     void reset2() { index = 0; }

     int badToken() { return 0; }

     int getLine(int i) {return getLineNumberOfTokenAt(i); }

     int getColumn(int i) { return getColumnOfTokenAt(i); }

     int getEndLine(int i) { return getEndLineNumberOfTokenAt(i); }

     int getEndColumn(int i) { return getEndColumnOfTokenAt(i); }

     bool afterEol(int i) { return (i < 1 ? true : getEndLineNumberOfTokenAt(i - 1) < getLineNumberOfTokenAt(i)); }

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
     void setMessageHandler(IMessageHandler errMsg) {
        iLexStream.setMessageHandler(errMsg);
    }

     IMessageHandler getMessageHandler() {
        return iLexStream.getMessageHandler();
    }
    
     void reportError(int errorCode, int leftToken, int rightToken, String errorInfo)
    {
        // if (errorCode == DELETION_CODE ||
        //    errorCode == MISPLACED_CODE) tokenText = "";
        reportError(errorCode, 
                    leftToken,
                    0,
                    rightToken,
                    errorInfo == null ? null : new List<String> { errorInfo });
    }
    
     void reportError(int errorCode, int leftToken, int rightToken, List<String > errorInfo)
    {
        // if (errorCode == DELETION_CODE ||
        //    errorCode == MISPLACED_CODE) tokenText = "";
        reportError(errorCode, 
                    leftToken,
                    0,
                    rightToken,
                    errorInfo);
    }

     void reportError(int errorCode, int leftToken, int errorToken, int rightToken, String errorInfo)
    {
        reportError(errorCode, 
                    leftToken,
                    errorToken,
                    rightToken,
                    errorInfo == null ? null : new List<String> { errorInfo });
    }

     void reportError(int errorCode, int leftToken, int errorToken, int rightToken, String errorInfo[])
    {
        iLexStream.reportLexicalError(errorCode, 
                                      getStartOffset(leftToken),
                                      getEndOffset(rightToken),
                                      getStartOffset(errorToken),
                                      getEndOffset(errorToken),
                                      errorInfo == null ? new List<String> {} : errorInfo);
    }
}
