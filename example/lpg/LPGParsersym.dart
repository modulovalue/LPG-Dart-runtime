class LPGParsersym {
static const int TK_EQUIVALENCE = 5;
static const int TK_PRIORITY_EQUIVALENCE = 6;
static const int TK_ARROW = 7;
static const int TK_PRIORITY_ARROW = 8;
static const int TK_OR_MARKER = 14;
static const int TK_EQUAL = 38;
static const int TK_COMMA = 37;
static const int TK_LEFT_PAREN = 39;
static const int TK_RIGHT_PAREN = 40;
static const int TK_LEFT_BRACKET = 42;
static const int TK_RIGHT_BRACKET = 43;
static const int TK_SHARP = 44;
static const int TK_ALIAS_KEY = 15;
static const int TK_AST_KEY = 16;
static const int TK_DEFINE_KEY = 17;
static const int TK_DISJOINTPREDECESSORSETS_KEY = 18;
static const int TK_DROPRULES_KEY = 19;
static const int TK_DROPSYMBOLS_KEY = 20;
static const int TK_EMPTY_KEY = 12;
static const int TK_END_KEY = 3;
static const int TK_ERROR_KEY = 9;
static const int TK_EOL_KEY = 10;
static const int TK_EOF_KEY = 13;
static const int TK_EXPORT_KEY = 21;
static const int TK_GLOBALS_KEY = 22;
static const int TK_HEADERS_KEY = 23;
static const int TK_IDENTIFIER_KEY = 11;
static const int TK_IMPORT_KEY = 24;
static const int TK_INCLUDE_KEY = 25;
static const int TK_KEYWORDS_KEY = 26;
static const int TK_NAMES_KEY = 27;
static const int TK_NOTICE_KEY = 28;
static const int TK_OPTIONS_KEY = 41;
static const int TK_RECOVER_KEY = 29;
static const int TK_RULES_KEY = 30;
static const int TK_SOFT_KEYWORDS_KEY = 31;
static const int TK_START_KEY = 32;
static const int TK_TERMINALS_KEY = 33;
static const int TK_TRAILERS_KEY = 34;
static const int TK_TYPES_KEY = 35;
static const int TK_EOF_TOKEN = 36;
static const int TK_SINGLE_LINE_COMMENT = 45;
static const int TK_MACRO_NAME = 2;
static const int TK_SYMBOL = 1;
static const int TK_BLOCK = 4;
static const int TK_VBAR = 46;
static const int TK_ERROR_TOKEN = 47;

static const  List<String> orderedTerminalSymbols = [
    '',
    'SYMBOL',
    'MACRO_NAME',
    'END_KEY',
    'BLOCK',
    'EQUIVALENCE',
    'PRIORITY_EQUIVALENCE',
    'ARROW',
    'PRIORITY_ARROW',
    'ERROR_KEY',
    'EOL_KEY',
    'IDENTIFIER_KEY',
    'EMPTY_KEY',
    'EOF_KEY',
    'OR_MARKER',
    'ALIAS_KEY',
    'AST_KEY',
    'DEFINE_KEY',
    'DISJOINTPREDECESSORSETS_KEY',
    'DROPRULES_KEY',
    'DROPSYMBOLS_KEY',
    'EXPORT_KEY',
    'GLOBALS_KEY',
    'HEADERS_KEY',
    'IMPORT_KEY',
    'INCLUDE_KEY',
    'KEYWORDS_KEY',
    'NAMES_KEY',
    'NOTICE_KEY',
    'RECOVER_KEY',
    'RULES_KEY',
    'SOFT_KEYWORDS_KEY',
    'START_KEY',
    'TERMINALS_KEY',
    'TRAILERS_KEY',
    'TYPES_KEY',
    'EOF_TOKEN',
    'COMMA',
    'EQUAL',
    'LEFT_PAREN',
    'RIGHT_PAREN',
    'OPTIONS_KEY',
    'LEFT_BRACKET',
    'RIGHT_BRACKET',
    'SHARP',
    'SINGLE_LINE_COMMENT',
    'VBAR',
    'ERROR_TOKEN'
     ];

static const int numTokenKinds  = 47;
static const bool isValidForParser = true;
}
