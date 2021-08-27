--
-- The Java Lexer
--
%Options list
%Options fp=JavaLexer
%options single_productions
%options package=LpgJava
%options template=LexerTemplateF.gi
%options filter=GJavaKWLexer.gi

$Define
    --
    -- Definition of macro used in the included file LexerBasicMapB.g
    --
    $kw_lexer_class /.%GJavaKWLexer./

$End

$Include
    LexerBasicMapF.gi
$End

--$Include
--    Differ.g
--$End

$Export

    IDENTIFIER

    IntegerLiteral
    LongLiteral
    FloatingPointLiteral
    DoubleLiteral
    CharacterLiteral
    StringLiteral
    PLUS_PLUS
    MINUS_MINUS
    EQUAL_EQUAL
    LESS_EQUAL
    GREATER_EQUAL
    NOT_EQUAL
    LEFT_SHIFT
    RIGHT_SHIFT
    UNSIGNED_RIGHT_SHIFT
    PLUS_EQUAL
    MINUS_EQUAL
    MULTIPLY_EQUAL
    DIVIDE_EQUAL
    AND_EQUAL
    OR_EQUAL
    XOR_EQUAL
    REMAINDER_EQUAL
    LEFT_SHIFT_EQUAL
    RIGHT_SHIFT_EQUAL
    UNSIGNED_RIGHT_SHIFT_EQUAL
    OR_OR
    AND_AND
    PLUS
    MINUS
    NOT
    REMAINDER
    XOR
    AND
    MULTIPLY
    OR
    TWIDDLE
    DIVIDE
    GREATER
    LESS
    LPAREN
    RPAREN
    LBRACE
    RBRACE
    LBRACKET
    RBRACKET
    SEMICOLON
    QUESTION
    AT
    COLON
    COMMA
    DOT
    EQUAL
    ELLIPSIS

$End

$Terminals
    CtlCharNotWS

    LF   CR   HT   FF

    a    b    c    d    e    f    g    h    i    j    k    l    m
    n    o    p    q    r    s    t    u    v    w    x    y    z
    _

    A    B    C    D    E    F    G    H    I    J    K    L    M
    N    O    P    Q    R    S    T    U    V    W    X    Y    Z

    0    1    2    3    4    5    6    7    8    9

    AfterASCII   ::= '\u0080..\ufffe'
    Space        ::= ' '
    LF           ::= NewLine
    CR           ::= Return
    HT           ::= HorizontalTab
    FF           ::= FormFeed
    DoubleQuote  ::= '"'
    SingleQuote  ::= "'"
    Percent      ::= '%'
    VerticalBar  ::= '|'
    Exclamation  ::= '!'
    AtSign       ::= '@'
    BackQuote    ::= '`'
    Tilde        ::= '~'
    Sharp        ::= '#'
    DollarSign   ::= '$'
    Ampersand    ::= '&'
    Caret        ::= '^'
    Colon        ::= ':'
    SemiColon    ::= ';'
    BackSlash    ::= '\'
    LeftBrace    ::= '{'
    RightBrace   ::= '}'
    LeftBracket  ::= '['
    RightBracket ::= ']'
    QuestionMark ::= '?'
    Comma        ::= ','
    Dot          ::= '.'
    LessThan     ::= '<'
    GreaterThan  ::= '>'
    Plus         ::= '+'
    Minus        ::= '-'
    Slash        ::= '/'
    Star         ::= '*'
    LeftParen    ::= '('
    RightParen   ::= ')'
    Equal        ::= '='

$End

%Notice
/.
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
./
%End

