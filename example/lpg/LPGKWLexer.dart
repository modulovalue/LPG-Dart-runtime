
////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007 IBM Corporation.
// All rights reserved. This program and the accompanying materials
// are made available under the terms of the Eclipse Public License v1.0
// which accompanies this distribution, and is available at
// http://www.eclipse.org/legal/epl-v10.html
//
//Contributors:
//    Philippe Charles (pcharles@us.ibm.com) - initial API and implementation

////////////////////////////////////////////////////////////////////////////////


    //#line 24 "KeywordTemplateF.gi

import 'LPGKWLexerprs.dart';
import 'LPGKWLexersym.dart';
import 'LPGParsersym.dart';


    //#line 46 "LPGKWLexer.gi



    //#line 70 "KeywordTemplateF.gi

class LPGKWLexer extends LPGKWLexerprs
{
    late String inputChars;
    List<int> keywordKind  = List<int>.filled(29 + 1,0);

    List<int>  getKeywordKinds()  { return keywordKind; }

    int lexer(int curtok, int lasttok)  
    {
        var current_kind = LPGKWLexer.getKind(inputChars.codeUnitAt(curtok)),
            act=0;

        for (act = tAction(LPGKWLexerprs.START_STATE, current_kind);
             act > LPGKWLexerprs.NUM_RULES && act < LPGKWLexerprs.ACCEPT_ACTION;
             act = tAction(act, current_kind))
        {
            curtok++;
            current_kind = (curtok > lasttok
                                   ? LPGKWLexersym.Char_EOF
                                   : LPGKWLexer.getKind(inputChars.codeUnitAt(curtok)));
        }

        if (act > LPGKWLexerprs.ERROR_ACTION)
        {
            curtok++;
            act -= LPGKWLexerprs.ERROR_ACTION;
        }

        return keywordKind[ (act == LPGKWLexerprs.ERROR_ACTION  || curtok <= lasttok) ? 0 : act];
    }

    void setInputChars(String inputChars)  { this.inputChars = inputChars; }


    //#line 9 "KWLexerFoldedCaseMapF.gi

