    //#line 123 "LexerTemplateF.gi

import 'package:lpg2/lpg2.dart';
import 'LPGLexerprs.dart';
import 'LPGLexersym.dart';
import 'LPGKWLexer.dart';
import 'dart:io';

    //#line 8 "LPGLexer.gi



    //#line 2 "LexerBasicMapF.gi
import 'LPGParsersym.dart';

    //#line 133 "LexerTemplateF.gi

class LPGLexer extends Object implements RuleAction
{
    late LPGLexerLpgLexStream lexStream ;
    
    static  ParseTable prs = LPGLexerprs();
    ParseTable  getParseTable() { return LPGLexer.prs; }

    LexParser  lexParser = LexParser();
    LexParser  getParser()  { return lexParser; }

    int getToken(int i)   { return lexParser.getToken(i); }
    int  getRhsFirstTokenIndex(int i) { return lexParser.getFirstToken(i); }
    int  getRhsLastTokenIndex(int i) { return lexParser.getLastToken(i); }

    int getLeftSpan()  { return lexParser.getToken(1); }
    int getRightSpan()   { return lexParser.getLastToken(); }

    void  resetKeywordLexer()   
    {
        if (null ==kwLexer)
              kwLexer = LPGKWLexer(lexStream.getInputChars(), LPGParsersym.TK_MACRO_NAME);
         kwLexer!.setInputChars(lexStream.getInputChars());
    }

  
    
    void  reset(String filename , [int tab=4, String?input_chars])
    {
        lexStream = LPGLexerLpgLexStream(filename,input_chars, tab);
        lexParser.reset(lexStream, LPGLexer.prs,  this);
        resetKeywordLexer();
    }
    
   
    LPGLexer(String filename , [int tab=4, String?input_chars])
    {
        lexStream = LPGLexerLpgLexStream(filename,input_chars, tab);
        lexParser.reset(lexStream, LPGLexer.prs,  this);
        resetKeywordLexer();
    }

   

    ILexStream getILexStream(){ return  lexStream; }

    void initializeLexer(IPrsStream prsStream , int start_offset, int end_offset)    
    {
        if (lexStream.getInputChars() == null)
            throw NullPointerException("LexStream was not initialized");
        lexStream.setPrsStream(prsStream);
        prsStream.makeToken(start_offset, end_offset, 0); // Token list must start with a bad token
    }

    void  addEOF( IPrsStream prsStream , int end_offset)   
    {
        prsStream.makeToken(end_offset, end_offset, LPGParsersym.TK_EOF_TOKEN); // and end with the end of file token
        prsStream.setStreamLength(prsStream.getSize());
    }

    void  lexerWithPosition(IPrsStream prsStream, int start_offset , int end_offset , [Monitor? monitor])   
    {
        if (start_offset <= 1)
             initializeLexer(prsStream, 0, -1);
        else initializeLexer(prsStream, start_offset - 1, start_offset - 1);

        lexParser.parseCharacters(start_offset, end_offset,monitor);

        addEOF(prsStream, (end_offset >= lexStream.getStreamIndex() ? lexStream.getStreamIndex() : end_offset + 1));
    }

    void lexer(IPrsStream prsStream,  [Monitor? monitor])   
    {
       
        initializeLexer(prsStream, 0, -1);
        lexParser.parseCharactersWhitMonitor(monitor);
        addEOF(prsStream, lexStream.getStreamIndex());
    }
   

    /**
     * If a parse stream was not passed to this Lexical analyser then we
     * simply report a lexical error. Otherwise, we produce a bad token.
     */
    void  reportLexicalError(int startLoc, int endLoc)    {
        var prs_stream = lexStream.getIPrsStream();
        if (null ==prs_stream)
            lexStream.reportLexicalError(startLoc, endLoc);
        else {
            //
            // Remove any token that may have been processed that fall in the
            // range of the lexical error... then add one error token that spans
            // the error range.
            //
            for (var i = prs_stream.getSize() - 1; i > 0; i--) {
                if (prs_stream.getStartOffset(i) >= startLoc)
                     prs_stream.removeLastToken();
                else break;
            }
            prs_stream.makeToken(startLoc, endLoc, 0); // add an error token to the prsStream
        }        
    }

    //#line 13 "LPGLexer.gi
 

    //#line 165 "LexerBasicMapF.gi


