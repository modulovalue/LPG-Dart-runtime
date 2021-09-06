
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

class JavaLexersym {
static const int Char_CtlCharNotWS = 102;
static const int Char_LF = 100;
static const int Char_CR = 101;
static const int Char_HT = 37;
static const int Char_FF = 38;
static const int Char_a = 19;
static const int Char_b = 15;
static const int Char_c = 20;
static const int Char_d = 12;
static const int Char_e = 16;
static const int Char_f = 11;
static const int Char_g = 39;
static const int Char_h = 40;
static const int Char_i = 41;
static const int Char_j = 42;
static const int Char_k = 43;
static const int Char_l = 25;
static const int Char_m = 44;
static const int Char_n = 26;
static const int Char_o = 45;
static const int Char_p = 46;
static const int Char_q = 47;
static const int Char_r = 27;
static const int Char_s = 48;
static const int Char_t = 28;
static const int Char_u = 29;
static const int Char_v = 49;
static const int Char_w = 50;
static const int Char_x = 32;
static const int Char_y = 51;
static const int Char_z = 52;
static const int Char__ = 53;
static const int Char_A = 21;
static const int Char_B = 22;
static const int Char_C = 23;
static const int Char_D = 13;
static const int Char_E = 17;
static const int Char_F = 14;
static const int Char_G = 54;
static const int Char_H = 55;
static const int Char_I = 56;
static const int Char_J = 57;
static const int Char_K = 58;
static const int Char_L = 30;
static const int Char_M = 59;
static const int Char_N = 60;
static const int Char_O = 61;
static const int Char_P = 62;
static const int Char_Q = 63;
static const int Char_R = 64;
static const int Char_S = 65;
static const int Char_T = 66;
static const int Char_U = 67;
static const int Char_V = 68;
static const int Char_W = 69;
static const int Char_X = 33;
static const int Char_Y = 70;
static const int Char_Z = 71;
static const int Char_0 = 1;
static const int Char_1 = 2;
static const int Char_2 = 3;
static const int Char_3 = 4;
static const int Char_4 = 5;
static const int Char_5 = 6;
static const int Char_6 = 7;
static const int Char_7 = 8;
static const int Char_8 = 9;
static const int Char_9 = 10;
static const int Char_AfterASCII = 72;
static const int Char_Space = 73;
static const int Char_DoubleQuote = 34;
static const int Char_SingleQuote = 24;
static const int Char_Percent = 81;
static const int Char_VerticalBar = 74;
static const int Char_Exclamation = 82;
static const int Char_AtSign = 83;
static const int Char_BackQuote = 97;
static const int Char_Tilde = 84;
static const int Char_Sharp = 98;
static const int Char_DollarSign = 75;
static const int Char_Ampersand = 76;
static const int Char_Caret = 85;
static const int Char_Colon = 86;
static const int Char_SemiColon = 87;
static const int Char_BackSlash = 77;
static const int Char_LeftBrace = 88;
static const int Char_RightBrace = 89;
static const int Char_LeftBracket = 90;
static const int Char_RightBracket = 91;
static const int Char_QuestionMark = 92;
static const int Char_Comma = 93;
static const int Char_Dot = 31;
static const int Char_LessThan = 78;
static const int Char_GreaterThan = 94;
static const int Char_Plus = 35;
static const int Char_Minus = 36;
static const int Char_Slash = 79;
static const int Char_Star = 80;
static const int Char_LeftParen = 95;
static const int Char_RightParen = 96;
static const int Char_Equal = 18;
static const int Char_EOF = 99;

static const  List<String> orderedTerminalSymbols = [
    '',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'f',
    'd',
    'D',
    'F',
    'b',
    'e',
    'E',
    'Equal',
    'a',
    'c',
    'A',
    'B',
    'C',
    'SingleQuote',
    'l',
    'n',
    'r',
    't',
    'u',
    'L',
    'Dot',
    'x',
    'X',
    'DoubleQuote',
    'Plus',
    'Minus',
    'HT',
    'FF',
    'g',
    'h',
    'i',
    'j',
    'k',
    'm',
    'o',
    'p',
    'q',
    's',
    'v',
    'w',
    'y',
    'z',
    '_',
    'G',
    'H',
    'I',
    'J',
    'K',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'Y',
    'Z',
    'AfterASCII',
    'Space',
    'VerticalBar',
    'DollarSign',
    'Ampersand',
    'BackSlash',
    'LessThan',
    'Slash',
    'Star',
    'Percent',
    'Exclamation',
    'AtSign',
    'Tilde',
    'Caret',
    'Colon',
    'SemiColon',
    'LeftBrace',
    'RightBrace',
    'LeftBracket',
    'RightBracket',
    'QuestionMark',
    'Comma',
    'GreaterThan',
    'LeftParen',
    'RightParen',
    'BackQuote',
    'Sharp',
    'EOF',
    'LF',
    'CR',
    'CtlCharNotWS'
     ];

static const int numTokenKinds  = 102;
static const bool isValidForParser = true;
}