    //
    // Each upper case letter is mapped into its corresponding
    // lower case counterpart. For example, if an 'A' appears
    // in the input, it is mapped into LPGKWLexersym.Char_a just
    // like 'a'.
    //
    static  List<int> init_tokenKind() 
    {
        List<int> tokenKind =  List<int>.filled(128,0);
        tokenKind['\$'.codeUnitAt(0)] = LPGKWLexersym.Char_DollarSign;
        tokenKind['%'.codeUnitAt(0)] = LPGKWLexersym.Char_Percent;
        tokenKind['_'.codeUnitAt(0)] = LPGKWLexersym.Char__;

        tokenKind['a'.codeUnitAt(0)] = LPGKWLexersym.Char_a;
        tokenKind['b'.codeUnitAt(0)] = LPGKWLexersym.Char_b;
        tokenKind['c'.codeUnitAt(0)] = LPGKWLexersym.Char_c;
        tokenKind['d'.codeUnitAt(0)] = LPGKWLexersym.Char_d;
        tokenKind['e'.codeUnitAt(0)] = LPGKWLexersym.Char_e;
        tokenKind['f'.codeUnitAt(0)] = LPGKWLexersym.Char_f;
        tokenKind['g'.codeUnitAt(0)] = LPGKWLexersym.Char_g;
        tokenKind['h'.codeUnitAt(0)] = LPGKWLexersym.Char_h;
        tokenKind['i'.codeUnitAt(0)] = LPGKWLexersym.Char_i;
        tokenKind['j'.codeUnitAt(0)] = LPGKWLexersym.Char_j;
        tokenKind['k'.codeUnitAt(0)] = LPGKWLexersym.Char_k;
        tokenKind['l'.codeUnitAt(0)] = LPGKWLexersym.Char_l;
        tokenKind['m'.codeUnitAt(0)] = LPGKWLexersym.Char_m;
        tokenKind['n'.codeUnitAt(0)] = LPGKWLexersym.Char_n;
        tokenKind['o'.codeUnitAt(0)] = LPGKWLexersym.Char_o;
        tokenKind['p'.codeUnitAt(0)] = LPGKWLexersym.Char_p;
        tokenKind['q'.codeUnitAt(0)] = LPGKWLexersym.Char_q;
        tokenKind['r'.codeUnitAt(0)] = LPGKWLexersym.Char_r;
        tokenKind['s'.codeUnitAt(0)] = LPGKWLexersym.Char_s;
        tokenKind['t'.codeUnitAt(0)] = LPGKWLexersym.Char_t;
        tokenKind['u'.codeUnitAt(0)] = LPGKWLexersym.Char_u;
        tokenKind['v'.codeUnitAt(0)] = LPGKWLexersym.Char_v;
        tokenKind['w'.codeUnitAt(0)] = LPGKWLexersym.Char_w;
        tokenKind['x'.codeUnitAt(0)] = LPGKWLexersym.Char_x;
        tokenKind['y'.codeUnitAt(0)] = LPGKWLexersym.Char_y;
        tokenKind['z'.codeUnitAt(0)] = LPGKWLexersym.Char_z;

        tokenKind['A'.codeUnitAt(0)] = LPGKWLexersym.Char_a;
        tokenKind['B'.codeUnitAt(0)] = LPGKWLexersym.Char_b;
        tokenKind['C'.codeUnitAt(0)] = LPGKWLexersym.Char_c;
        tokenKind['D'.codeUnitAt(0)] = LPGKWLexersym.Char_d;
        tokenKind['E'.codeUnitAt(0)] = LPGKWLexersym.Char_e;
        tokenKind['F'.codeUnitAt(0)] = LPGKWLexersym.Char_f;
        tokenKind['G'.codeUnitAt(0)] = LPGKWLexersym.Char_g;
        tokenKind['H'.codeUnitAt(0)] = LPGKWLexersym.Char_h;
        tokenKind['I'.codeUnitAt(0)] = LPGKWLexersym.Char_i;
        tokenKind['J'.codeUnitAt(0)] = LPGKWLexersym.Char_j;
        tokenKind['K'.codeUnitAt(0)] = LPGKWLexersym.Char_k;
        tokenKind['L'.codeUnitAt(0)] = LPGKWLexersym.Char_l;
        tokenKind['M'.codeUnitAt(0)] = LPGKWLexersym.Char_m;
        tokenKind['N'.codeUnitAt(0)] = LPGKWLexersym.Char_n;
        tokenKind['O'.codeUnitAt(0)] = LPGKWLexersym.Char_o;
        tokenKind['P'.codeUnitAt(0)] = LPGKWLexersym.Char_p;
        tokenKind['Q'.codeUnitAt(0)] = LPGKWLexersym.Char_q;
        tokenKind['R'.codeUnitAt(0)] = LPGKWLexersym.Char_r;
        tokenKind['S'.codeUnitAt(0)] = LPGKWLexersym.Char_s;
        tokenKind['T'.codeUnitAt(0)] = LPGKWLexersym.Char_t;
        tokenKind['U'.codeUnitAt(0)] = LPGKWLexersym.Char_u;
        tokenKind['V'.codeUnitAt(0)] = LPGKWLexersym.Char_v;
        tokenKind['W'.codeUnitAt(0)] = LPGKWLexersym.Char_w;
        tokenKind['X'.codeUnitAt(0)] = LPGKWLexersym.Char_x;
        tokenKind['Y'.codeUnitAt(0)] = LPGKWLexersym.Char_y;
        tokenKind['Z'.codeUnitAt(0)] = LPGKWLexersym.Char_z;
        return tokenKind;
    }
    
    static  final List<int> tokenKind =  init_tokenKind(); 

    static  int getKind(int c )
    {
        return (c < 128 ? LPGKWLexer.tokenKind[c] : 0);
    }

    //#line 108 "KeywordTemplateF.gi