    //
    // The Lexer contains an array of characters as the input stream to be parsed.
    // There are methods to retrieve and classify characters.
    // The lexparser "token" is implemented simply as the index of the next character in the array.
    // The Lexer : the abstract class LpgLexStream with an implementation of the abstract
    // method getKind.  The template defines the Lexer class and the lexer() method.
    // A driver creates the action class, "Lexer", passing an Option object to the constructor.
    //
    LPGKWLexer? kwLexer;
    bool printTokens=false;
    static  const   int ECLIPSE_TAB_VALUE= 4;

    List<int> getKeywordKinds(){ 
        if(null ==kwLexer){
            throw  NullPointerException("please initilize kwLexer");
        }
        return kwLexer!.getKeywordKinds(); 
    }



    /**
     * @deprecated function replaced by {@link %reset(content : String, filename : String)}
     */
    void initialize(String content, String filename)
    {
        reset(filename,4,content);
    }
    
    void makeToken1(int left_token,int right_token , int kind ) 
    {
        lexStream.makeToken(left_token, right_token, kind);
    }
    
    void makeToken(int arg0, [int? arg1, int? arg2])
    {
        if(arg1 != null && arg2 != null){
        
            makeToken1(arg0,arg1,arg2);
            return ;
        }
        var  startOffset  = getLeftSpan();
        var   endOffset = getRightSpan();
        lexStream.makeToken(startOffset, endOffset, arg0);
        if (printTokens)  printValue(startOffset, endOffset);
    }

    void makeComment(int kind) 
    {
        var startOffset =  getLeftSpan(),
            endOffset =  getRightSpan();
        lexStream.getIPrsStream()?.makeAdjunct(startOffset, endOffset, kind);
    }

    void  skipToken() 
    {
        if (printTokens)  printValue( getLeftSpan(),  getRightSpan());
    }
    
    void  checkForKeyWord1()
    {
        if(null ==kwLexer){
            throw  NullPointerException("please initilize kwLexer");
        }
        var startOffset =  getLeftSpan(),
            endOffset =  getRightSpan();
         var   kwKind = kwLexer!.lexer(startOffset, endOffset);
        lexStream.makeToken(startOffset, endOffset, kwKind);
        if ( printTokens)  printValue(startOffset, endOffset);
    }
    
    //
    // This flavor of checkForKeyWord is necessary when the default kind
    // (which is returned when the keyword filter doesn't match) is something
    // other than _IDENTIFIER.
    //
    void checkForKeyWord([int? defaultKind])
    {
       if(null ==defaultKind){
          checkForKeyWord1();
          return;
       }
        if(null ==kwLexer){
            throw  NullPointerException("please initilize kwLexer");
        }
        var startOffset =  getLeftSpan(),
            endOffset =  getRightSpan();
        var    kwKind =  kwLexer!.lexer(startOffset, endOffset);
        if (kwKind == LPGParsersym.TK_MACRO_NAME)
            kwKind = defaultKind;
        lexStream.makeToken(startOffset, endOffset, kwKind);
        if ( printTokens)  printValue(startOffset, endOffset);
    }
    
    void  printValue(int startOffset, int endOffset) 
    {
         var s = lexStream.getInputChars().substring(startOffset, endOffset  + 1);
         stdout.write(s);
    }

  

    //#line 239 "LexerTemplateF.gi

