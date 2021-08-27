
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

class LPGLexersym {
static const int Char_CtlCharNotWS = 102;
static const int Char_LF = 5;
static const int Char_CR = 6;
static const int Char_HT = 1;
static const int Char_FF = 2;
static const int Char_a = 15;
static const int Char_b = 38;
static const int Char_c = 24;
static const int Char_d = 28;
static const int Char_e = 7;
static const int Char_f = 29;
static const int Char_g = 42;
static const int Char_h = 50;
static const int Char_i = 13;
static const int Char_j = 70;
static const int Char_k = 44;
static const int Char_l = 18;
static const int Char_m = 36;
static const int Char_n = 32;
static const int Char_o = 22;
static const int Char_p = 33;
static const int Char_q = 56;
static const int Char_r = 11;
static const int Char_s = 20;
static const int Char_t = 9;
static const int Char_u = 40;
static const int Char_v = 51;
static const int Char_w = 52;
static const int Char_x = 48;
static const int Char_y = 45;
static const int Char_z = 68;
static const int Char__ = 26;
static const int Char_A = 16;
static const int Char_B = 39;
static const int Char_C = 25;
static const int Char_D = 30;
static const int Char_E = 8;
static const int Char_F = 31;
static const int Char_G = 43;
static const int Char_H = 53;
static const int Char_I = 14;
static const int Char_J = 71;
static const int Char_K = 46;
static const int Char_L = 19;
static const int Char_M = 37;
static const int Char_N = 34;
static const int Char_O = 23;
static const int Char_P = 35;
static const int Char_Q = 57;
static const int Char_R = 12;
static const int Char_S = 21;
static const int Char_T = 10;
static const int Char_U = 41;
static const int Char_V = 54;
static const int Char_W = 55;
static const int Char_X = 49;
static const int Char_Y = 47;
static const int Char_Z = 69;
static const int Char_0 = 58;
static const int Char_1 = 59;
static const int Char_2 = 60;
static const int Char_3 = 61;
static const int Char_4 = 62;
static const int Char_5 = 63;
static const int Char_6 = 64;
static const int Char_7 = 65;
static const int Char_8 = 66;
static const int Char_9 = 67;
static const int Char_AfterASCII = 72;
static const int Char_Space = 3;
static const int Char_DoubleQuote = 97;
static const int Char_SingleQuote = 98;
static const int Char_Percent = 74;
static const int Char_VerticalBar = 76;
static const int Char_Exclamation = 77;
static const int Char_AtSign = 78;
static const int Char_BackQuote = 79;
static const int Char_Tilde = 80;
static const int Char_Sharp = 92;
static const int Char_DollarSign = 100;
static const int Char_Ampersand = 81;
static const int Char_Caret = 82;
static const int Char_Colon = 83;
static const int Char_SemiColon = 84;
static const int Char_BackSlash = 85;
static const int Char_LeftBrace = 86;
static const int Char_RightBrace = 87;
static const int Char_LeftBracket = 93;
static const int Char_RightBracket = 94;
static const int Char_QuestionMark = 73;
static const int Char_Comma = 4;
static const int Char_Dot = 88;
static const int Char_LessThan = 99;
static const int Char_GreaterThan = 95;
static const int Char_Plus = 89;
static const int Char_Minus = 27;
static const int Char_Slash = 90;
static const int Char_Star = 91;
static const int Char_LeftParen = 96;
static const int Char_RightParen = 75;
static const int Char_Equal = 17;
static const int Char_EOF = 101;

static const  List<String> orderedTerminalSymbols = [
    '',
    'HT',
    'FF',
    'Space',
    'Comma',
    'LF',
    'CR',
    'e',
    'E',
    't',
    'T',
    'r',
    'R',
    'i',
    'I',
    'a',
    'A',
    'Equal',
    'l',
    'L',
    's',
    'S',
    'o',
    'O',
    'c',
    'C',
    '_',
    'Minus',
    'd',
    'f',
    'D',
    'F',
    'n',
    'p',
    'N',
    'P',
    'm',
    'M',
    'b',
    'B',
    'u',
    'U',
    'g',
    'G',
    'k',
    'y',
    'K',
    'Y',
    'x',
    'X',
    'h',
    'v',
    'w',
    'H',
    'V',
    'W',
    'q',
    'Q',
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
    'z',
    'Z',
    'j',
    'J',
    'AfterASCII',
    'QuestionMark',
    'Percent',
    'RightParen',
    'VerticalBar',
    'Exclamation',
    'AtSign',
    'BackQuote',
    'Tilde',
    'Ampersand',
    'Caret',
    'Colon',
    'SemiColon',
    'BackSlash',
    'LeftBrace',
    'RightBrace',
    'Dot',
    'Plus',
    'Slash',
    'Star',
    'Sharp',
    'LeftBracket',
    'RightBracket',
    'GreaterThan',
    'LeftParen',
    'DoubleQuote',
    'SingleQuote',
    'LessThan',
    'DollarSign',
    'EOF',
    'CtlCharNotWS'
     ];

static const int numTokenKinds  = 103;
static const bool isValidForParser = true;
}