    LPGKWLexer(String inputChars, int identifierKind)
    {
        this.inputChars = inputChars;
        keywordKind[0] = identifierKind;

        //
        // Rule 1:  Keyword ::= KeyPrefix a l i a s
        //

        keywordKind[1] = (LPGParsersym.TK_ALIAS_KEY);
      
    
        //
        // Rule 2:  Keyword ::= KeyPrefix a s t
        //

        keywordKind[2] = (LPGParsersym.TK_AST_KEY);
      
    
        //
        // Rule 3:  Keyword ::= KeyPrefix d e f i n e
        //

        keywordKind[3] = (LPGParsersym.TK_DEFINE_KEY);
      
    
        //
        // Rule 4:  Keyword ::= KeyPrefix d i s j o i n t p r e d e c e s s o r s e t s
        //

        keywordKind[4] = (LPGParsersym.TK_DISJOINTPREDECESSORSETS_KEY);
      
    
        //
        // Rule 5:  Keyword ::= KeyPrefix d r o p r u l e s
        //

        keywordKind[5] = (LPGParsersym.TK_DROPRULES_KEY);
      
    
        //
        // Rule 6:  Keyword ::= KeyPrefix d r o p s y m b o l s
        //

        keywordKind[6] = (LPGParsersym.TK_DROPSYMBOLS_KEY);
      
    
        //
        // Rule 7:  Keyword ::= KeyPrefix e m p t y
        //

        keywordKind[7] = (LPGParsersym.TK_EMPTY_KEY);
      
    
        //
        // Rule 8:  Keyword ::= KeyPrefix e n d
        //

        keywordKind[8] = (LPGParsersym.TK_END_KEY);
      
    
        //
        // Rule 9:  Keyword ::= KeyPrefix e r r o r
        //

        keywordKind[9] = (LPGParsersym.TK_ERROR_KEY);
      
    
        //
        // Rule 10:  Keyword ::= KeyPrefix e o l
        //

        keywordKind[10] = (LPGParsersym.TK_EOL_KEY);
      
    
        //
        // Rule 11:  Keyword ::= KeyPrefix e o f
        //

        keywordKind[11] = (LPGParsersym.TK_EOF_KEY);
      
    
        //
        // Rule 12:  Keyword ::= KeyPrefix e x p o r t
        //

        keywordKind[12] = (LPGParsersym.TK_EXPORT_KEY);
      
    
        //
        // Rule 13:  Keyword ::= KeyPrefix g l o b a l s
        //

        keywordKind[13] = (LPGParsersym.TK_GLOBALS_KEY);
      
    
        //
        // Rule 14:  Keyword ::= KeyPrefix h e a d e r s
        //

        keywordKind[14] = (LPGParsersym.TK_HEADERS_KEY);
      
    
        //
        // Rule 15:  Keyword ::= KeyPrefix i d e n t i f i e r
        //

        keywordKind[15] = (LPGParsersym.TK_IDENTIFIER_KEY);
      
    
        //
        // Rule 16:  Keyword ::= KeyPrefix i m p o r t
        //

        keywordKind[16] = (LPGParsersym.TK_IMPORT_KEY);
      
    
        //
        // Rule 17:  Keyword ::= KeyPrefix i n c l u d e
        //

        keywordKind[17] = (LPGParsersym.TK_INCLUDE_KEY);
      
    
        //
        // Rule 18:  Keyword ::= KeyPrefix k e y w o r d s
        //

        keywordKind[18] = (LPGParsersym.TK_KEYWORDS_KEY);
      
    
        //
        // Rule 19:  Keyword ::= KeyPrefix s o f t k e y w o r d s
        //

        keywordKind[19] = (LPGParsersym.TK_SOFT_KEYWORDS_KEY);
      
    
        //
        // Rule 20:  Keyword ::= KeyPrefix n a m e s
        //

        keywordKind[20] = (LPGParsersym.TK_NAMES_KEY);
      
    
        //
        // Rule 21:  Keyword ::= KeyPrefix n o t i c e
        //

        keywordKind[21] = (LPGParsersym.TK_NOTICE_KEY);
      
    
        //
        // Rule 22:  Keyword ::= KeyPrefix t e r m i n a l s
        //

        keywordKind[22] = (LPGParsersym.TK_TERMINALS_KEY);
      
    
        //
        // Rule 23:  Keyword ::= KeyPrefix r e c o v e r
        //

        keywordKind[23] = (LPGParsersym.TK_RECOVER_KEY);
      
    
        //
        // Rule 24:  Keyword ::= KeyPrefix r u l e s
        //

        keywordKind[24] = (LPGParsersym.TK_RULES_KEY);
      
    
        //
        // Rule 25:  Keyword ::= KeyPrefix s t a r t
        //

        keywordKind[25] = (LPGParsersym.TK_START_KEY);
      
    
        //
        // Rule 26:  Keyword ::= KeyPrefix t r a i l e r s
        //

        keywordKind[26] = (LPGParsersym.TK_TRAILERS_KEY);
      
    
        //
        // Rule 27:  Keyword ::= KeyPrefix t y p e s
        //

        keywordKind[27] = (LPGParsersym.TK_TYPES_KEY);
      
    
    //#line 118 "KeywordTemplateF.gi

        for (var i = 0; i < keywordKind.length; i++)
        {
            if (keywordKind[i] == 0)
                keywordKind[i] = identifierKind;
        }
    }
}