    void ruleAction(int ruleNumber  )   
    {
        switch(ruleNumber)
        {

            //
            // Rule 1:  Token ::= white
            //
            case 1: { 
             skipToken();             break;
            }

            //
            // Rule 2:  Token ::= singleLineComment
            //
            case 2: { 
             makeComment(LPGParsersym.TK_SINGLE_LINE_COMMENT);             break;
            }

            //
            // Rule 4:  Token ::= MacroSymbol
            //
            case 4: { 
             checkForKeyWord();            break;
            }

            //
            // Rule 5:  Token ::= Symbol
            //
            case 5: { 
             checkForKeyWord(LPGParsersym.TK_SYMBOL);            break;
            }

            //
            // Rule 6:  Token ::= Block
            //
            case 6: { 
             makeToken(LPGParsersym.TK_BLOCK);            break;
            }

            //
            // Rule 7:  Token ::= Equivalence
            //
            case 7: { 
             makeToken(LPGParsersym.TK_EQUIVALENCE);            break;
            }

            //
            // Rule 8:  Token ::= Equivalence ?
            //
            case 8: { 
             makeToken(LPGParsersym.TK_PRIORITY_EQUIVALENCE);            break;
            }

            //
            // Rule 9:  Token ::= #
            //
            case 9: { 
             makeToken(LPGParsersym.TK_SHARP);            break;
            }

            //
            // Rule 10:  Token ::= Arrow
            //
            case 10: { 
             makeToken(LPGParsersym.TK_ARROW);            break;
            }

            //
            // Rule 11:  Token ::= Arrow ?
            //
            case 11: { 
             makeToken(LPGParsersym.TK_PRIORITY_ARROW);            break;
            }

            //
            // Rule 12:  Token ::= |
            //
            case 12: { 
             makeToken(LPGParsersym.TK_OR_MARKER);            break;
            }

            //
            // Rule 13:  Token ::= [
            //
            case 13: { 
             makeToken(LPGParsersym.TK_LEFT_BRACKET);            break;
            }

            //
            // Rule 14:  Token ::= ]
            //
            case 14: { 
             makeToken(LPGParsersym.TK_RIGHT_BRACKET);            break;
            }

            //
            // Rule 858:  OptionLines ::= OptionLineList
            //
            case 858: { 
            
                  // What ever needs to happen after the options have been 
                  // scanned must happen here.
                    break;
            }
      
            //
            // Rule 867:  options ::= % oO pP tT iI oO nN sS
            //
            case 867: { 
            
                  makeToken(getLeftSpan(), getRightSpan(), LPGParsersym.TK_OPTIONS_KEY);
                    break;
            }
      
            //
            // Rule 868:  OptionComment ::= singleLineComment
            //
            case 868: { 
             makeComment(LPGParsersym.TK_SINGLE_LINE_COMMENT);             break;
            }

            //
            // Rule 891:  separator ::= ,$comma
            //
            case 891: { 
              makeToken(getLeftSpan(), getRightSpan(), LPGParsersym.TK_COMMA);             break;
            }

            //
            // Rule 892:  option ::= action_block$ab optionWhite =$eq optionWhite ($lp optionWhite filename$fn optionWhite ,$comma1 optionWhite block_begin$bb optionWhite ,$comma2 optionWhite block_end$be optionWhite )$rp optionWhite
            //
            case 892: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_LEFT_PAREN);
                  makeToken(getRhsFirstTokenIndex(7), getRhsLastTokenIndex(7), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(9), getRhsLastTokenIndex(9), LPGParsersym.TK_COMMA);
                  makeToken(getRhsFirstTokenIndex(11), getRhsLastTokenIndex(11), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(13), getRhsLastTokenIndex(13), LPGParsersym.TK_COMMA);
                  makeToken(getRhsFirstTokenIndex(15), getRhsLastTokenIndex(15), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(17), getRhsLastTokenIndex(17), LPGParsersym.TK_RIGHT_PAREN);
                    break;
            }
      