$Rules

    Token ::= Identifier
        /.%BeginAction
                    this.checkForKeyWord();
          %EndAction
        ./
    Token ::= '"' SLBody '"'
        /.%BeginAction
                    this.makeToken(%_StringLiteral);
          %EndAction
        ./
    Token ::= "'" NotSQ "'"
        /.%BeginAction
                    this.makeToken(%_CharacterLiteral);
          %EndAction
        ./
    Token ::= IntegerLiteral
        /.%BeginAction
                    this.makeToken(%_IntegerLiteral);
          %EndAction
        ./
    Token ::= FloatingPointLiteral
        /.%BeginAction
                    this.makeToken(%_FloatingPointLiteral);
          %EndAction
        ./
    Token ::= DoubleLiteral
        /.%BeginAction
                    this.makeToken(%_DoubleLiteral);
          %EndAction
        ./
    Token ::= '/' '*' Inside Stars '/'
        /.%BeginAction
                    this.skipToken();
          %EndAction
        ./
    Token ::= SLC
        /.%BeginAction
                    this.skipToken();
          %EndAction
        ./
    Token ::= WS -- White Space is scanned but not added to output vector
        /.%BeginAction
                    this.skipToken();
          %EndAction
        ./
    Token ::= '+'
        /.%BeginAction
                    this.makeToken(%_PLUS);
          %EndAction
        ./
    Token ::= '-'
        /.%BeginAction
                    this.makeToken(%_MINUS);
          %EndAction
        ./

    Token ::= '*'
        /.%BeginAction
                    this.makeToken(%_MULTIPLY);
          %EndAction
        ./

    Token ::= '/'
        /.%BeginAction
                    this.makeToken(%_DIVIDE);
          %EndAction
        ./

    Token ::= '('
        /.%BeginAction
                    this.makeToken(%_LPAREN);
          %EndAction
        ./

    Token ::= ')'
        /.%BeginAction
                    this.makeToken(%_RPAREN);
          %EndAction
        ./

    Token ::= '='
        /.%BeginAction
                    this.makeToken(%_EQUAL);
          %EndAction
        ./

    Token ::= ','
        /.%BeginAction
                    this.makeToken(%_COMMA);
          %EndAction
        ./

    Token ::= ':'
        /.%BeginAction
                    this.makeToken(%_COLON);
          %EndAction
        ./

    Token ::= ';'
        /.%BeginAction
                    this.makeToken(%_SEMICOLON);
          %EndAction
        ./

    Token ::= '^'
        /.%BeginAction
                    this.makeToken(%_XOR);
          %EndAction
        ./

    Token ::= '%'
        /.%BeginAction
                    this.makeToken(%_REMAINDER);
          %EndAction
        ./

    Token ::= '~'
        /.%BeginAction
                    this.makeToken(%_TWIDDLE);
          %EndAction
        ./

    Token ::= '|'
        /.%BeginAction
                    this.makeToken(%_OR);
          %EndAction
        ./

    Token ::= '&'
        /.%BeginAction
                    this.makeToken(%_AND);
          %EndAction
        ./

    Token ::= '<'
        /.%BeginAction
                    this.makeToken(%_LESS);
          %EndAction
        ./

    Token ::= '>'
        /.%BeginAction
                    this.makeToken(%_GREATER);
          %EndAction
        ./

    Token ::= '.'
        /.%BeginAction
                    this.makeToken(%_DOT);
          %EndAction
        ./

    Token ::= '!'
        /.%BeginAction
                    this.makeToken(%_NOT);
          %EndAction
        ./

    Token ::= '['
        /.%BeginAction
                    this.makeToken(%_LBRACKET);
          %EndAction
        ./

    Token ::= ']'
        /.%BeginAction
                    this.makeToken(%_RBRACKET);
          %EndAction
        ./

    Token ::= '{'
        /.%BeginAction
                    this.makeToken(%_LBRACE);
          %EndAction
        ./

    Token ::= '}'
        /.%BeginAction
                    this.makeToken(%_RBRACE);
          %EndAction
        ./

    Token ::= '?'
        /.%BeginAction
                    this.makeToken(%_QUESTION);
          %EndAction
        ./

    Token ::= '@'
        /.%BeginAction
                    this.makeToken(%_AT);
          %EndAction
        ./

    Token ::= '+' '+'
        /.%BeginAction
                    this.makeToken(%_PLUS_PLUS);
          %EndAction
        ./

    Token ::= '-' '-'
        /.%BeginAction
                    this.makeToken(%_MINUS_MINUS);
          %EndAction
        ./

    Token ::= '=' '='
        /.%BeginAction
                    this.makeToken(%_EQUAL_EQUAL);
          %EndAction
        ./

    Token ::= '<' '='
        /.%BeginAction
                    this.makeToken(%_LESS_EQUAL);
          %EndAction
        ./

    Token ::= '!' '='
        /.%BeginAction
                    this.makeToken(%_NOT_EQUAL);
          %EndAction
        ./

    Token ::= '<' '<'
        /.%BeginAction
                    this.makeToken(%_LEFT_SHIFT);
          %EndAction
        ./

    Token ::= '+' '='
        /.%BeginAction
                    this.makeToken(%_PLUS_EQUAL);
          %EndAction
        ./

    Token ::= '-' '='
        /.%BeginAction
                    this.makeToken(%_MINUS_EQUAL);
          %EndAction
        ./

    Token ::= '*' '='
        /.%BeginAction
                    this.makeToken(%_MULTIPLY_EQUAL);
          %EndAction
        ./

    Token ::= '/' '='
        /.%BeginAction
                    this.makeToken(%_DIVIDE_EQUAL);
          %EndAction
        ./

    Token ::= '&' '='
        /.%BeginAction
                    this.makeToken(%_AND_EQUAL);
          %EndAction
        ./

    Token ::= '|' '='
        /.%BeginAction
                    this.makeToken(%_OR_EQUAL);
          %EndAction
        ./

    Token ::= '^' '='
        /.%BeginAction
                    this.makeToken(%_XOR_EQUAL);
          %EndAction
        ./

    Token ::= '%' '='
        /.%BeginAction
                    this.makeToken(%_REMAINDER_EQUAL);
          %EndAction
        ./

    Token ::= '<' '<' '='
        /.%BeginAction
                    this.makeToken(%_LEFT_SHIFT_EQUAL);
          %EndAction
        ./

    Token ::= '|' '|'
        /.%BeginAction
                    this.makeToken(%_OR_OR);
          %EndAction
        ./

    Token ::= '&' '&'
        /.%BeginAction
                    this.makeToken(%_AND_AND);
          %EndAction
        ./

    Token ::= '.' '.' '.'
        /.%BeginAction
                    this.makeToken(%_ELLIPSIS);
          %EndAction
        ./

    IntegerLiteral -> Integer
                    | Integer LetterLl
                    | '0' LetterXx HexDigits
                    | '0' LetterXx HexDigits LetterLl

    DoubleLiteral -> Decimal
                   | Decimal LetterForD
                   | Decimal Exponent
                   | Decimal Exponent LetterForD
                   | Integer Exponent
                   | Integer Exponent LetterForD
                   | Integer LetterForD

    FloatingPointLiteral -> Decimal LetterForF
                          | Decimal Exponent LetterForF
                          | Integer Exponent LetterForF
                          | Integer LetterForF

    Inside ::= Inside Stars NotSlashOrStar
             | Inside '/'
             | Inside NotSlashOrStar
             | $empty

    Stars -> '*'
           | Stars '*'

    SLC ::= '/' '/'
          | SLC NotEol

    SLBody -> $empty
            | SLBody NotDQ

    Integer -> Digit
             | Integer Digit

    HexDigits -> HexDigit
               | HexDigits HexDigit

    Decimal ::= '.' Integer
              | Integer '.'
              | Integer '.' Integer

    Exponent ::= LetterEe Integer
               | LetterEe '+' Integer
               | LetterEe '-' Integer

    WSChar -> Space
            | LF
            | CR
            | HT
            | FF

    Letter -> LowerCaseLetter
            | UpperCaseLetter
            | _
            | '$'
            | '\u0080..\ufffe'

    LowerCaseLetter -> a | b | c | d | e | f | g | h | i | j | k | l | m |
                       n | o | p | q | r | s | t | u | v | w | x | y | z

    UpperCaseLetter -> A | B | C | D | E | F | G | H | I | J | K | L | M |
                       N | O | P | Q | R | S | T | U | V | W | X | Y | Z

    Digit -> 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9

    OctalDigit -> 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7

    a..f -> a | b | c | d | e | f | A | B | C | D | E | F

    HexDigit -> Digit
              | a..f

    OctalDigits3 -> OctalDigit
                  | OctalDigit OctalDigit
                  | OctalDigit OctalDigit OctalDigit

    LetterForD -> 'D'
                | 'd'

    LetterForF -> 'F'
                | 'f'

    LetterLl ->  'L'
              | 'l'

    LetterEe -> 'E'
              | 'e'

    LetterXx -> 'X'
              | 'x'

    WS -> WSChar
        | WS WSChar

    Identifier -> Letter
                | Identifier Letter
                | Identifier Digit

    SpecialNotStar -> '+' | '-' | '/' | '(' | ')' | '"' | '!' | '@' | '`' | '~' |
                      '%' | '&' | '^' | ':' | ';' | "'" | '\' | '|' | '{' | '}' |
                      '[' | ']' | '?' | ',' | '.' | '<' | '>' | '=' | '#'

    SpecialNotSlash -> '+' | '-' | -- exclude the star as well
                       '(' | ')' | '"' | '!' | '@' | '`' | '~' |
                       '%' | '&' | '^' | ':' | ';' | "'" | '\' | '|' | '{' | '}' |
                       '[' | ']' | '?' | ',' | '.' | '<' | '>' | '=' | '#'

    SpecialNotDQ -> '+' | '-' | '/' | '(' | ')' | '*' | '!' | '@' | '`' | '~' |
                    '%' | '&' | '^' | ':' | ';' | "'" | '|' | '{' | '}' |
                    '[' | ']' | '?' | ',' | '.' | '<' | '>' | '=' | '#'

    SpecialNotSQ -> '+' | '-' | '*' | '(' | ')' | '"' | '!' | '@' | '`' | '~' |
                    '%' | '&' | '^' | ':' | ';' | '/' | '|' | '{' | '}' |
                    '[' | ']' | '?' | ',' | '.' | '<' | '>' | '=' | '#'

    NotSlashOrStar -> Letter
                    | Digit
                    | SpecialNotSlash
                    | WSChar

    Eol -> LF
         | CR

    NotEol -> Letter
            | Digit
            | Space
            | '*'
            | SpecialNotStar
            | HT
            | FF
            | CtlCharNotWS

    NotDQ -> Letter
           | Digit
           | SpecialNotDQ
           | Space
           | HT
           | FF
           | EscapeSequence
           | '\' u HexDigit HexDigit HexDigit HexDigit
           | '\' OctalDigit

    NotSQ -> Letter
           | Digit
           | SpecialNotSQ
           | Space
           | HT
           | FF
           | EscapeSequence
           | '\' u HexDigit HexDigit HexDigit HexDigit
           | '\' OctalDigits3

    EscapeSequence -> '\' b
                    | '\' t
                    | '\' n
                    | '\' f
                    | '\' r
                    | '\' '"'
                    | '\' "'"
                    | '\' '\'
$End
