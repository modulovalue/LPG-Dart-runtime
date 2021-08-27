//
// This is the grammar specification from the Final Draft of the generic spec.
//
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

class JavaParsersym {
static const int TK_ClassBodyDeclarationsoptMarker = 102;
static const int TK_LPGUserActionMarker = 103;
static const int TK_IntegerLiteral = 32;
static const int TK_LongLiteral = 33;
static const int TK_FloatingPointLiteral = 34;
static const int TK_DoubleLiteral = 35;
static const int TK_CharacterLiteral = 36;
static const int TK_StringLiteral = 37;
static const int TK_MINUS_MINUS = 26;
static const int TK_OR = 86;
static const int TK_MINUS = 46;
static const int TK_MINUS_EQUAL = 72;
static const int TK_NOT = 48;
static const int TK_NOT_EQUAL = 87;
static const int TK_REMAINDER = 88;
static const int TK_REMAINDER_EQUAL = 73;
static const int TK_AND = 68;
static const int TK_AND_AND = 89;
static const int TK_AND_EQUAL = 74;
static const int TK_LPAREN = 3;
static const int TK_RPAREN = 20;
static const int TK_MULTIPLY = 69;
static const int TK_MULTIPLY_EQUAL = 75;
static const int TK_COMMA = 43;
static const int TK_DOT = 42;
static const int TK_DIVIDE = 90;
static const int TK_DIVIDE_EQUAL = 76;
static const int TK_COLON = 50;
static const int TK_SEMICOLON = 4;
static const int TK_QUESTION = 91;
static const int TK_AT = 1;
static const int TK_LBRACKET = 23;
static const int TK_RBRACKET = 53;
static const int TK_XOR = 92;
static const int TK_XOR_EQUAL = 77;
static const int TK_LBRACE = 27;
static const int TK_OR_OR = 95;
static const int TK_OR_EQUAL = 78;
static const int TK_RBRACE = 45;
static const int TK_TWIDDLE = 49;
static const int TK_PLUS = 47;
static const int TK_PLUS_PLUS = 28;
static const int TK_PLUS_EQUAL = 79;
static const int TK_LESS = 24;
static const int TK_LEFT_SHIFT = 70;
static const int TK_LEFT_SHIFT_EQUAL = 80;
static const int TK_LESS_EQUAL = 81;
static const int TK_EQUAL = 51;
static const int TK_EQUAL_EQUAL = 93;
static const int TK_GREATER = 44;
static const int TK_GREATER_EQUAL = 112;
static const int TK_RIGHT_SHIFT = 113;
static const int TK_RIGHT_SHIFT_EQUAL = 114;
static const int TK_UNSIGNED_RIGHT_SHIFT = 115;
static const int TK_UNSIGNED_RIGHT_SHIFT_EQUAL = 116;
static const int TK_ELLIPSIS = 96;
static const int TK_BeginAction = 104;
static const int TK_EndAction = 105;
static const int TK_BeginJava = 106;
static const int TK_EndJava = 107;
static const int TK_NoAction = 108;
static const int TK_NullAction = 109;
static const int TK_BadAction = 110;
static const int TK_abstract = 17;
static const int TK_assert = 57;
static const int TK_boolean = 5;
static const int TK_break = 58;
static const int TK_byte = 6;
static const int TK_case = 71;
static const int TK_catch = 97;
static const int TK_char = 7;
static const int TK_class = 31;
static const int TK_const = 117;
static const int TK_continue = 59;
static const int TK_default = 67;
static const int TK_do = 60;
static const int TK_double = 8;
static const int TK_enum = 41;
static const int TK_else = 94;
static const int TK_extends = 82;
static const int TK_false = 38;
static const int TK_final = 19;
static const int TK_finally = 98;
static const int TK_float = 9;
static const int TK_for = 61;
static const int TK_goto = 118;
static const int TK_if = 62;
static const int TK_implements = 111;
static const int TK_import = 99;
static const int TK_instanceof = 83;
static const int TK_int = 10;
static const int TK_interface = 21;
static const int TK_long = 11;
static const int TK_native = 84;
static const int TK_new = 29;
static const int TK_null = 39;
static const int TK_package = 100;
static const int TK_private = 14;
static const int TK_protected = 15;
static const int TK_public = 12;
static const int TK_return = 63;
static const int TK_short = 13;
static const int TK_static = 16;
static const int TK_strictfp = 18;
static const int TK_super = 25;
static const int TK_switch = 64;
static const int TK_synchronized = 52;
static const int TK_this = 30;
static const int TK_throw = 65;
static const int TK_throws = 101;
static const int TK_transient = 54;
static const int TK_true = 40;
static const int TK_try = 66;
static const int TK_void = 22;
static const int TK_volatile = 55;
static const int TK_while = 56;
static const int TK_EOF_TOKEN = 85;
static const int TK_IDENTIFIER = 2;
static const int TK_ERROR_TOKEN = 119;

static const  List<String> orderedTerminalSymbols = [
    '',
    'AT',
    'IDENTIFIER',
    'LPAREN',
    'SEMICOLON',
    'boolean',
    'byte',
    'char',
    'double',
    'float',
    'int',
    'long',
    'public',
    'short',
    'private',
    'protected',
    'static',
    'abstract',
    'strictfp',
    'final',
    'RPAREN',
    'interface',
    'void',
    'LBRACKET',
    'LESS',
    'super',
    'MINUS_MINUS',
    'LBRACE',
    'PLUS_PLUS',
    'new',
    'this',
    'class',
    'IntegerLiteral',
    'LongLiteral',
    'FloatingPointLiteral',
    'DoubleLiteral',
    'CharacterLiteral',
    'StringLiteral',
    'false',
    'null',
    'true',
    'enum',
    'DOT',
    'COMMA',
    'GREATER',
    'RBRACE',
    'MINUS',
    'PLUS',
    'NOT',
    'TWIDDLE',
    'COLON',
    'EQUAL',
    'synchronized',
    'RBRACKET',
    'transient',
    'volatile',
    'while',
    'assert',
    'break',
    'continue',
    'do',
    'for',
    'if',
    'return',
    'switch',
    'throw',
    'try',
    'default',
    'AND',
    'MULTIPLY',
    'LEFT_SHIFT',
    'case',
    'MINUS_EQUAL',
    'REMAINDER_EQUAL',
    'AND_EQUAL',
    'MULTIPLY_EQUAL',
    'DIVIDE_EQUAL',
    'XOR_EQUAL',
    'OR_EQUAL',
    'PLUS_EQUAL',
    'LEFT_SHIFT_EQUAL',
    'LESS_EQUAL',
    'extends',
    'instanceof',
    'native',
    'EOF_TOKEN',
    'OR',
    'NOT_EQUAL',
    'REMAINDER',
    'AND_AND',
    'DIVIDE',
    'QUESTION',
    'XOR',
    'EQUAL_EQUAL',
    'else',
    'OR_OR',
    'ELLIPSIS',
    'catch',
    'finally',
    'import',
    'package',
    'throws',
    'ClassBodyDeclarationsoptMarker',
    'LPGUserActionMarker',
    'BeginAction',
    'EndAction',
    'BeginJava',
    'EndJava',
    'NoAction',
    'NullAction',
    'BadAction',
    'implements',
    'GREATER_EQUAL',
    'RIGHT_SHIFT',
    'RIGHT_SHIFT_EQUAL',
    'UNSIGNED_RIGHT_SHIFT',
    'UNSIGNED_RIGHT_SHIFT_EQUAL',
    'const',
    'goto',
    'ERROR_TOKEN'
     ];

static const int numTokenKinds  = 120;
static const bool isValidForParser = true;
}