            //
            // Rule 895:  option ::= ast_block$ab optionWhite =$eq optionWhite ($lp optionWhite block_begin$bb optionWhite ,$comma2 optionWhite block_end$be optionWhite )$rp optionWhite
            //
            case 895: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_LEFT_PAREN);

                  makeToken(getRhsFirstTokenIndex(7), getRhsLastTokenIndex(7), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(9), getRhsLastTokenIndex(9), LPGParsersym.TK_COMMA);
                  makeToken(getRhsFirstTokenIndex(11), getRhsLastTokenIndex(11), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(13), getRhsLastTokenIndex(13), LPGParsersym.TK_RIGHT_PAREN);
                    break;
            }
      
            //
            // Rule 900:  option ::= ast_directory$ad optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 900: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 903:  option ::= ast_type$at optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 903: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 906:  option ::= attributes$a optionWhite
            //
            case 906: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 907:  option ::= no attributes$a optionWhite
            //
            case 907: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 909:  option ::= automatic_ast$a optionWhite
            //
            case 909: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 910:  option ::= no automatic_ast$a optionWhite
            //
            case 910: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 911:  option ::= automatic_ast$aa optionWhite =$eq optionWhite automatic_ast_value$val optionWhite
            //
            case 911: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 915:  option ::= backtrack$b optionWhite
            //
            case 915: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 916:  option ::= no backtrack$b optionWhite
            //
            case 916: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 918:  option ::= byte$b optionWhite
            //
            case 918: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 919:  option ::= no byte$b optionWhite
            //
            case 919: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 921:  option ::= conflicts$c optionWhite
            //
            case 921: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 922:  option ::= no conflicts$c optionWhite
            //
            case 922: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 924:  option ::= dat_directory$dd optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 924: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 927:  option ::= dat_file$df optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 927: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 929:  option ::= dcl_file$df optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 929: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 931:  option ::= def_file$df optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 931: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 933:  option ::= debug$d optionWhite
            //
            case 933: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 934:  option ::= no debug$d optionWhite
            //
            case 934: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 936:  option ::= edit$e optionWhite
            //
            case 936: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 937:  option ::= no edit$e optionWhite
            //
            case 937: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 939:  option ::= error_maps$e optionWhite
            //
            case 939: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 940:  option ::= no error_maps$e optionWhite
            //
            case 940: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 943:  option ::= escape$e optionWhite =$eq optionWhite anyNonWhiteChar$val optionWhite
            //
            case 943: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                  
                    break;
            }
      
            //
            // Rule 945:  option ::= export_terminals$et optionWhite =$eq optionWhite filename$fn optionWhite
            //
            case 945: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 946:  option ::= export_terminals$et optionWhite =$eq optionWhite ($lp optionWhite filename$fn optionWhite )$rp optionWhite
            //
            case 946: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_LEFT_PAREN);
                  makeToken(getRhsFirstTokenIndex(7), getRhsLastTokenIndex(7), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(9), getRhsLastTokenIndex(9), LPGParsersym.TK_RIGHT_PAREN);
                    break;
            }
      
            //
            // Rule 947:  option ::= export_terminals$et optionWhite =$eq optionWhite ($lp optionWhite filename$fn optionWhite ,$comma optionWhite export_prefix$ep optionWhite )$rp optionWhite
            //
            case 947: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_LEFT_PAREN);
                  makeToken(getRhsFirstTokenIndex(7), getRhsLastTokenIndex(7), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(9), getRhsLastTokenIndex(9), LPGParsersym.TK_COMMA);
                  makeToken(getRhsFirstTokenIndex(11), getRhsLastTokenIndex(11), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(13), getRhsLastTokenIndex(13), LPGParsersym.TK_RIGHT_PAREN);
                    break;
            }
      
            //
            // Rule 948:  option ::= export_terminals$et optionWhite =$eq optionWhite ($lp optionWhite filename$fn optionWhite ,$comma1 optionWhite export_prefix$ep optionWhite ,$comma2 optionWhite export_suffix$es optionWhite )$rp optionWhite
            //
            case 948: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_LEFT_PAREN);
                  makeToken(getRhsFirstTokenIndex(7), getRhsLastTokenIndex(7), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(9), getRhsLastTokenIndex(9), LPGParsersym.TK_COMMA);
                  makeToken(getRhsFirstTokenIndex(11), getRhsLastTokenIndex(11), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(13), getRhsLastTokenIndex(13), LPGParsersym.TK_COMMA);
                  makeToken(getRhsFirstTokenIndex(15), getRhsLastTokenIndex(15), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(17), getRhsLastTokenIndex(17), LPGParsersym.TK_RIGHT_PAREN);
                    break;
            }
      
            //
            // Rule 953:  option ::= extends_parsetable$e optionWhite
            //
            case 953: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 954:  option ::= no extends_parsetable$e optionWhite
            //
            case 954: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 955:  option ::= extends_parsetable$ep optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 955: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 958:  option ::= factory$f optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 958: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 960:  option ::= file_prefix$fp optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 960: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 963:  option ::= filter$f optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 963: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 965:  option ::= first$f optionWhite
            //
            case 965: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 966:  option ::= no first$f optionWhite
            //
            case 966: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 968:  option ::= follow$f optionWhite
            //
            case 968: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 969:  option ::= no follow$f optionWhite
            //
            case 969: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 971:  option ::= goto_default$g optionWhite
            //
            case 971: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 972:  option ::= no goto_default$g optionWhite
            //
            case 972: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 975:  option ::= headers$h optionWhite =$eq optionWhite ($lp optionWhite filename$fn optionWhite ,$comma1 optionWhite block_begin$bb optionWhite ,$comma2 optionWhite block_end$be optionWhite )$rp optionWhite
            //
            case 975: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_LEFT_PAREN);
                  makeToken(getRhsFirstTokenIndex(7), getRhsLastTokenIndex(7), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(9), getRhsLastTokenIndex(9), LPGParsersym.TK_COMMA);
                  makeToken(getRhsFirstTokenIndex(11), getRhsLastTokenIndex(11), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(13), getRhsLastTokenIndex(13), LPGParsersym.TK_COMMA);
                  makeToken(getRhsFirstTokenIndex(15), getRhsLastTokenIndex(15), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(17), getRhsLastTokenIndex(17), LPGParsersym.TK_RIGHT_PAREN);
                    break;
            }
      
            //
            // Rule 977:  option ::= imp_file$if optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 977: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 980:  option ::= import_terminals$it optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 980: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 983:  option ::= include_directory$id optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 983: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 987:  option ::= lalr_level$l optionWhite
            //
            case 987: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 988:  option ::= no lalr_level$l optionWhite
            //
            case 988: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 989:  option ::= lalr_level$l optionWhite =$eq optionWhite number$val optionWhite
            //
            case 989: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 994:  option ::= list$l optionWhite
            //
            case 994: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 995:  option ::= no list$l optionWhite
            //
            case 995: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 997:  option ::= margin$m optionWhite =$eq optionWhite number$val optionWhite
            //
            case 997: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 999:  option ::= max_cases$mc optionWhite =$eq optionWhite number$val optionWhite
            //
            case 999: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 1002:  option ::= names$n optionWhite
            //
            case 1002: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 1003:  option ::= no names$n optionWhite
            //
            case 1003: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 1004:  option ::= names$n optionWhite =$eq optionWhite names_value$val optionWhite
            //
            case 1004: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 1007:  option ::= nt_check$n optionWhite
            //
            case 1007: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 1008:  option ::= no nt_check$n optionWhite
            //
            case 1008: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 1011:  option ::= or_marker$om optionWhite =$eq optionWhite anyNonWhiteChar$val optionWhite
            //
            case 1011: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 1014:  option ::= out_directory$dd optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 1014: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 1017:  option ::= parent_saved$ps optionWhite
            //
            case 1017: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1018:  option ::= no parent_saved$ps optionWhite
            //
            case 1018: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1021:  option ::= package$p optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 1021: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 1023:  option ::= parsetable_interfaces$pi optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 1023: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 1027:  option ::= prefix$p optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 1027: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 1029:  option ::= priority$p optionWhite
            //
            case 1029: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 1030:  option ::= no priority$p optionWhite
            //
            case 1030: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 1032:  option ::= programming_language$pl optionWhite =$eq optionWhite programming_language_value$val optionWhite
            //
            case 1032: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 1036:  option ::= prs_file$pf optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 1036: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 1039:  option ::= quiet$q optionWhite
            //
            case 1039: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 1040:  option ::= no quiet$q optionWhite
            //
            case 1040: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 1042:  option ::= read_reduce$r optionWhite
            //
            case 1042: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 1043:  option ::= no read_reduce$r optionWhite
            //
            case 1043: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 1046:  option ::= remap_terminals$r optionWhite
            //
            case 1046: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 1047:  option ::= no remap_terminals$r optionWhite
            //
            case 1047: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            }

            //
            // Rule 1050:  option ::= scopes$s optionWhite
            //
            case 1050: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1051:  option ::= no scopes$s optionWhite
            //
            case 1051: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1053:  option ::= serialize$s optionWhite
            //
            case 1053: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1054:  option ::= no serialize$s optionWhite
            //
            case 1054: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1056:  option ::= shift_default$s optionWhite
            //
            case 1056: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1057:  option ::= no shift_default$s optionWhite
            //
            case 1057: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1060:  option ::= single_productions$s optionWhite
            //
            case 1060: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1061:  option ::= no single_productions$s optionWhite
            //
            case 1061: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1064:  option ::= slr$s optionWhite
            //
            case 1064: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1065:  option ::= no slr$s optionWhite
            //
            case 1065: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1067:  option ::= soft_keywords$s optionWhite
            //
            case 1067: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1068:  option ::= no soft_keywords$s optionWhite
            //
            case 1068: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1072:  option ::= states$s optionWhite
            //
            case 1072: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1073:  option ::= no states$s optionWhite
            //
            case 1073: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1075:  option ::= suffix$s optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 1075: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 1077:  option ::= sym_file$sf optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 1077: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 1080:  option ::= tab_file$tf optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 1080: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 1083:  option ::= template$t optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 1083: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 1085:  option ::= trailers$t optionWhite =$eq optionWhite ($lp optionWhite filename$fn optionWhite ,$comma1 optionWhite block_begin$bb optionWhite ,$comma2 optionWhite block_end$be optionWhite )$rp optionWhite
            //
            case 1085: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_LEFT_PAREN);
                  makeToken(getRhsFirstTokenIndex(7), getRhsLastTokenIndex(7), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(9), getRhsLastTokenIndex(9), LPGParsersym.TK_COMMA);
                  makeToken(getRhsFirstTokenIndex(11), getRhsLastTokenIndex(11), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(13), getRhsLastTokenIndex(13), LPGParsersym.TK_COMMA);
                  makeToken(getRhsFirstTokenIndex(15), getRhsLastTokenIndex(15), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(17), getRhsLastTokenIndex(17), LPGParsersym.TK_RIGHT_PAREN);
                    break;
            }
      
            //
            // Rule 1087:  option ::= table$t optionWhite
            //
            case 1087: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1088:  option ::= no table$t optionWhite
            //
            case 1088: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1089:  option ::= table$t optionWhite =$eq optionWhite programming_language_value$val optionWhite
            //
            case 1089: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 1091:  option ::= trace$t optionWhite
            //
            case 1091: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1092:  option ::= no trace$t optionWhite
            //
            case 1092: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1093:  option ::= trace$t optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 1093: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 1095:  option ::= variables$v optionWhite
            //
            case 1095: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1096:  option ::= no variables$v optionWhite
            //
            case 1096: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1097:  option ::= variables$v optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 1097: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 1099:  option ::= verbose$v optionWhite
            //
            case 1099: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1100:  option ::= no verbose$v optionWhite
            //
            case 1100: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1102:  option ::= visitor$v optionWhite
            //
            case 1102: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1103:  option ::= no visitor$v optionWhite
            //
            case 1103: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1104:  option ::= visitor$v optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 1104: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 1106:  option ::= visitor_type$vt optionWhite =$eq optionWhite Value$val optionWhite
            //
            case 1106: { 
            
                  makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);
                  makeToken(getRhsFirstTokenIndex(3), getRhsLastTokenIndex(3), LPGParsersym.TK_EQUAL);
                  makeToken(getRhsFirstTokenIndex(5), getRhsLastTokenIndex(5), LPGParsersym.TK_SYMBOL);
                    break;
            }
      
            //
            // Rule 1109:  option ::= warnings$w optionWhite
            //
            case 1109: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1110:  option ::= no warnings$w optionWhite
            //
            case 1110: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1112:  option ::= xreference$x optionWhite
            //
            case 1112: { 
              makeToken(getRhsFirstTokenIndex(1), getRhsLastTokenIndex(1), LPGParsersym.TK_SYMBOL);             break;
            } 

            //
            // Rule 1113:  option ::= no xreference$x optionWhite
            //
            case 1113: { 
              makeToken(getRhsFirstTokenIndex(2), getRhsLastTokenIndex(2), LPGParsersym.TK_SYMBOL);             break;
            } 

    //#line 243 "LexerTemplateF.gi

    
            default:
                break;
        }
        return;
    }
}

    //#line 6 "LexerBasicMapF.gi
 
  class  LPGLexerLpgLexStream  extends LpgLexStream
    {
     static  final  List<int> tokenKind = [
        LPGLexersym.Char_CtlCharNotWS,    // 000    0x00
        LPGLexersym.Char_CtlCharNotWS,    // 001    0x01
        LPGLexersym.Char_CtlCharNotWS,    // 002    0x02
        LPGLexersym.Char_CtlCharNotWS,    // 003    0x03
        LPGLexersym.Char_CtlCharNotWS,    // 004    0x04
        LPGLexersym.Char_CtlCharNotWS,    // 005    0x05
        LPGLexersym.Char_CtlCharNotWS,    // 006    0x06
        LPGLexersym.Char_CtlCharNotWS,    // 007    0x07
        LPGLexersym.Char_CtlCharNotWS,    // 008    0x08
        LPGLexersym.Char_HT,              // 009    0x09
        LPGLexersym.Char_LF,              // 010    0x0A
        LPGLexersym.Char_CtlCharNotWS,    // 011    0x0B
        LPGLexersym.Char_FF,              // 012    0x0C
        LPGLexersym.Char_CR,              // 013    0x0D
        LPGLexersym.Char_CtlCharNotWS,    // 014    0x0E
        LPGLexersym.Char_CtlCharNotWS,    // 015    0x0F
        LPGLexersym.Char_CtlCharNotWS,    // 016    0x10
        LPGLexersym.Char_CtlCharNotWS,    // 017    0x11
        LPGLexersym.Char_CtlCharNotWS,    // 018    0x12
        LPGLexersym.Char_CtlCharNotWS,    // 019    0x13
        LPGLexersym.Char_CtlCharNotWS,    // 020    0x14
        LPGLexersym.Char_CtlCharNotWS,    // 021    0x15
        LPGLexersym.Char_CtlCharNotWS,    // 022    0x16
        LPGLexersym.Char_CtlCharNotWS,    // 023    0x17
        LPGLexersym.Char_CtlCharNotWS,    // 024    0x18
        LPGLexersym.Char_CtlCharNotWS,    // 025    0x19
        LPGLexersym.Char_CtlCharNotWS,    // 026    0x1A
        LPGLexersym.Char_CtlCharNotWS,    // 027    0x1B
        LPGLexersym.Char_CtlCharNotWS,    // 028    0x1C
        LPGLexersym.Char_CtlCharNotWS,    // 029    0x1D
        LPGLexersym.Char_CtlCharNotWS,    // 030    0x1E
        LPGLexersym.Char_CtlCharNotWS,    // 031    0x1F
        LPGLexersym.Char_Space,           // 032    0x20
        LPGLexersym.Char_Exclamation,     // 033    0x21
        LPGLexersym.Char_DoubleQuote,     // 034    0x22
        LPGLexersym.Char_Sharp,           // 035    0x23
        LPGLexersym.Char_DollarSign,      // 036    0x24
        LPGLexersym.Char_Percent,         // 037    0x25
        LPGLexersym.Char_Ampersand,       // 038    0x26
        LPGLexersym.Char_SingleQuote,     // 039    0x27
        LPGLexersym.Char_LeftParen,       // 040    0x28
        LPGLexersym.Char_RightParen,      // 041    0x29
        LPGLexersym.Char_Star,            // 042    0x2A
        LPGLexersym.Char_Plus,            // 043    0x2B
        LPGLexersym.Char_Comma,           // 044    0x2C
        LPGLexersym.Char_Minus,           // 045    0x2D
        LPGLexersym.Char_Dot,             // 046    0x2E
        LPGLexersym.Char_Slash,           // 047    0x2F
        LPGLexersym.Char_0,               // 048    0x30
        LPGLexersym.Char_1,               // 049    0x31
        LPGLexersym.Char_2,               // 050    0x32
        LPGLexersym.Char_3,               // 051    0x33
        LPGLexersym.Char_4,               // 052    0x34
        LPGLexersym.Char_5,               // 053    0x35
        LPGLexersym.Char_6,               // 054    0x36
        LPGLexersym.Char_7,               // 055    0x37
        LPGLexersym.Char_8,               // 056    0x38
        LPGLexersym.Char_9,               // 057    0x39
        LPGLexersym.Char_Colon,           // 058    0x3A
        LPGLexersym.Char_SemiColon,       // 059    0x3B
        LPGLexersym.Char_LessThan,        // 060    0x3C
        LPGLexersym.Char_Equal,           // 061    0x3D
        LPGLexersym.Char_GreaterThan,     // 062    0x3E
        LPGLexersym.Char_QuestionMark,    // 063    0x3F
        LPGLexersym.Char_AtSign,          // 064    0x40
        LPGLexersym.Char_A,               // 065    0x41
        LPGLexersym.Char_B,               // 066    0x42
        LPGLexersym.Char_C,               // 067    0x43
        LPGLexersym.Char_D,               // 068    0x44
        LPGLexersym.Char_E,               // 069    0x45
        LPGLexersym.Char_F,               // 070    0x46
        LPGLexersym.Char_G,               // 071    0x47
        LPGLexersym.Char_H,               // 072    0x48
        LPGLexersym.Char_I,               // 073    0x49
        LPGLexersym.Char_J,               // 074    0x4A
        LPGLexersym.Char_K,               // 075    0x4B
        LPGLexersym.Char_L,               // 076    0x4C
        LPGLexersym.Char_M,               // 077    0x4D
        LPGLexersym.Char_N,               // 078    0x4E
        LPGLexersym.Char_O,               // 079    0x4F
        LPGLexersym.Char_P,               // 080    0x50
        LPGLexersym.Char_Q,               // 081    0x51
        LPGLexersym.Char_R,               // 082    0x52
        LPGLexersym.Char_S,               // 083    0x53
        LPGLexersym.Char_T,               // 084    0x54
        LPGLexersym.Char_U,               // 085    0x55
        LPGLexersym.Char_V,               // 086    0x56
        LPGLexersym.Char_W,               // 087    0x57
        LPGLexersym.Char_X,               // 088    0x58
        LPGLexersym.Char_Y,               // 089    0x59
        LPGLexersym.Char_Z,               // 090    0x5A
        LPGLexersym.Char_LeftBracket,     // 091    0x5B
        LPGLexersym.Char_BackSlash,       // 092    0x5C
        LPGLexersym.Char_RightBracket,    // 093    0x5D
        LPGLexersym.Char_Caret,           // 094    0x5E
        LPGLexersym.Char__,               // 095    0x5F
        LPGLexersym.Char_BackQuote,       // 096    0x60
        LPGLexersym.Char_a,               // 097    0x61
        LPGLexersym.Char_b,               // 098    0x62
        LPGLexersym.Char_c,               // 099    0x63
        LPGLexersym.Char_d,               // 100    0x64
        LPGLexersym.Char_e,               // 101    0x65
        LPGLexersym.Char_f,               // 102    0x66
        LPGLexersym.Char_g,               // 103    0x67
        LPGLexersym.Char_h,               // 104    0x68
        LPGLexersym.Char_i,               // 105    0x69
        LPGLexersym.Char_j,               // 106    0x6A
        LPGLexersym.Char_k,               // 107    0x6B
        LPGLexersym.Char_l,               // 108    0x6C
        LPGLexersym.Char_m,               // 109    0x6D
        LPGLexersym.Char_n,               // 110    0x6E
        LPGLexersym.Char_o,               // 111    0x6F
        LPGLexersym.Char_p,               // 112    0x70
        LPGLexersym.Char_q,               // 113    0x71
        LPGLexersym.Char_r,               // 114    0x72
        LPGLexersym.Char_s,               // 115    0x73
        LPGLexersym.Char_t,               // 116    0x74
        LPGLexersym.Char_u,               // 117    0x75
        LPGLexersym.Char_v,               // 118    0x76
        LPGLexersym.Char_w,               // 119    0x77
        LPGLexersym.Char_x,               // 120    0x78
        LPGLexersym.Char_y,               // 121    0x79
        LPGLexersym.Char_z,               // 122    0x7A
        LPGLexersym.Char_LeftBrace,       // 123    0x7B
        LPGLexersym.Char_VerticalBar,     // 124    0x7C
        LPGLexersym.Char_RightBrace,      // 125    0x7D
        LPGLexersym.Char_Tilde,           // 126    0x7E

        LPGLexersym.Char_AfterASCII,      // for all chars in range 128..65534
        LPGLexersym.Char_EOF              // for '\uffff' or 65535 
    ];
            
     int  getKind(int i)// Classify character at ith location
    {
        var c = (i >= getStreamLength() ? 0xffff : getIntValue(i));
        return (c < 128 // ASCII Character
                  ? LPGLexerLpgLexStream.tokenKind[c]
                  : c == 0xffff 
                       ? LPGLexersym.Char_EOF
                       : LPGLexersym.Char_AfterASCII);
    }

    List<String> orderedExportedSymbols(){ return LPGParsersym.orderedTerminalSymbols; }

  
    LPGLexerLpgLexStream(String fileName, [String? inputChars,int tab=4])
    :super(fileName, inputChars, tab);
    }

