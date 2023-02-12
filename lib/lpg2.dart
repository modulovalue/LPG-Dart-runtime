// ignore_for_file: parameter_assignments, unnecessary_final, avoid_catching_errors

import 'dart:convert';
import 'dart:io';
import 'dart:math';

// region interfaces
abstract class IAbstractArrayList<T> {
  int size();

  T getElementAt(
    final int i,
  );

  ArrayList<T> getList();

  bool add(
    final T elt,
  );

  ArrayList<T> getAllChildren();
}

abstract class IAst {
  IAst? getNextAst();

  IAst? getParent();

  IToken getLeftIToken();

  IToken getRightIToken();

  List<IToken> getPrecedingAdjuncts();

  List<IToken> getFollowingAdjuncts();

  ArrayList<dynamic> getChildren();

  ArrayList<dynamic> getAllChildren();

  void accept(
    final IAstVisitor v,
  );
}

abstract class IAstVisitor {
  bool preVisit(final IAst element);

  void postVisit(final IAst element);
}

abstract class Monitor {
  bool isCancelled();
}

abstract class AbstractToken implements IToken {
  int kind = 0;
  int startOffset = 0;
  int endOffset = 0;
  int tokenIndex = 0;
  int adjunctIndex = 0;
  IPrsStream? iPrsStream;

  AbstractToken(
    this.startOffset,
    this.endOffset,
    this.kind,
    this.iPrsStream,
  );

  @override
  int getKind() {
    return kind;
  }

  @override
  void setKind(final int kind) {
    this.kind = kind;
  }

  @override
  int getStartOffset() {
    return startOffset;
  }

  @override
  void setStartOffset(final int startOffset) {
    this.startOffset = startOffset;
  }

  @override
  int getEndOffset() {
    return endOffset;
  }

  @override
  void setEndOffset(final int endOffset) {
    this.endOffset = endOffset;
  }

  @override
  int getTokenIndex() {
    return tokenIndex;
  }

  @override
  void setTokenIndex(final int tokenIndex) {
    this.tokenIndex = tokenIndex;
  }

  @override
  void setAdjunctIndex(final int adjunctIndex) {
    this.adjunctIndex = adjunctIndex;
  }

  @override
  int getAdjunctIndex() {
    return adjunctIndex;
  }

  @override
  IPrsStream? getIPrsStream() {
    return iPrsStream;
  }

  @override
  ILexStream? getILexStream() {
    return iPrsStream == null ? null : iPrsStream!.getILexStream();
  }

  @override
  int getLine() {
    return iPrsStream == null
        ? 0
        : iPrsStream!.getILexStream().getLineNumberOfCharAt(startOffset);
  }

  @override
  int getColumn() {
    return iPrsStream == null
        ? 0
        : iPrsStream!.getILexStream().getColumnOfCharAt(startOffset);
  }

  @override
  int getEndLine() {
    return iPrsStream == null
        ? 0
        : iPrsStream!.getILexStream().getLineNumberOfCharAt(endOffset);
  }

  @override
  int getEndColumn() {
    return iPrsStream == null
        ? 0
        : iPrsStream!.getILexStream().getColumnOfCharAt(endOffset);
  }

  @override
  String toString() {
    return iPrsStream == null
        ? '<toString>'
        : iPrsStream!.toStringFromToken(this, this);
  }
}

abstract class IMessageHandler {
  /// When a location is undefined, the value of its offset is 0.
  void handleMessage(
    final int errorCode,
    final Location msgLocation,
    final Location errorLocation,
    final String filename,
    final List<String> errorInfo,
  );
}
// endregion

// region abstracts
abstract class LpgLexStream extends LexStream {
  LpgLexStream(
    final String fileName, [
    final String? inputChars,
    final int tab = LexStream.DEFAULT_TAB,
    final IntSegmentedTuple? lineOffsets,
  ]) : super(fileName, inputChars, tab, lineOffsets);
}

abstract class ParseTable {
  int baseCheck(final int index);

  int rhs(final int index);

  int baseAction(final int index);

  int lhs(final int index);

  int termCheck(final int index);

  int termAction(final int index);

  int asb(final int index);

  int asr(final int index);

  int nasb(final int index);

  int nasr(final int index);

  int terminalIndex(final int index);

  int nonterminalIndex(final int index);

  int scopePrefix(final int index);

  int scopeSuffix(final int index);

  int scopeLhs(final int index);

  int scopeLa(final int index);

  int scopeStateSet(final int index);

  int scopeRhs(final int index);

  int scopeState(final int index);

  int inSymb(final int index);

  String name(final int index);

  int originalState(final int state);

  int asi(final int state);

  int nasi(final int state);

  int inSymbol(final int state);

  int ntAction(final int state, final int sym);

  int tAction(final int act, final int sym);

  int lookAhead(final int act, final int sym);

  int getErrorSymbol();

  int getScopeUbound();

  int getScopeSize();

  int getMaxNameLength();

  int getNumStates();

  int getNtOffset();

  int getLaStateOffset();

  int getMaxLa();

  int getNumRules();

  int getNumNonterminals();

  int getNumSymbols();

  int getStartState();

  int getStartSymbol();

  int getEoftSymbol();

  int getEoltSymbol();

  int getAcceptAction();

  int getErrorAction();

  bool isNullable(final int symbol);

  bool isValidForParser();

  bool getBacktrack();
}

abstract class IToken {
  int getKind();

  void setKind(final int kind);

  int getStartOffset();

  void setStartOffset(final int startOffset);

  int getEndOffset();

  void setEndOffset(final int endOffset);

  int getTokenIndex();

  void setTokenIndex(final int i);

  int getAdjunctIndex();

  void setAdjunctIndex(final int i);

  List<IToken> getPrecedingAdjuncts();

  List<IToken> getFollowingAdjuncts();

  ILexStream? getILexStream();

  IPrsStream? getIPrsStream();

  int getLine();

  int getColumn();

  int getEndLine();

  int getEndColumn();
}

abstract class ILexStream extends TokenStream {
  IPrsStream? getIPrsStream();

  void setPrsStream(final IPrsStream stream);

  int getLineCount();

  List<String>? orderedExportedSymbols();

  int getLineOffset(final int i);

  int getLineNumberOfCharAt(final int i);

  int getColumnOfCharAt(final int i);

  String getCharValue(final int i);

  int getIntValue(final int i);

  void makeToken(final int startLoc, final int endLoc, final int kind);

  void setMessageHandler(final IMessageHandler errMsg);

  IMessageHandler? getMessageHandler();

  /// See IMessaageHandler for a description of the List<int> return value.
  Location getLocation(final int left_loc, final int right_loc);

  void reportLexicalError(final int left_loc, final int right_loc,
      [final int? errorCode,
        final int? error_left_loc,
        final int? error_right_loc,
        final List<String>? errorInfo]);

  String toStringWithOffset(final int startOffset, final int endOffset);
}

abstract class IPrsStream extends TokenStream {
  IMessageHandler? getMessageHandler();

  void setMessageHandler(
    final IMessageHandler errMsg,
  );

  ILexStream getILexStream();

  void setLexStream(
    final ILexStream lexStream,
  );

  int getFirstErrorToken(
    final int i,
  );

  int getLastErrorToken(
    final int i,
  );

  void makeToken(
    final int startLoc,
    final int endLoc,
    final int kind,
  );

  void makeAdjunct(
    final int startLoc,
    final int endLoc,
    final int kind,
  );

  void removeLastToken();

  int getLineCount();

  int getSize();

  void remapTerminalSymbols(
    final List<String> ordered_parser_symbols,
    final int eof_symbol,
  );

  List<String> orderedTerminalSymbols();

  int mapKind(
    final int kind,
  );

  void resetTokenStream();

  int getStreamIndex();

  void setStreamIndex(
    final int index,
  );

  void setStreamLength(
    final int? len,
  );

  void addToken(
    final IToken token,
  );

  void addAdjunct(
    final IToken adjunct,
  );

  List<String> orderedExportedSymbols();

  ArrayList<dynamic> getTokens();

  ArrayList<dynamic> getAdjuncts();

  List<IToken> getFollowingAdjuncts(
    final int i,
  );

  List<IToken> getPrecedingAdjuncts(
    final int i,
  );

  IToken getIToken(
    final int i,
  );

  String getTokenText(
    final int i,
  );

  int getStartOffset(
    final int i,
  );

  int getEndOffset(
    final int i,
  );

  int getLineOffset(
    final int i,
  );

  int getLineNumberOfCharAt(
    final int i,
  );

  int getColumnOfCharAt(
    final int i,
  );

  int getTokenLength(
    final int i,
  );

  int getLineNumberOfTokenAt(
    final int i,
  );

  int getEndLineNumberOfTokenAt(
    final int i,
  );

  int getColumnOfTokenAt(
    final int i,
  );

  int getEndColumnOfTokenAt(
    final int i,
  );

  String getInputChars();

  List<int> getInputBytes();

  String toStringFromIndex(
    final int first_token,
    final int last_token,
  );

  String toStringFromToken(
    final IToken t1,
    final IToken t2,
  );

  int getTokenIndexAtCharacter(
    final int offset,
  );

  IToken? getTokenAtCharacter(
    final int offset,
  );

  IToken getTokenAt(
    final int i,
  );

  void dumpTokens();

  void dumpToken(
    final int i,
  );

  int makeErrorToken(
    final int first,
    final int last,
    final int error,
    final int kind,
  );
}

abstract class RuleAction {
  void ruleAction(final int ruleNumber);
}

abstract class TokenStream {
  int getToken([
    final int? end_token,
  ]);

  int getKind(
    final int i,
  );

  int getNext(
    final int i,
  );

  int getPrevious(
    final int i,
  );

  String getName(
    final int i,
  );

  int peek();

  void reset([
    final int? i,
  ]);

  int badToken();

  int getLine(
    final int i,
  );

  int getColumn(
    final int i,
  );

  int getEndLine(
    final int i,
  );

  int getEndColumn(
    final int i,
  );

  bool afterEol(
    final int i,
  );

  String getFileName();

  int getStreamLength();

  int getFirstRealToken(
    final int i,
  );

  int getLastRealToken(
    final int i,
  );

  void reportError(
    final int errorCode,
    final int leftToken,
    final int rightToken,
    final dynamic errorInfo, [
    final int errorToken = 0,
  ]);
}
// endregion

// region impl
class BacktrackingParser extends Stacks {
  Monitor? monitor;
  int START_STATE = 0;
  int NUM_RULES = 0;
  int NT_OFFSET = 0;
  int LA_STATE_OFFSET = 0;
  int EOFT_SYMBOL = 0;
  int ERROR_SYMBOL = 0;
  int ACCEPT_ACTION = 0;
  int ERROR_ACTION = 0;

  int lastToken = 0, currentAction = 0;

  late TokenStream tokStream;
  late ParseTable prs;
  late RuleAction ra;
  IntSegmentedTuple action = IntSegmentedTuple(10, 1024); // IntTuple(1 << 20),
  late IntTuple tokens;
  List<int> actionStack = [];
  bool skipTokens = false; // true if error productions are used to skip tokens

  // A starting marker indicates that we are dealing with an entry point
  // for a given nonterminal. We need to execute a shift action on the
  // marker in order to parse the entry point in question.
  int markerTokenIndex = 0;

  int getMarkerToken(final int marker_kind, final int start_token_index) {
    if (marker_kind == 0) {
      return 0;
    } else {
      if (markerTokenIndex == 0) {
        if (!(tokStream is IPrsStream)) {
          throw TokenStreamNotIPrsStreamException();
        }
        markerTokenIndex = (tokStream as IPrsStream).makeErrorToken(
            tokStream.getPrevious(start_token_index),
            tokStream.getPrevious(start_token_index),
            tokStream.getPrevious(start_token_index),
            marker_kind);
      } else {
        (tokStream as IPrsStream)
            .getIToken(markerTokenIndex)
            .setKind(marker_kind);
      }
    }
    return markerTokenIndex;
  }

  // Override the getToken function in Stacks.
  @override
  int getToken(final int i) {
    return tokens.get(locationStack[stateStackTop + (i - 1)]);
  }

  int getCurrentRule() {
    return currentAction;
  }

  int getFirstToken2() {
    return tokStream.getFirstRealToken(getToken(1));
  }

  int getFirstToken([final int? i]) {
    if (null == i) {
      return getFirstToken2();
    }
    return tokStream.getFirstRealToken(getToken(i));
  }

  int getLastToken2() {
    return tokStream.getLastRealToken(lastToken);
  }

  int getLastToken([final int? i]) {
    if (null == i) {
      return getLastToken2();
    }
    final l = i >= prs.rhs(currentAction)
        ? lastToken
        : tokens.get(locationStack[stateStackTop + i] - 1);
    return tokStream.getLastRealToken(l);
  }

  void setMonitor(final Monitor? monitor) {
    this.monitor = monitor;
  }

  void reset1() {
    action.reset();
    skipTokens = false;
    markerTokenIndex = 0;
  }

  void reset2(final TokenStream tokStream, final Monitor? monitor) {
    this.monitor = monitor;
    this.tokStream = tokStream;
    reset1();
  }

  void reset([
    final TokenStream? tokStream,
    final ParseTable? prs,
    final RuleAction? ra,
    final Monitor? monitor,
  ]) {
    if (prs != null) {
      this.prs = prs;
      START_STATE = prs.getStartState();
      NUM_RULES = prs.getNumRules();
      NT_OFFSET = prs.getNtOffset();
      LA_STATE_OFFSET = prs.getLaStateOffset();
      EOFT_SYMBOL = prs.getEoftSymbol();
      ERROR_SYMBOL = prs.getErrorSymbol();
      ACCEPT_ACTION = prs.getAcceptAction();
      ERROR_ACTION = prs.getErrorAction();
      if (!prs.isValidForParser()) throw BadParseSymFileException();
      if (!prs.getBacktrack()) throw const NotBacktrackParseTableException();
    }
    if (ra != null) {
      this.ra = ra;
    }
    if (null == tokStream) {
      reset1();
      return;
    }
    reset2(tokStream, monitor);
  }

  BacktrackingParser(
      [final TokenStream? tokStream,
        final ParseTable? prs,
        final RuleAction? ra,
        final Monitor? monitor])
      : super() {
    reset(tokStream, prs, ra, monitor);
  }

  // Allocate or reallocate all the stacks. Their sizes should always be the same.
  void reallocateOtherStacks(final int start_token_index) {
    // assert(super.stateStack != null);
    final length = super.stateStack.length;
    const fill = 0;
    if (actionStack.isEmpty) {
      actionStack = List.filled(length, fill);
      super.locationStack = List.filled(length, fill);
      super.parseStack = List.filled(length, null);
      actionStack[0] = 0;
      locationStack[0] = start_token_index;
    } else if (actionStack.length < super.stateStack.length) {
      final old_length = actionStack.length;
      ArrayList.copy(actionStack, 0, actionStack = List.filled(length, fill), 0,
          old_length);
      ArrayList.copy(super.locationStack, 0,
          super.locationStack = List.filled(length, fill), 0, old_length);
      ArrayList.copy(super.parseStack, 0,
          super.parseStack = List.filled(length, null), 0, old_length);
    }
    return;
  }

  // Recover up to max_error_count times and then quit
  Object? fuzzyParse([int? max_error_count]) {
    max_error_count ??= pow(2, 32).floor();
    return fuzzyParseEntry(0, max_error_count);
  }

  Object? fuzzyParseEntry(final int marker_kind, [int? max_error_count]) {
    max_error_count ??= pow(2, 32).floor();
    action.reset();
    tokStream.reset(); // Position at first token.
    reallocateStateStack();
    stateStackTop = 0;
    stateStack[0] = START_STATE;
    // The tuple tokens will eventually contain the sequence
    // of tokens that resulted in a successful parse. We leave
    // it up to the "Stream" implementer to define the predecessor
    // of the first token as he sees fit.
    var first_token = tokStream.peek(),
        start_token = first_token,
        marker_token = getMarkerToken(marker_kind, first_token);
    tokens = IntTuple(tokStream.getStreamLength());
    tokens.add(tokStream.getPrevious(first_token));
    final error_token = backtrackParseInternal(action, marker_token);
    if (error_token != 0) // an error was detected?
        {
      if (!(tokStream is IPrsStream)) {
        throw TokenStreamNotIPrsStreamException();
      }
      final rp = RecoveryParser(this, action, tokens, tokStream as IPrsStream,
          prs, max_error_count, 0, monitor);
      start_token = rp.recover(marker_token, error_token);
    }
    if (marker_token != 0 && start_token == first_token) {
      tokens.add(marker_token);
    }
    int t;
    for (t = start_token;
    tokStream.getKind(t) != EOFT_SYMBOL;
    t = tokStream.getNext(t)) {
      tokens.add(t);
    }
    tokens.add(t);
    return parseActions(marker_kind);
  }

  // Parse input allowing up to max_error_count Error token recoveries.
  // When max_error_count is 0, no Error token recoveries occur.
  // When max_error is > 0, it limits the number of Error token recoveries.
  // When max_error is < 0, the number of error token recoveries is unlimited.
  // Also, such recoveries only require one token to be parsed beyond the recovery point.
  // (normally two tokens beyond the recovery point must be parsed)
  // Thus, a negative max_error_count should be used when error productions are used to
  // skip tokens.
  Object? parse([final int max_error_count = 0]) {
    return parseEntry(0, max_error_count);
  }

  // Parse input allowing up to max_error_count Error token recoveries.
  // When max_error_count is 0, no Error token recoveries occur.
  // When max_error is > 0, it limits the number of Error token recoveries.
  // When max_error is < 0, the number of error token recoveries is unlimited.
  // Also, such recoveries only require one token to be parsed beyond the recovery point.
  // (normally two tokens beyond the recovery point must be parsed)
  // Thus, a negative max_error_count should be used when error productions are used to
  // skip tokens.
  Object? parseEntry([final int marker_kind = 0, int max_error_count = 0]) {
    action.reset();
    tokStream.reset(); // Position at first token.
    reallocateStateStack();
    stateStackTop = 0;
    stateStack[0] = START_STATE;
    skipTokens = max_error_count < 0;
    if (max_error_count > 0 && tokStream is IPrsStream) max_error_count = 0;
    // The tuple tokens will eventually contain the sequence
    // of tokens that resulted in a successful parse. We leave
    // it up to the "Stream" implementer to define the predecessor
    // of the first token as he sees fit.
    tokens = IntTuple(tokStream.getStreamLength());
    tokens.add(tokStream.getPrevious(tokStream.peek()));
    var start_token_index = tokStream.peek(),
        repair_token = getMarkerToken(marker_kind, start_token_index),
        start_action_index = action.size(); // obviously 0
    var temp_stack = List.filled(stateStackTop + 1, 0);
    ArrayList.copy(stateStack, 0, temp_stack, 0, temp_stack.length);
    final initial_error_token = backtrackParseInternal(action, repair_token);
    for (var error_token = initial_error_token, count = 0;
    error_token != 0;
    error_token = backtrackParseInternal(action, repair_token), count++) {
      if (count == max_error_count) {
        throw BadParseException(initial_error_token);
      }
      action.reset(start_action_index);
      tokStream.reset(start_token_index);
      stateStackTop = temp_stack.length - 1;
      ArrayList.copy(temp_stack, 0, stateStack, 0, temp_stack.length);
      reallocateOtherStacks(start_token_index);
      backtrackParseUpToError(repair_token, error_token);
      for (stateStackTop = findRecoveryStateIndex(stateStackTop);
      stateStackTop >= 0;
      stateStackTop = findRecoveryStateIndex(stateStackTop - 1)) {
        final recovery_token = tokens.get(locationStack[stateStackTop] - 1);
        repair_token = errorRepair(
            tokStream as IPrsStream,
            recovery_token >= start_token_index
                ? recovery_token
                : error_token,
            error_token);
        if (repair_token != 0) break;
      }
      if (stateStackTop < 0) throw BadParseException(initial_error_token);
      temp_stack = List.filled(stateStackTop + 1, 0);
      ArrayList.copy(stateStack, 0, temp_stack, 0, temp_stack.length);
      start_action_index = action.size();
      start_token_index = tokStream.peek();
    }
    if (repair_token != 0) tokens.add(repair_token);
    int t;
    for (t = start_token_index;
    tokStream.getKind(t) != EOFT_SYMBOL;
    t = tokStream.getNext(t)) {
      tokens.add(t);
    }
    tokens.add(t);
    return parseActions(marker_kind);
  }

  // Process reductions and continue...
  void process_reductions() {
    do {
      stateStackTop -= prs.rhs(currentAction) - 1;
      ra.ruleAction(currentAction);
      currentAction =
          prs.ntAction(stateStack[stateStackTop], prs.lhs(currentAction));
    } while (currentAction <= NUM_RULES);
    return;
  }

  // Now do the  parse of the input based on the actions in
  // the list "action" and the sequence of tokens in list "tokens".
  Object? parseActions(final int marker_kind) {
    int ti = -1, curtok;
    lastToken = tokens.get(++ti);
    curtok = tokens.get(++ti);
    allocateOtherStacks();
    // Reparse the input...
    stateStackTop = -1;
    currentAction = START_STATE;
    for (var i = 0; i < action.size(); i++) {
      // if the parser needs to stop processing, it may do so here.
      if (monitor != null && monitor!.isCancelled()) return null;
      stateStack[++stateStackTop] = currentAction;
      locationStack[stateStackTop] = ti;
      currentAction = action.get(i);
      if (currentAction <= NUM_RULES) // a reduce action?
          {
        stateStackTop--; // make reduction look like shift-reduction
        process_reductions();
      } else // a shift or shift-reduce action
          {
        if (tokStream.getKind(curtok) > NT_OFFSET) {
          final badtok =
          (tokStream as IPrsStream).getIToken(curtok) as ErrorToken;
          throw BadParseException(badtok
              .getErrorToken()
              .getTokenIndex()); // parseStack[stateStackTop] = ra.prostheticAst[prs.getProsthesisIndex(tokStream.getKind(curtok))].create(tokStream.getIToken(curtok));
        }
        lastToken = curtok;
        curtok = tokens.get(++ti);
        if (currentAction > ERROR_ACTION) // a shift-reduce action?
            {
          currentAction -= ERROR_ACTION;
          process_reductions();
        }
      }
    }
    return parseStack[marker_kind == 0 ? 0 : 1];
  }

  // Process reductions and continue...
  int process_backtrack_reductions(int act) {
    do {
      stateStackTop -= prs.rhs(act) - 1;
      act = prs.ntAction(stateStack[stateStackTop], prs.lhs(act));
    } while (act <= NUM_RULES);
    return act;
  }

  // This method is intended to be used by the type RecoveryParser.
  // Note that the action tuple passed here must be the same action
  // tuple that was passed down to RecoveryParser. It is passed back
  // to this method as documention.
  int backtrackParse(final List<int> stack, final int stack_top, final IntSegmentedTuple action,
      final int initial_token) {
    stateStackTop = stack_top;
    ArrayList.copy(stack, 0, stateStack, 0, stateStackTop + 1);
    // assert(this.action == action);
    return backtrackParseInternal(action, initial_token);
  }

  // Parse the input until either the parse completes successfully or
  // an error is encountered. This function returns an integer that
  // represents the last action that was executed by the parser. If
  // the parse was succesful, then the tuple "action" contains the
  // successful sequence of actions that was executed.
  int backtrackParseInternal(final IntSegmentedTuple action, final int initial_token) {
    // Allocate configuration stack.
    final configuration_stack = ConfigurationStack(prs);
    // Keep parsing until we successfully reach the end of file or
    // an error is encountered. The list of actions executed will
    // be stored in the "action" tuple.
    var error_token = 0,
        maxStackTop = stateStackTop,
        start_token = tokStream.peek(),
        curtok = initial_token > 0 ? initial_token : tokStream.getToken(),
        current_kind = tokStream.getKind(curtok),
        act = tAction(stateStack[stateStackTop], current_kind);
    // The main driver loop
    for (;;) {
      // if the parser needs to stop processing,
      // it may do so here.
      if (monitor != null && monitor!.isCancelled()) return 0;
      if (act <= NUM_RULES) {
        action.add(act); // save this reduce action
        stateStackTop--;
        act = process_backtrack_reductions(act);
      } else if (act > ERROR_ACTION) {
        action.add(act); // save this shift-reduce action
        curtok = tokStream.getToken();
        current_kind = tokStream.getKind(curtok);
        act = process_backtrack_reductions(act - ERROR_ACTION);
      } else if (act < ACCEPT_ACTION) {
        action.add(act); // save this shift action
        curtok = tokStream.getToken();
        current_kind = tokStream.getKind(curtok);
      } else if (act == ERROR_ACTION) {
        error_token = error_token > curtok ? error_token : curtok;
        final configuration = configuration_stack.pop();
        if (configuration == null) {
          act = ERROR_ACTION;
        } else {
          action.reset(configuration.action_length);
          act = configuration.act;
          curtok = configuration.curtok;
          current_kind = tokStream.getKind(curtok);
          tokStream.reset(curtok == initial_token
              ? start_token
              : tokStream.getNext(curtok));
          stateStackTop = configuration.stack_top;
          configuration.retrieveStack(stateStack);
          continue;
        }
        break;
      } else if (act > ACCEPT_ACTION) {
        if (configuration_stack.findConfiguration(
            stateStack, stateStackTop, curtok)) {
          act = ERROR_ACTION;
        } else {
          configuration_stack.push(
              stateStack, stateStackTop, act + 1, curtok, action.size());
          act = prs.baseAction(act);
          maxStackTop =
          stateStackTop > maxStackTop ? stateStackTop : maxStackTop;
        }
        continue;
      } else {
        break;
      } // assert(act == ACCEPT_ACTION);
      try {
        stateStack[++stateStackTop] = act;
      } on RangeError {
        reallocateStateStack();
        stateStack[stateStackTop] = act;
      }
      act = tAction(act, current_kind);
    }
    return act == ERROR_ACTION ? error_token : 0;
  }

  void backtrackParseUpToError(final int initial_token, final int error_token) {
    // Allocate configuration stack.
    final configuration_stack = ConfigurationStack(prs);
    // Keep parsing until we successfully reach the end of file or
    // an error is encountered. The list of actions executed will
    // be stored in the "action" tuple.
    var start_token = tokStream.peek(),
        curtok = initial_token > 0 ? initial_token : tokStream.getToken(),
        current_kind = tokStream.getKind(curtok),
        act = tAction(stateStack[stateStackTop], current_kind);
    tokens.add(curtok);
    locationStack[stateStackTop] = tokens.size();
    actionStack[stateStackTop] = action.size();
    for (;;) {
      // if the parser needs to stop processing,
      // it may do so here.
      if (monitor != null && monitor!.isCancelled()) return;
      if (act <= NUM_RULES) {
        action.add(act); // save this reduce action
        stateStackTop--;
        act = process_backtrack_reductions(act);
      } else if (act > ERROR_ACTION) {
        action.add(act); // save this shift-reduce action
        curtok = tokStream.getToken();
        current_kind = tokStream.getKind(curtok);
        tokens.add(curtok);
        act = process_backtrack_reductions(act - ERROR_ACTION);
      } else if (act < ACCEPT_ACTION) {
        action.add(act); // save this shift action
        curtok = tokStream.getToken();
        current_kind = tokStream.getKind(curtok);
        tokens.add(curtok);
      } else if (act == ERROR_ACTION) {
        if (curtok != error_token) {
          final configuration = configuration_stack.pop();
          if (configuration == null) {
            act = ERROR_ACTION;
          } else {
            action.reset(configuration.action_length);
            act = configuration.act;
            final next_token_index = configuration.curtok;
            tokens.reset(next_token_index);
            curtok = tokens.get(next_token_index - 1);
            current_kind = tokStream.getKind(curtok);
            tokStream.reset(curtok == initial_token
                ? start_token
                : tokStream.getNext(curtok));
            stateStackTop = configuration.stack_top;
            configuration.retrieveStack(stateStack);
            locationStack[stateStackTop] = tokens.size();
            actionStack[stateStackTop] = action.size();
            continue;
          }
        }
        break;
      } else if (act > ACCEPT_ACTION) {
        if (configuration_stack.findConfiguration(
            stateStack, stateStackTop, tokens.size())) {
          act = ERROR_ACTION;
        } else {
          configuration_stack.push(
              stateStack, stateStackTop, act + 1, tokens.size(), action.size());
          act = prs.baseAction(act);
        }
        continue;
      } else {
        break;
      } // assert(act == ACCEPT_ACTION);
      stateStack[++stateStackTop] = act; // no need to check if out of bounds
      locationStack[stateStackTop] = tokens.size();
      actionStack[stateStackTop] = action.size();
      act = tAction(act, current_kind);
    }
    // assert(curtok == error_token);
    return;
  }

  bool repairable(final int error_token) {
    // Allocate configuration stack.
    final configuration_stack = ConfigurationStack(prs);
    // Keep parsing until we successfully reach the end of file or
    // an error is encountered. The list of actions executed will
    // be stored in the "action" tuple.
    var start_token = tokStream.peek(),
        final_token = tokStream.getStreamLength(), // unreachable
        curtok = 0,
        current_kind = ERROR_SYMBOL,
        act = tAction(stateStack[stateStackTop], current_kind);
    for (;;) {
      if (act <= NUM_RULES) {
        stateStackTop--;
        act = process_backtrack_reductions(act);
      } else if (act > ERROR_ACTION) {
        curtok = tokStream.getToken();
        if (curtok > final_token) return true;
        current_kind = tokStream.getKind(curtok);
        act = process_backtrack_reductions(act - ERROR_ACTION);
      } else if (act < ACCEPT_ACTION) {
        curtok = tokStream.getToken();
        if (curtok > final_token) return true;
        current_kind = tokStream.getKind(curtok);
      } else if (act == ERROR_ACTION) {
        final configuration = configuration_stack.pop();
        if (configuration == null) {
          act = ERROR_ACTION;
        } else {
          stateStackTop = configuration.stack_top;
          configuration.retrieveStack(stateStack);
          act = configuration.act;
          curtok = configuration.curtok;
          if (curtok == 0) {
            current_kind = ERROR_SYMBOL;
            tokStream.reset(start_token);
          } else {
            current_kind = tokStream.getKind(curtok);
            tokStream.reset(tokStream.getNext(curtok));
          }
          continue;
        }
        break;
      } else if (act > ACCEPT_ACTION) {
        if (configuration_stack.findConfiguration(
            stateStack, stateStackTop, curtok)) {
          act = ERROR_ACTION;
        } else {
          configuration_stack.push(
              stateStack, stateStackTop, act + 1, curtok, 0);
          act = prs.baseAction(act);
        }
        continue;
      } else {
        break;
      } // assert(act == ACCEPT_ACTION);
      try {
        // We consider a configuration to be acceptable for recovery
        // if we are able to consume enough symbols in the remainining
        // tokens to reach another potential recovery point past the
        // original error token.
        if ((curtok > error_token) &&
            (final_token == tokStream.getStreamLength())) {
          // If the ERROR_SYMBOL is a valid Action Adjunct in the state
          // "act" then we set the terminating token as the successor of
          // the current token. I.e., we have to be able to parse at least
          // two tokens past the resynch point before we claim victory.
          if (recoverableState(act)) {
            final_token = skipTokens ? curtok : tokStream.getNext(curtok);
          }
        }
        stateStack[++stateStackTop] = act;
      } on RangeError {
        reallocateStateStack();
        stateStack[stateStackTop] = act;
      }
      act = tAction(act, current_kind);
    }
    // If we can reach the end of the input successfully, we claim victory.
    return act == ACCEPT_ACTION;
  }

  bool recoverableState(final int state) {
    for (var k = prs.asi(state); prs.asr(k) != 0; k++) {
      if (prs.asr(k) == ERROR_SYMBOL) return true;
    }
    return false;
  }

  int findRecoveryStateIndex(final int start_index) {
    int i;
    for (i = start_index; i >= 0; i--) {
      // If the ERROR_SYMBOL is an Action Adjunct in state stateStack[i]
      // then chose i as the index of the state to recover on.
      if (recoverableState(stateStack[i])) break;
    }
    if (i >= 0) // if a recoverable state, remove null reductions, if any.
        {
      int k;
      for (k = i - 1; k >= 0; k--) {
        if (locationStack[k] != locationStack[i]) break;
      }
      i = k + 1;
    }
    return i;
  }

  int errorRepair(final IPrsStream stream, int recovery_token, final int error_token) {
    final temp_stack = List.filled(stateStackTop + 1, 0);
    ArrayList.copy(stateStack, 0, temp_stack, 0, temp_stack.length);
    for (;
    stream.getKind(recovery_token) != EOFT_SYMBOL;
    recovery_token = stream.getNext(recovery_token)) {
      stream.reset(recovery_token);
      if (repairable(error_token)) break;
      stateStackTop = temp_stack.length - 1;
      ArrayList.copy(temp_stack, 0, stateStack, 0, temp_stack.length);
    }
    if (stream.getKind(recovery_token) == EOFT_SYMBOL) {
      stream.reset(recovery_token);
      if (!repairable(error_token)) {
        stateStackTop = temp_stack.length - 1;
        ArrayList.copy(temp_stack, 0, stateStack, 0, temp_stack.length);
        return 0;
      }
    }
    stateStackTop = temp_stack.length - 1;
    ArrayList.copy(temp_stack, 0, stateStack, 0, temp_stack.length);
    stream.reset(recovery_token);
    tokens.reset(locationStack[stateStackTop] - 1);
    action.reset(actionStack[stateStackTop]);
    return stream.makeErrorToken(tokens.get(locationStack[stateStackTop] - 1),
        stream.getPrevious(recovery_token), error_token, ERROR_SYMBOL);
  }

  // keep looking ahead until we compute a valid action
  int lookahead(int act, final int token) {
    act = prs.lookAhead(act - LA_STATE_OFFSET, tokStream.getKind(token));
    return act > LA_STATE_OFFSET
        ? lookahead(act, tokStream.getNext(token))
        : act;
  }

  // Compute the next action defined on act and sym. If this
  // action requires more lookahead, these lookahead symbols
  // are in the token stream beginning at the next token that
  // is yielded by peek().
  int tAction(int act, final int sym) {
    act = prs.tAction(act, sym);
    return act > LA_STATE_OFFSET ? lookahead(act, tokStream.peek()) : act;
  }
}

class RecoveryParser extends DiagnoseParser {
  late BacktrackingParser parser;
  late IntSegmentedTuple action;
  late IntTuple tokens;
  List<int> actionStack = [];
  PrimaryRepairInfo scope_repair = PrimaryRepairInfo();

  // maxErrors is the maximum number of errors to be repaired
  // maxTime is the maximum amount of time allowed for diagnosing
  // but at least one error must be diagnosed
  RecoveryParser(
      final this.parser,
      final this.action,
      final this.tokens,
      final IPrsStream tokStream,
      final ParseTable prs, [
        final int maxErrors = 0,
        final int maxTime = 0,
        final Monitor? monitor,
      ]) : super(tokStream, prs, maxErrors, maxTime, monitor);

  @override
  void reallocateStacks() {
    super.reallocateStacks();
    if (actionStack.isEmpty) {
      actionStack = List.filled(stateStack.length, 0);
    } else {
      final old_stack_length = actionStack.length;
      ArrayList.copy(actionStack, 0,
          actionStack = List.filled(stateStack.length, 0), 0, old_stack_length);
    }
    return;
  }

  void reportError(final int scope_index, final int error_token) {
    var text = '\"';
    for (var i = scopeSuffix(scope_index); scopeRhs(i) != 0; i++) {
      if (!isNullable(scopeRhs(i))) {
        final symbol_index = scopeRhs(i) > NT_OFFSET
            ? nonterminalIndex(scopeRhs(i) - NT_OFFSET)
            : terminalIndex(scopeRhs(i));
        if (name(symbol_index).isNotEmpty) {
          if (text.length > 1) {
            text += ' ';
          } // add a space separator
          text += name(symbol_index);
        }
      }
    }
    text += '\"';
    tokStream.reportError(SCOPE_CODE, error_token, error_token, [text]);
    return;
  }

  int recover(final int marker_token, int error_token) {
    if (stateStack.isEmpty) reallocateStacks();
    tokens.reset();
    tokStream.reset();
    tokens.add(tokStream.getPrevious(tokStream.peek()));
    var restart_token =
    marker_token != 0 ? marker_token : tokStream.getToken(),
        old_action_size = 0;
    stateStackTop = 0;
    stateStack[stateStackTop] = START_STATE;
    do {
      action.reset(old_action_size);
      if (!fixError(restart_token, error_token)) {
        throw BadParseException(error_token);
      }
      // if the parser needs to stop processing,
      // it may do so here.
      if (monitor != null && monitor!.isCancelled()) break;
      // At this stage, we have a recovery configuration. See how
      // far we can go with it.
      restart_token = error_token;
      tokStream.reset(error_token);
      old_action_size =
          action.size(); // save the old size in case we encounter a new error
      error_token = parser.backtrackParse(stateStack, stateStackTop, action, 0);
      tokStream.reset(tokStream.getNext(restart_token));
    } while (error_token != 0); // no error found
    return restart_token;
  }

//void TemporaryErrorDump()
//{
//int prevStackTop = stateStackTop;
//ArrayList.copy(stateStack, 0, prevStack, 0, stateStackTop + 1); // save StateStack
//RepairCandidate candidate = primaryDiagnosis(scope_repair);
//stateStackTop = prevStackTop;
//ArrayList.copy(prevStack, 0, stateStack, 0, stateStackTop + 1); // restore StateStack
//}

  // Given the configuration consisting of the states in stateStack
  // and the sequence of tokens (current_kind, followed by the tokens
  // in tokStream), fixError parses up to error_token in the tokStream
  // recovers, if possible, from that error and returns the result.
  // While doing this, it also computes the location_stack information
  // and the sequence of actions that matches up with the result that
  // it returns.
  bool fixError(final int start_token, final int error_token) {
//System.err.println("fixError entered on error token " + error_token + " ==> " + tokStream.getName(error_token) +
//                   " in state " + originalState(stateStack[stateStackTop]) +
//                   " to restart on token " + tokStream.peek() + " ==> " + tokStream.getName(tokStream.peek()));
    // Save information about the current configuration.
    var curtok = start_token,
        current_kind = tokStream.getKind(curtok),
        first_stream_token = tokStream.peek();
    buffer[1] = error_token;
    buffer[0] = tokStream.getPrevious(buffer[1]);
    for (var k = 2; k < BUFF_SIZE; k++) {
      buffer[k] = tokStream.getNext(buffer[k - 1]);
    }
    scope_repair.distance = 0;
    scope_repair.misspellIndex = 0;
    scope_repair.bufferPosition = 1;
    // Clear the configuration stack.
    main_configuration_stack = ConfigurationStack(prs);
    // Keep parsing until we reach the end of file and succeed or
    // an error is encountered. The list of actions executed will
    // be stored in the "action" tuple.
    locationStack[stateStackTop] = curtok;
    actionStack[stateStackTop] = action.size();
    var act = tAction(stateStack[stateStackTop], current_kind);
    for (;;) {
      // if the parser needs to stop processing,
      // it may do so here.
      if (monitor != null && monitor!.isCancelled()) return true;
      if (act <= NUM_RULES) {
        action.add(act); // save this reduce action
        stateStackTop--;
        do {
          stateStackTop -= rhs(act) - 1;
          act = ntAction(stateStack[stateStackTop], lhs(act));
        } while (act <= NUM_RULES);
        try {
          stateStack[++stateStackTop] = act;
        } on RangeError {
          reallocateStacks();
          stateStack[stateStackTop] = act;
        }
        locationStack[stateStackTop] = curtok;
        actionStack[stateStackTop] = action.size();
        act = tAction(act, current_kind);
        continue;
      } else if (act == ERROR_ACTION) {
        if (curtok != error_token || main_configuration_stack.size() > 0) {
          final configuration = main_configuration_stack.pop();
          if (configuration == null) {
            act = ERROR_ACTION;
          } else {
            stateStackTop = configuration.stack_top;
            configuration.retrieveStack(stateStack);
            act = configuration.act;
            curtok = configuration.curtok;
            action.reset(configuration.action_length);
            current_kind = tokStream.getKind(curtok);
            tokStream.reset(tokStream.getNext(curtok));
            continue;
          }
        }
        break;
      } else if (act > ACCEPT_ACTION && act < ERROR_ACTION) {
        if (main_configuration_stack.findConfiguration(
            stateStack, stateStackTop, curtok)) {
          act = ERROR_ACTION;
        } else {
          main_configuration_stack.push(
              stateStack, stateStackTop, act + 1, curtok, action.size());
          act = baseAction(act);
        }
        continue;
      } else {
        if (act < ACCEPT_ACTION) {
          action.add(act); // save this shift action
          curtok = tokStream.getToken();
          current_kind = tokStream.getKind(curtok);
        } else if (act > ERROR_ACTION) {
          action.add(act); // save this shift-reduce action
          curtok = tokStream.getToken();
          current_kind = tokStream.getKind(curtok);
          act -= ERROR_ACTION;
          do {
            stateStackTop -= rhs(act) - 1;
            act = ntAction(stateStack[stateStackTop], lhs(act));
          } while (act <= NUM_RULES);
        } else {
          break;
        } // assert(act == ACCEPT_ACTION);  THIS IS NOT SUPPOSED TO HAPPEN!!!
        try {
          stateStack[++stateStackTop] = act;
        } on RangeError {
          reallocateStacks();
          stateStack[stateStackTop] = act;
        }
        if (curtok == error_token) {
          scopeTrial(scope_repair, stateStack, stateStackTop);
          if (scope_repair.distance >= MIN_DISTANCE) {
//TemporaryErrorDump();
            tokens.add(start_token);
            for (var token = first_stream_token;
            token != error_token;
            token = tokStream.getNext(token)) {
              tokens.add(token);
            }
            acceptRecovery(error_token);
            break; // equivalent to: return true;
          }
        }
        locationStack[stateStackTop] = curtok;
        actionStack[stateStackTop] = action.size();
        act = tAction(act, current_kind);
      }
    }

//if (act != ERROR_ACTION)
//System.err.println("fixError exiting in state " + originalState(stateStack[stateStackTop]) +
//                   " on symbol " + curtok + " ==> " + tokStream.getName(curtok));
    return act != ERROR_ACTION;
  }

  void acceptRecovery(final int error_token) {
    // int action_size = action.size();
    // Simulate parsing actions required for this sequence of scope
    // recoveries.
    // TODO: need to add action and fix the location_stack?
    final recovery_action = IntTuple();
    for (var k = 0; k <= scopeStackTop; k++) {
      final scope_index = scopeIndex[k], la = scopeLa(scope_index);
      // Compute the action (or set of actions in case of conflicts) that
      // can be executed on the scope lookahead symbol. Save the action(s)
      // in the action tuple.
      recovery_action.reset();
      var act = tAction(stateStack[stateStackTop], la);
      if (act > ACCEPT_ACTION && act < ERROR_ACTION) // conflicting actions?
          {
        do {
          recovery_action.add(baseAction(act++));
        } while (baseAction(act) != 0);
      } else {
        recovery_action.add(act);
      }
      // For each action defined on the scope lookahead symbol,
      // try scope recovery. At least one action should succeed!
      final start_action_size = action.size();
      int index;
      for (index = 0; index < recovery_action.size(); index++) {
        // Reset the action tuple each time through this loop
        // to clear previous actions that may have been added
        // because of a failed call to completeScope.
        action.reset(start_action_size);
        tokStream.reset(error_token);
        tempStackTop = stateStackTop - 1;
        var max_pos = stateStackTop;
        act = recovery_action.get(index);
        while (act <= NUM_RULES) {
          action.add(act); // save this reduce action
          // ... Process all goto-reduce actions following
          // reduction, until a goto action is computed ...
          do {
            final lhs_symbol = lhs(act);
            tempStackTop -= rhs(act) - 1;
            act = tempStackTop > max_pos
                ? tempStack[tempStackTop]
                : stateStack[tempStackTop];
            act = ntAction(act, lhs_symbol);
          } while (act <= NUM_RULES);
          if (tempStackTop + 1 >= stateStack.length) reallocateStacks();
          max_pos = max_pos < tempStackTop ? max_pos : tempStackTop;
          tempStack[tempStackTop + 1] = act;
          act = tAction(act, la);
        }
        // If the lookahead symbol is parsable, then we check
        // whether or not we have a match between the scope
        // prefix and the transition symbols corresponding to
        // the states on top of the stack.
        if (act != ERROR_ACTION) {
          nextStackTop = ++tempStackTop;
          for (var i = 0; i <= max_pos; i++) {
            nextStack[i] = stateStack[i];
          }
          // NOTE that we do not need to update location_stack and
          // actionStack here because, once the rules associated with
          // these scopes are reduced, all these states will be popped
          // from the stack.
          for (var i = max_pos + 1; i <= tempStackTop; i++) {
            nextStack[i] = tempStack[i];
          }
          if (completeScope(action, scopeSuffix(scope_index))) {
            for (var i = scopeSuffix(scopeIndex[k]); scopeRhs(i) != 0; i++) {
              // System.err.println("(*) adding token for
              // nonterminal at location " + tokens.size());
              tokens.add((tokStream as IPrsStream).makeErrorToken(
                  error_token,
                  tokStream.getPrevious(error_token),
                  error_token,
                  scopeRhs(i)));
            }
            reportError(scopeIndex[k], tokStream.getPrevious(error_token));
            break;
          }
        }
      }
      // assert (index < recovery_action.size()); // sanity check!
      stateStackTop = nextStackTop;
      ArrayList.copy(nextStack, 0, stateStack, 0, stateStackTop + 1);
    }
    return;
  }

  bool completeScope(final IntSegmentedTuple action, final int scope_rhs_index) {
    final kind = scopeRhs(scope_rhs_index);
    if (kind == 0) return true;
    var act = nextStack[nextStackTop];
    if (kind > NT_OFFSET) {
      final lhs_symbol = kind - NT_OFFSET;
      if (baseCheck(act + lhs_symbol) != lhs_symbol) // is there a valid
        // action defined on
        // lhs_symbol?
          {
        return false;
      }
      act = ntAction(act, lhs_symbol);
      // if action is a goto-reduce action, save it as a shift-reduce
      // action.
      action.add(act <= NUM_RULES ? act + ERROR_ACTION : act);
      while (act <= NUM_RULES) {
        nextStackTop -= rhs(act) - 1;
        act = ntAction(nextStack[nextStackTop], lhs(act));
      }
      nextStackTop++;
      nextStack[nextStackTop] = act;
      //System.err.println("Shifting nonterminal " +
      //name(nonterminalIndex(lhs_symbol)));
      return completeScope(action, scope_rhs_index + 1);
    }
    // Processing a terminal
    act = tAction(act, kind);
    action.add(act); // save this terminal action
    // assert(act > NUM_RULES);
    if (act < ACCEPT_ACTION) {
      nextStackTop++;
      nextStack[nextStackTop] = act;
//System.err.println("Shifting terminal " + name(terminalIndex(kind)));
      return completeScope(action, scope_rhs_index + 1);
    } else if (act > ERROR_ACTION) {
      act -= ERROR_ACTION;
      do {
        nextStackTop -= rhs(act) - 1;
        act = ntAction(nextStack[nextStackTop], lhs(act));
      } while (act <= NUM_RULES);
      nextStackTop++;
      nextStack[nextStackTop] = act;
//System.err.println("Shift-reducing terminal " + name(terminalIndex(kind)));
//assert(scopeRhs(scope_rhs_index + 1) == 0);
      return true;
    } else if (act > ACCEPT_ACTION &&
        act < ERROR_ACTION) // conflicting actions?
        {
      final save_action_size = action.size();
      for (var i = act;
      baseAction(i) != 0;
      i++) // consider only shift and shift-reduce actions
          {
        action.reset(save_action_size);
        act = baseAction(i);
        action.add(act); // save this terminal action
        if (act <= NUM_RULES) {
          // Ignore reduce actions
        } else if (act < ACCEPT_ACTION) {
          nextStackTop++;
          nextStack[nextStackTop] = act;
//System.err.println("(2)Shifting terminal " + name(terminalIndex(kind)));
          if (completeScope(action, scope_rhs_index + 1)) return true;
        } else if (act > ERROR_ACTION) {
          act -= ERROR_ACTION;
          do {
            nextStackTop -= rhs(act) - 1;
            act = ntAction(nextStack[nextStackTop], lhs(act));
          } while (act <= NUM_RULES);
          nextStackTop++;
          nextStack[nextStackTop] = act;
//System.err.println("(2)Shift-reducing terminal " + name(terminalIndex(kind)));
//assert(scopeRhs(scope_rhs_index + 1) == 0);
          return true;
        }
      }
    }
    return false;
  }
}

class DeterministicParser extends Stacks {
  bool taking_actions = false;
  int markerKind = 0;

  Monitor? monitor;
  int START_STATE = 0,
      NUM_RULES = 0,
      NT_OFFSET = 0,
      LA_STATE_OFFSET = 0,
      EOFT_SYMBOL = 0,
      ACCEPT_ACTION = 0,
      ERROR_ACTION = 0,
      ERROR_SYMBOL = 0;

  int lastToken = 0, currentAction = 0;
  IntTuple? action;

  late TokenStream tokStream;
  late ParseTable prs;
  late RuleAction ra;

  // keep looking ahead until we compute a valid action
  int lookahead(int act, final int token) {
    act = prs.lookAhead(act - LA_STATE_OFFSET, tokStream.getKind(token));
    return act > LA_STATE_OFFSET
        ? lookahead(act, tokStream.getNext(token))
        : act;
  }

  // Compute the next action defined on act and sym. If this
  // action requires more lookahead, these lookahead symbols
  // are in the token stream beginning at the next token that
  // is yielded by peek().
  int tAction1(int act, final int sym) {
    act = prs.tAction(act, sym);
    return act > LA_STATE_OFFSET ? lookahead(act, tokStream.peek()) : act;
  }

  // Compute the next action defined on act and the next k tokens
  // whose types are stored in the array sym starting at location
  // index. The array sym is a circular buffer. If we reach the last
  // element of sym and we need more lookahead, we proceed to the
  // first element.
  // assert(sym.length == prs.getMaxLa());
  int tAction(int act, final List<int> sym, int index) {
    act = prs.tAction(act, sym[index]);
    while (act > LA_STATE_OFFSET) {
      index = (index + 1) % sym.length;
      act = prs.lookAhead(act - LA_STATE_OFFSET, sym[index]);
    }
    return act;
  }

  // Process reductions and continue...
  void processReductions() {
    do {
      stateStackTop -= prs.rhs(currentAction) - 1;
      ra.ruleAction(currentAction);
      currentAction =
          prs.ntAction(stateStack[stateStackTop], prs.lhs(currentAction));
    } while (currentAction <= NUM_RULES);
    return;
  }

  // The following functions can be invoked only when the parser is
  // processing actions. Thus, they can be invoked when the parser
  // was entered via the main entry point (parse()). When using
  // the incremental parser (via the entry point parse(int [], int)),
  // an Exception is thrown if any of these functions is invoked?
  // However, note that when parseActions() is invoked after successfully
  // parsing an input with the incremental parser, then they can be invoked.
  int getCurrentRule() {
    if (taking_actions) return currentAction;
    throw const UnavailableParserInformationException();
  }

  int getFirstToken1() {
    if (taking_actions) return getToken(1);
    throw const UnavailableParserInformationException();
  }

  int getFirstToken([final int? i]) {
    if (null == i) {
      return getFirstToken1();
    }
    if (taking_actions) {
      return getToken(i);
    }
    throw const UnavailableParserInformationException();
  }

  int getLastToken1() {
    if (taking_actions) return lastToken;
    throw const UnavailableParserInformationException();
  }

  int getLastToken([final int? i]) {
    if (null == i) {
      return getLastToken1();
    } else if (taking_actions) {
      return i >= prs.rhs(currentAction)
          ? lastToken
          : tokStream.getPrevious(getToken(i + 1));
    } else {
      throw const UnavailableParserInformationException();
    }
  }

  void setMonitor(final Monitor? monitor) {
    this.monitor = monitor;
  }

  void reset1() {
    taking_actions = false;
    markerKind = 0;
    if (action != null) {
      action!.reset();
    }
  }

  void reset2(final TokenStream tokStream, final Monitor? monitor) {
    this.monitor = monitor;
    this.tokStream = tokStream;
    reset1();
  }

  void reset(
      [final TokenStream? tokStream,
        final ParseTable? prs,
        final RuleAction? ra,
        final Monitor? monitor]) {
    if (prs != null) {
      this.prs = prs;
      START_STATE = prs.getStartState();
      NUM_RULES = prs.getNumRules();
      NT_OFFSET = prs.getNtOffset();
      LA_STATE_OFFSET = prs.getLaStateOffset();
      EOFT_SYMBOL = prs.getEoftSymbol();
      ERROR_SYMBOL = prs.getErrorSymbol();
      ACCEPT_ACTION = prs.getAcceptAction();
      ERROR_ACTION = prs.getErrorAction();
      if (!prs.isValidForParser()) throw BadParseSymFileException();
      if (prs.getBacktrack()) throw const NotDeterministicParseTableException();
    }
    if (ra != null) {
      this.ra = ra;
    }
    if (null == tokStream) {
      reset1();
      return;
    }
    reset2(tokStream, monitor);
  }

  DeterministicParser(
      [final TokenStream? tokStream,
        final ParseTable? prs,
        final RuleAction? ra,
        final Monitor? monitor])
      : super() {
    reset(tokStream, prs, ra, monitor);
  }

  Object? parseEntry([final int marker_kind = 0]) {
    // Indicate that we are running the regular parser and that it's
    // ok to use the utility functions to query the parser.
    taking_actions = true;
    // Reset the token stream and get the first token.
    tokStream.reset();
    lastToken = tokStream.getPrevious(tokStream.peek());
    int curtok, current_kind;
    if (marker_kind == 0) {
      curtok = tokStream.getToken();
      current_kind = tokStream.getKind(curtok);
    } else {
      curtok = lastToken;
      current_kind = marker_kind;
    }
    // Start parsing.
    reallocateStacks(); // make initial allocation
    stateStackTop = -1;
    currentAction = START_STATE;
    ProcessTerminals:
    for (;;) {
      // if the parser needs to stop processing,
      // it may do so here.
      if (monitor != null && monitor!.isCancelled()) {
        taking_actions = false; // indicate that we are done
        return null;
      }
      try {
        stateStack[++stateStackTop] = currentAction;
      } on RangeError {
        reallocateStacks();
        stateStack[stateStackTop] = currentAction;
      }
      locationStack[stateStackTop] = curtok;
      currentAction = tAction1(currentAction, current_kind);
      if (currentAction <= NUM_RULES) {
        stateStackTop--; // make reduction look like a shift-reduce
        processReductions();
      } else if (currentAction > ERROR_ACTION) {
        lastToken = curtok;
        curtok = tokStream.getToken();
        current_kind = tokStream.getKind(curtok);
        currentAction -= ERROR_ACTION;
        processReductions();
      } else if (currentAction < ACCEPT_ACTION) {
        lastToken = curtok;
        curtok = tokStream.getToken();
        current_kind = tokStream.getKind(curtok);
      } else {
        break ProcessTerminals;
      }
    }
    taking_actions = false; // indicate that we are done
    if (currentAction == ERROR_ACTION) {
      throw BadParseException(curtok);
    }
    return parseStack[marker_kind == 0 ? 0 : 1];
  }

  // This method is invoked when using the parser in an incremental mode
  // using the entry point parse(int [], int).
  void resetParser() {
    resetParserEntry(0);
  }

  // This method is invoked when using the parser in an incremental mode
  // using the entry point parse(int [], int).
  void resetParserEntry(final int marker_kind) {
    markerKind = marker_kind;
    if (stateStack.isEmpty) {
      reallocateStacks();
    } // make initial allocation
    stateStackTop = 0;
    stateStack[stateStackTop] = START_STATE;
    if (action == null) {
      action = IntTuple(1 << 20);
    } else {
      action!.reset();
    }
    // Indicate that we are going to run the incremental parser and that
    // it's forbidden to use the utility functions to query the parser.
    taking_actions = false;
    if (marker_kind != 0) {
      final sym = [markerKind];
      parse(sym, 0);
    }
  }

  // Find a state in the state stack that has a valid action on ERROR token
  bool recoverableState(final int state) {
    for (var k = prs.asi(state); prs.asr(k) != 0; k++) {
      if (prs.asr(k) == ERROR_SYMBOL) return true;
    }
    return false;
  }

  // Reset the parser at a point where it can legally process
  // the error token. If we can't do that, reset it to the beginning.
  void errorReset() {
    final gate = markerKind == 0 ? 0 : 1;
    for (; stateStackTop >= gate; stateStackTop--) {
      if (recoverableState(stateStack[stateStackTop])) break;
    }
    if (stateStackTop < gate) resetParserEntry(markerKind);
    return;
  }

  // This is an incremental LALR(k) parser that takes as argument
  // the next k tokens in the input. If these k tokens are valid for
  // the current configuration, it advances past the first of the k
  // tokens and returns either:
  //    . the last transition induced by that token
  //    . the Accept action
  // If the tokens are not valid, the initial configuration remains
  // unchanged and the Error action is returned.
  // Note that it is the user's responsibility to start the parser in a
  // proper configuration by initially invoking the method resetParser
  // prior to invoking this function.
  int parse(final List<int> sym, final int index) {
    // assert(sym.length == prs.getMaxLa());
    // First, we save the current length of the action tuple, in
    // case an error is encountered and we need to restore the
    // original configuration.
    // Next, we declara and initialize the variable pos which will
    // be used to indicate the highest useful position in stateStack
    // as we are simulating the actions induced by the next k input
    // terminals in sym.
    // The location stack will be used here as a temporary stack
    // to simulate these actions. We initialize its first useful
    // offset here.
    var save_action_length = action!.size(),
        pos = stateStackTop,
        location_top = stateStackTop - 1;
    // When a reduce action is encountered, we compute all REDUCE
    // and associated goto actions induced by the current token.
    // Eventually, a SHIFT, SHIFT-REDUCE, ACCEPT or ERROR action is
    // computed...
    for (currentAction = tAction(stateStack[stateStackTop], sym, index);
    currentAction <= NUM_RULES;
    currentAction = tAction(currentAction, sym, index)) {
      action!.add(currentAction);
      do {
        location_top -= prs.rhs(currentAction) - 1;
        final state = location_top > pos
            ? locationStack[location_top]
            : stateStack[location_top];
        currentAction = prs.ntAction(state, prs.lhs(currentAction));
      } while (currentAction <= NUM_RULES);
      // ... Update the maximum useful position of the
      // stateSTACK, push goto state into stack, and
      // continue by compute next action on current symbol
      // and reentering the loop...
      pos = pos < location_top ? pos : location_top;
      try {
        locationStack[location_top + 1] = currentAction;
      } on RangeError {
        reallocateStacks();
        locationStack[location_top + 1] = currentAction;
      }
    }
    // At this point, we have a shift, shift-reduce, accept or error
    // action. stateSTACK contains the configuration of the state stack
    // prior to executing any action on the currenttoken. locationStack
    // contains the configuration of the state stack after executing all
    // reduce actions induced by the current token. The variable pos
    // indicates the highest position in the stateSTACK that is still
    // useful after the reductions are executed.
    if (currentAction > ERROR_ACTION || // SHIFT-REDUCE action ?
        currentAction < ACCEPT_ACTION) // SHIFT action ?
        {
      action!.add(currentAction);
      // If no error was detected, update the state stack with
      // the info that was temporarily computed in the locationStack.
      stateStackTop = location_top + 1;
      for (var i = pos + 1; i <= stateStackTop; i++) {
        stateStack[i] = locationStack[i];
      }
      // If we have a shift-reduce, process it as well as
      // the goto-reduce actions that follow it.
      if (currentAction > ERROR_ACTION) {
        currentAction -= ERROR_ACTION;
        do {
          stateStackTop -= prs.rhs(currentAction) - 1;
          currentAction =
              prs.ntAction(stateStack[stateStackTop], prs.lhs(currentAction));
        } while (currentAction <= NUM_RULES);
      }
      // Process the  transition - either a shift action of
      // if we started out with a shift-reduce, the  GOTO
      // action that follows it.
      try {
        stateStack[++stateStackTop] = currentAction;
      } on RangeError {
        reallocateStacks();
        stateStack[stateStackTop] = currentAction;
      }
    } else if (currentAction == ERROR_ACTION) {
      action!.reset(save_action_length);
    } // restore original action state.
    return currentAction;
  }

  // Now do the  parse of the input based on the actions in
  // the list "action" and the sequence of tokens in the token stream.
  Object? parseActions() {
    // Indicate that we are processing actions now (for the incremental
    // parser) and that it's ok to use the utility functions to query the
    // parser.
    taking_actions = true;
    tokStream.reset();
    lastToken = tokStream.getPrevious(tokStream.peek());
    var curtok = markerKind == 0 ? tokStream.getToken() : lastToken;
    try {
      // Reparse the input...
      stateStackTop = -1;
      currentAction = START_STATE;
      for (var i = 0; i < action!.size(); i++) {
        // if the parser needs to stop processing, it may do so here.
        if (monitor != null && monitor!.isCancelled()) {
          taking_actions = false; // indicate that we are done
          return null;
        }
        stateStack[++stateStackTop] = currentAction;
        locationStack[stateStackTop] = curtok;
        currentAction = action!.get(i);
        if (currentAction <= NUM_RULES) // a reduce action?
            {
          stateStackTop--; // turn reduction intoshift-reduction
          processReductions();
        } else // a shift or shift-reduce action
            {
          lastToken = curtok;
          curtok = tokStream.getToken();
          if (currentAction > ERROR_ACTION) // a shift-reduce action?
              {
            currentAction -= ERROR_ACTION;
            processReductions();
          }
        }
      }
    } on Object {
      // if any exception is thrown, indicate BadParse
      taking_actions = false; // indicate that we are done.
      throw BadParseException(curtok);
    }
    taking_actions = false; // indicate that we are done.
    action = null; // turn into garbage
    return parseStack[markerKind == 0 ? 0 : 1];
  }
}

class LexParser {
  bool taking_actions = false;

  int START_STATE = 0,
      LA_STATE_OFFSET = 0,
      EOFT_SYMBOL = 0,
      ACCEPT_ACTION = 0,
      ERROR_ACTION = 0,
      START_SYMBOL = 0,
      NUM_RULES = 0;

  late ILexStream tokStream;
  late ParseTable prs;
  late RuleAction ra;
  IntTuple? action;

/*
     void reset(ILexStream tokStream)
    {
        this.tokStream = tokStream;
    }
*/
  void reset(final ILexStream tokStream, final ParseTable prs, final RuleAction ra) {
    this.tokStream = tokStream;
    this.prs = prs;
    this.ra = ra;
    START_STATE = prs.getStartState();
    LA_STATE_OFFSET = prs.getLaStateOffset();
    EOFT_SYMBOL = prs.getEoftSymbol();
    ACCEPT_ACTION = prs.getAcceptAction();
    ERROR_ACTION = prs.getErrorAction();
    START_SYMBOL = prs.getStartSymbol();
    NUM_RULES = prs.getNumRules();
  }

  LexParser([final ILexStream? tokStream, final ParseTable? prs, final RuleAction? ra]) {
    if (null != tokStream && null != prs && null != ra) {
      reset(tokStream, prs, ra);
    }
  }

  // Stacks portion
  int STACK_INCREMENT = 1024, stateStackTop = 0, stackLength = 0;
  List<int> stack = [], locationStack = [], tempStack = [];

  void reallocateStacks() {
    final old_stack_length = stack.isEmpty ? 0 : stackLength;
    stackLength += STACK_INCREMENT;
    const fill = 0;
    if (old_stack_length == 0) {
      stack = List.filled(stackLength, fill);
      locationStack = List.filled(stackLength, fill);
      tempStack = List.filled(stackLength, fill);
    } else {
      ArrayList.copy(stack, 0, stack = List.filled(stackLength, fill), 0,
          old_stack_length);
      ArrayList.copy(locationStack, 0,
          locationStack = List.filled(stackLength, fill), 0, old_stack_length);
      ArrayList.copy(tempStack, 0, tempStack = List.filled(stackLength, fill),
          0, old_stack_length);
    }
    return;
  }

  int lastToken = 0,
      currentAction = 0,
      curtok = 0,
      starttok = 0,
      current_kind = 0;

  // The following functions can be invoked only when the parser is
  // processing actions. Thus, they can be invoked when the parser
  // was entered via the main entry point (parseCharacters()). When using
  // the incremental parser (via the entry point scanNextToken(int [], int)),
  // they always return 0 when invoked. // TODO: Should we throw an Exception instead?
  // However, note that when parseActions() is invoked after successfully
  // parsing an input with the incremental parser, then they can be invoked.
  int getFirstToken([final int? i]) {
    if (null != i) {
      return getToken(i);
    } else {
      return starttok;
    }
  }

  int getLastToken([final int? i]) {
    if (null == i) {
      return lastToken;
    }
    if (taking_actions) {
      return i >= prs.rhs(currentAction)
          ? lastToken
          : tokStream.getPrevious(getToken(i + 1));
    }
    throw const UnavailableParserInformationException();
  }

  int getCurrentRule() {
    if (taking_actions) return currentAction;
    throw const UnavailableParserInformationException();
  }

  // Given a rule of the form     A ::= x1 x2 ... xn     n > 0
  // the function getToken(i) yields the symbol xi, if xi is a terminal
  // or ti, if xi is a nonterminal that produced a string of the form
  // xi => ti w. If xi is a nullable nonterminal, then ti is the first
  //  symbol that immediately follows xi in the input (the lookahead).
  int getToken(final int i) {
    if (taking_actions) return locationStack[stateStackTop + (i - 1)];
    throw const UnavailableParserInformationException();
  }

  void setSym1(final int i) {}

  int getSym(final int i) {
    return getLastToken(i);
  }

  void resetTokenStream(final int i) {
    // if i exceeds the upper bound, reset it to point to the last element.
    tokStream.reset(
        i > tokStream.getStreamLength() ? tokStream.getStreamLength() : i);
    curtok = tokStream.getToken();
    current_kind = tokStream.getKind(curtok);
    if (stack.isEmpty) {
      reallocateStacks();
    }
    action ??= IntTuple(1 << 10);
  }

  // Parse the input and create a stream of tokens.

  void parseCharacters(final int start_offset, final int end_offset, [final Monitor? monitor]) {
    resetTokenStream(start_offset);
    while (curtok <= end_offset) {
      // if the parser needs to stop processing,
      // it may do so here.
      if (monitor != null && monitor.isCancelled()) {
        return;
      }
      lexNextToken(end_offset);
    }
  }

  // Parse the input and create a stream of tokens.

  void parseCharactersWhitMonitor([final Monitor? monitor]) {
    // Indicate that we are running the regular parser and that it's
    // ok to use the utility functions to query the parser.
    taking_actions = true;
    resetTokenStream(0);
    lastToken = tokStream.getPrevious(curtok);
    // Until it reaches the end-of-file token, this outer loop
    // resets the parser and processes the next token.
    ProcessTokens:
    while (current_kind != EOFT_SYMBOL) {
      // if the parser needs to stop processing,
      // it may do so here.
      if (monitor != null && monitor.isCancelled()) break ProcessTokens;
      stateStackTop = -1;
      currentAction = START_STATE;
      starttok = curtok;
      ScanToken:
      for (;;) {
        try {
          stack[++stateStackTop] = currentAction;
        } on RangeError {
          reallocateStacks();
          stack[stateStackTop] = currentAction;
        }
        locationStack[stateStackTop] = curtok;
        // Compute the action on the next character. If it is a reduce action, we do not
        // want to accept it until we are sure that the character in question is can be parsed.
        // What we are trying to avoid is a situation where Curtok is not the EOF token
        // but it yields a default reduce action in the current configuration even though
        // it cannot ultimately be shifted; However, the state on top of the configuration also
        // contains a valid reduce action on EOF which, if taken, would lead to the successful
        // scanning of the token.
        // Thus, if the character can be parsed, we proceed normally. Otherwise, we proceed
        // as if we had reached the end of the file (end of the token, since we are really
        // scanning).
        parseNextCharacter(curtok, current_kind);
        if (currentAction == ERROR_ACTION &&
            current_kind != EOFT_SYMBOL) // if not successful try EOF
            {
          final save_next_token = tokStream.peek(); // save position after curtok
          tokStream.reset(
              tokStream.getStreamLength() - 1); // point to the end of the input
          parseNextCharacter(curtok, EOFT_SYMBOL);
          // assert (currentAction == ACCEPT_ACTION || currentAction == ERROR_ACTION);
          tokStream.reset(
              save_next_token); // reset the stream for the next token after curtok.
        }
        // At this point, currentAction is either a Shift, Shift-Reduce, Accept or Error action.
        if (currentAction > ERROR_ACTION) // Shift-reduce
            {
          lastToken = curtok;
          curtok = tokStream.getToken();
          current_kind = tokStream.getKind(curtok);
          currentAction -= ERROR_ACTION;
          do {
            stateStackTop -= prs.rhs(currentAction) - 1;
            ra.ruleAction(currentAction);
            final lhs_symbol = prs.lhs(currentAction);
            if (lhs_symbol == START_SYMBOL) continue ProcessTokens;
            currentAction = prs.ntAction(stack[stateStackTop], lhs_symbol);
          } while (currentAction <= NUM_RULES);
        } else if (currentAction < ACCEPT_ACTION) // Shift
            {
          lastToken = curtok;
          curtok = tokStream.getToken();
          current_kind = tokStream.getKind(curtok);
        } else if (currentAction == ACCEPT_ACTION) {
          continue ProcessTokens;
        } else {
          break ScanToken;
        } // ERROR_ACTION
      }
      // Whenever we reach this point, an error has been detected.
      // Note that the parser loop above can never reach the ACCEPT
      // point as it is short-circuited each time it reduces a phrase
      // to the START_SYMBOL.
      // If an error is detected on a single bad character,
      // we advance to the next character before resuming the
      // scan. However, if an error is detected after we start
      // scanning a construct, we form a bad token out of the
      // characters that have already been scanned and resume
      // scanning on the character on which the problem was
      // detected. In other words, in that case, we do not advance.
      if (starttok == curtok) {
        if (current_kind == EOFT_SYMBOL) break ProcessTokens;
        tokStream.reportLexicalError(starttok, curtok);
        lastToken = curtok;
        curtok = tokStream.getToken();
        current_kind = tokStream.getKind(curtok);
      } else {
        tokStream.reportLexicalError(starttok, lastToken);
      }
    }
    taking_actions = false; // indicate that we are done
    return;
  }

  // This function takes as argument a configuration ([stack, stackTop], [tokStream, curtok])
  // and determines whether or not curtok can be validly parsed in this configuration. If so,
  // it parses curtok and returns the  shift or shift-reduce action on it. Otherwise, it
  // leaves the configuration unchanged and returns ERROR_ACTION.
  void parseNextCharacter(final int token, final int kind) {
    int start_action = stack[stateStackTop],
        pos = stateStackTop,
        tempStackTop = stateStackTop - 1;
    Scan:
    for (currentAction = tAction(start_action, kind);
    currentAction <= NUM_RULES;
    currentAction = tAction(currentAction, kind)) {
      do {
        final lhs_symbol = prs.lhs(currentAction);
        if (lhs_symbol == START_SYMBOL) break Scan;
        tempStackTop -= prs.rhs(currentAction) - 1;
        final state = tempStackTop > pos
            ? tempStack[tempStackTop]
            : stack[tempStackTop];
        currentAction = prs.ntAction(state, lhs_symbol);
      } while (currentAction <= NUM_RULES);
      if (tempStackTop + 1 >= stack.length) reallocateStacks();
      // ... Update the maximum useful position of the stack,
      // push goto state into (temporary) stack, and compute
      // the next action on the current symbol ...
      pos = pos < tempStackTop ? pos : tempStackTop;
      tempStack[tempStackTop + 1] = currentAction;
    }
    // If no error was detected, we update the configuration up to the point prior to the
    // shift or shift-reduce on the token by processing all reduce and goto actions associated
    // with the current token.
    if (currentAction != ERROR_ACTION) {
      // Note that it is important that the global variable currentAction be used here when
      // we are actually processing the rules. The reason being that the user-defined function
      // ra.ruleAction() may call  functions defined in this class (such as getLastToken())
      // which require that currentAction be properly initialized.
      Replay:
      for (currentAction = tAction(start_action, kind);
      currentAction <= NUM_RULES;
      currentAction = tAction(currentAction, kind)) {
        stateStackTop--;
        do {
          stateStackTop -= prs.rhs(currentAction) - 1;
          ra.ruleAction(currentAction);
          final lhs_symbol = prs.lhs(currentAction);
          if (lhs_symbol == START_SYMBOL) {
            currentAction = starttok ==
                token // null string reduction to START_SYMBOL is illegal
                ? ERROR_ACTION
                : ACCEPT_ACTION;
            break Replay;
          }
          currentAction = prs.ntAction(stack[stateStackTop], lhs_symbol);
        } while (currentAction <= NUM_RULES);
        stack[++stateStackTop] = currentAction;
        locationStack[stateStackTop] = token;
      }
    }
    return;
  }

  // keep looking ahead until we compute a valid action
  int lookahead(int act, final int token) {
    act = prs.lookAhead(act - LA_STATE_OFFSET, tokStream.getKind(token));
    return act > LA_STATE_OFFSET
        ? lookahead(act, tokStream.getNext(token))
        : act;
  }

  // Compute the next action defined on act and sym. If this
  // action requires more lookahead, these lookahead symbols
  // are in the token stream beginning at the next token that
  // is yielded by peek().
  int tAction(int act, final int sym) {
    act = prs.tAction(act, sym);
    return act > LA_STATE_OFFSET ? lookahead(act, tokStream.peek()) : act;
  }

  bool scanNextToken2() {
    return lexNextToken(tokStream.getStreamLength());
  }

  bool scanNextToken([final int? start_offset]) {
    if (start_offset == null) {
      return scanNextToken2();
    }
    resetTokenStream(start_offset);
    return lexNextToken(tokStream.getStreamLength());
  }

  bool lexNextToken(final int end_offset) {
    // Indicate that we are going to run the incremental parser and that
    // it's forbidden to use the utility functions to query the parser.
    taking_actions = false;
    stateStackTop = -1;
    currentAction = START_STATE;
    starttok = curtok;
    action!.reset();
    ScanToken:
    for (;;) {
      try {
        stack[++stateStackTop] = currentAction;
      } on RangeError {
        reallocateStacks();
        stack[stateStackTop] = currentAction;
      }
      // Compute the action on the next character. If it is a reduce action, we do not
      // want to accept it until we are sure that the character in question is parsable.
      // What we are trying to avoid is a situation where curtok is not the EOF token
      // but it yields a default reduce action in the current configuration even though
      // it cannot ultimately be shifted; However, the state on top of the configuration also
      // contains a valid reduce action on EOF which, if taken, would lead to the succesful
      // scanning of the token.
      // Thus, if the character is parsable, we proceed normally. Otherwise, we proceed
      // as if we had reached the end of the file (end of the token, since we are really
      // scanning).
      currentAction = lexNextCharacter(currentAction, current_kind);
      if (currentAction == ERROR_ACTION && current_kind != EOFT_SYMBOL) {
        // if not successful try EOF
        final save_next_token = tokStream.peek(); // save position after curtok
        tokStream.reset(
            tokStream.getStreamLength() - 1); // point to the end of the input
        currentAction = lexNextCharacter(stack[stateStackTop], EOFT_SYMBOL);
        // assert (currentAction == ACCEPT_ACTION || currentAction == ERROR_ACTION);
        tokStream.reset(
            save_next_token); // reset the stream for the next token after curtok.
      }
      action!.add(currentAction); // save the action
      // At this point, currentAction is either a Shift, Shift-Reduce, Accept or Error action.
      if (currentAction > ERROR_ACTION) //Shift-reduce
          {
        curtok = tokStream.getToken();
        if (curtok > end_offset) curtok = tokStream.getStreamLength();
        current_kind = tokStream.getKind(curtok);
        currentAction -= ERROR_ACTION;
        do {
          final lhs_symbol = prs.lhs(currentAction);
          if (lhs_symbol == START_SYMBOL) {
            parseActions();
            return true;
          }
          stateStackTop -= prs.rhs(currentAction) - 1;
          currentAction = prs.ntAction(stack[stateStackTop], lhs_symbol);
        } while (currentAction <= NUM_RULES);
      } else if (currentAction < ACCEPT_ACTION) // Shift
          {
        curtok = tokStream.getToken();
        if (curtok > end_offset) curtok = tokStream.getStreamLength();
        current_kind = tokStream.getKind(curtok);
      } else if (currentAction == ACCEPT_ACTION) {
        return true;
      } else {
        break ScanToken; // ERROR_ACTION
      }
    }
    // Whenever we reach this point, an error has been detected.
    // Note that the parser loop above can never reach the ACCEPT
    // point as it is short-circuited each time it reduces a phrase
    // to the START_SYMBOL.
    // If an error is detected on a single bad character,
    // we advance to the next character before resuming the
    // scan. However, if an error is detected after we start
    // scanning a construct, we form a bad token out of the
    // characters that have already been scanned and resume
    // scanning on the character on which the problem was
    // detected. In other words, in that case, we do not advance.
    if (starttok == curtok) {
      if (current_kind == EOFT_SYMBOL) {
        action = null; // turn into garbage!
        return false;
      }
      lastToken = curtok;
      tokStream.reportLexicalError(starttok, curtok);
      curtok = tokStream.getToken();
      if (curtok > end_offset) curtok = tokStream.getStreamLength();
      current_kind = tokStream.getKind(curtok);
    } else {
      lastToken = tokStream.getPrevious(curtok);
      tokStream.reportLexicalError(starttok, lastToken);
    }
    return true;
  }

  // This function takes as argument a configuration ([stack, stackTop], [tokStream, curtok])
  // and determines whether or not the reduce action the curtok can be validly parsed in this
  // configuration.
  int lexNextCharacter(int act, final int kind) {
    int action_save = action!.size(),
        pos = stateStackTop,
        tempStackTop = stateStackTop - 1;
    act = tAction(act, kind);
    Scan:
    while (act <= NUM_RULES) {
      action!.add(act);
      do {
        final lhs_symbol = prs.lhs(act);
        if (lhs_symbol == START_SYMBOL) {
          if (starttok ==
              curtok) // null string reduction to START_SYMBOL is illegal
              {
            act = ERROR_ACTION;
            break Scan;
          } else {
            parseActions();
            return ACCEPT_ACTION;
          }
        }
        tempStackTop -= prs.rhs(act) - 1;
        final state = tempStackTop > pos
            ? tempStack[tempStackTop]
            : stack[tempStackTop];
        act = prs.ntAction(state, lhs_symbol);
      } while (act <= NUM_RULES);
      if (tempStackTop + 1 >= stack.length) reallocateStacks();
      // ... Update the maximum useful position of the stack,
      // push goto state into (temporary) stack, and compute
      // the next action on the current symbol ...
      pos = pos < tempStackTop ? pos : tempStackTop;
      tempStack[tempStackTop + 1] = act;
      act = tAction(act, kind);
    }
    // If an error was detected, we restore the original configuration.
    // Otherwise, we update configuration up to the point prior to the
    // shift or shift-reduce on the token.
    if (act == ERROR_ACTION) {
      action!.reset(action_save);
    } else {
      stateStackTop = tempStackTop + 1;
      for (var i = pos + 1; i <= stateStackTop; i++) {
        stack[i] = tempStack[i];
      }
    }
    return act;
  }

  // Now do the  parse of the input based on the actions in
  // the list "action" and the sequence of tokens in the token stream.
  void parseActions() {
    // Indicate that we are running the regular parser and that it's
    // ok to use the utility functions to query the parser.
    taking_actions = true;
    curtok = starttok;
    lastToken = tokStream.getPrevious(curtok);
    // Reparse the input...
    stateStackTop = -1;
    currentAction = START_STATE;
    process_actions:
    for (int i = 0; i < action!.size(); i++) {
      stack[++stateStackTop] = currentAction;
      locationStack[stateStackTop] = curtok;
      currentAction = action!.get(i);
      if (currentAction <= NUM_RULES) // a reduce action?
          {
        stateStackTop--; // turn reduction intoshift-reduction
        do {
          stateStackTop -= prs.rhs(currentAction) - 1;
          ra.ruleAction(currentAction);
          final lhs_symbol = prs.lhs(currentAction);
          if (lhs_symbol == START_SYMBOL) {
            // assert(starttok != curtok);  // null string reduction to START_SYMBOL is illegal
            break process_actions;
          }
          currentAction = prs.ntAction(stack[stateStackTop], lhs_symbol);
        } while (currentAction <= NUM_RULES);
      } else // a shift or shift-reduce action
          {
        lastToken = curtok;
        curtok = tokStream.getNext(curtok);
        if (currentAction > ERROR_ACTION) // a shift-reduce action?
            {
          current_kind = tokStream.getKind(curtok);
          currentAction -= ERROR_ACTION;
          do {
            stateStackTop -= prs.rhs(currentAction) - 1;
            ra.ruleAction(currentAction);
            final lhs_symbol = prs.lhs(currentAction);
            if (lhs_symbol == START_SYMBOL) break process_actions;
            currentAction = prs.ntAction(stack[stateStackTop], lhs_symbol);
          } while (currentAction <= NUM_RULES);
        }
      }
    }
    taking_actions = false; // indicate that we are done
    return;
  }
}

class DiagnoseParser {
  Monitor? monitor;
  late TokenStream tokStream;

  late ParseTable prs;
  int ERROR_SYMBOL = 0,
      SCOPE_SIZE = 0,
      MAX_NAME_LENGTH = 0,
      NT_OFFSET = 0,
      LA_STATE_OFFSET = 0,
      NUM_RULES = 0,
      NUM_SYMBOLS = 0,
      START_STATE = 0,
      EOFT_SYMBOL = 0,
      EOLT_SYMBOL = 0,
      ACCEPT_ACTION = 0,
      ERROR_ACTION = 0;

  List<int> list = [];

  int maxErrors = 0;

  int maxTime = 0;

  void setMonitor(final Monitor monitor) {
    this.monitor = monitor;
  }

  // maxErrors is the maximum number of errors to be repaired
  // maxTime is the maximum amount of time allowed for diagnosing
  // but at least one error must be diagnosed
  DiagnoseParser(this.tokStream, this.prs,
      [this.maxErrors = 0, this.maxTime = 0, this.monitor]) {
    main_configuration_stack = ConfigurationStack(prs);
    ERROR_SYMBOL = prs.getErrorSymbol();
    SCOPE_SIZE = prs.getScopeSize();
    MAX_NAME_LENGTH = prs.getMaxNameLength();
    NT_OFFSET = prs.getNtOffset();
    LA_STATE_OFFSET = prs.getLaStateOffset();
    NUM_RULES = prs.getNumRules();
    NUM_SYMBOLS = prs.getNumSymbols();
    START_STATE = prs.getStartState();
    EOFT_SYMBOL = prs.getEoftSymbol();
    EOLT_SYMBOL = prs.getEoltSymbol();
    ACCEPT_ACTION = prs.getAcceptAction();
    ERROR_ACTION = prs.getErrorAction();
    list = List.filled(NUM_SYMBOLS + 1, 0);
  }

  int rhs(final int index) {
    return prs.rhs(index);
  }

  int baseAction(final int index) {
    return prs.baseAction(index);
  }

  int baseCheck(final int index) {
    return prs.baseCheck(index);
  }

  int lhs(final int index) {
    return prs.lhs(index);
  }

  int termCheck(final int index) {
    return prs.termCheck(index);
  }

  int termAction(final int index) {
    return prs.termAction(index);
  }

  int asb(final int index) {
    return prs.asb(index);
  }

  int asr(final int index) {
    return prs.asr(index);
  }

  int nasb(final int index) {
    return prs.nasb(index);
  }

  int nasr(final int index) {
    return prs.nasr(index);
  }

  int terminalIndex(final int index) {
    return prs.terminalIndex(index);
  }

  int nonterminalIndex(final int index) {
    return prs.nonterminalIndex(index);
  }

  int symbolIndex(final int index) {
    return index > NT_OFFSET
        ? nonterminalIndex(index - NT_OFFSET)
        : terminalIndex(index);
  }

  int scopePrefix(final int index) {
    return prs.scopePrefix(index);
  }

  int scopeSuffix(final int index) {
    return prs.scopeSuffix(index);
  }

  int scopeLhs(final int index) {
    return prs.scopeLhs(index);
  }

  int scopeLa(final int index) {
    return prs.scopeLa(index);
  }

  int scopeStateSet(final int index) {
    return prs.scopeStateSet(index);
  }

  int scopeRhs(final int index) {
    return prs.scopeRhs(index);
  }

  int scopeState(final int index) {
    return prs.scopeState(index);
  }

  int inSymb(final int index) {
    return prs.inSymb(index);
  }

  String name(final int index) {
    return prs.name(index);
  }

  int originalState(final int state) {
    return prs.originalState(state);
  }

  int asi(final int state) {
    return prs.asi(state);
  }

  int nasi(final int state) {
    return prs.nasi(state);
  }

  int inSymbol(final int state) {
    return prs.inSymbol(state);
  }

  int ntAction(final int state, final int sym) {
    return prs.ntAction(state, sym);
  }

  bool isNullable(final int symbol) {
    return prs.isNullable(symbol);
  }

  int stateStackTop = -1;
  List<int> stateStack = [];

  List<int> locationStack = [];

  int tempStackTop = -1;
  List<int> tempStack = [];

  int prevStackTop = -1;
  List<int> prevStack = [];

  int nextStackTop = -1;
  List<int> nextStack = [];

  int scopeStackTop = -1;
  List<int> scopeIndex = [];
  List<int> scopePosition = [];

  List<int> buffer = List.filled(BUFF_SIZE, 0);
  late ConfigurationStack main_configuration_stack;

  static const int NIL = -1;
  List<int> stateSeen = [];

  int statePoolTop = -1;
  List<StateInfo?> statePool = [];

  void reallocateStacks() {
    final old_stack_length = stateStack.isEmpty ? 0 : stateStack.length;
    final stack_length = old_stack_length + STACK_INCREMENT;
    if (stateStack.isEmpty) {
      stateStack = List.filled(stack_length, 0);
      locationStack = List.filled(stack_length, 0);
      tempStack = List.filled(stack_length, 0);
      prevStack = List.filled(stack_length, 0);
      nextStack = List.filled(stack_length, 0);
      scopeIndex = List.filled(stack_length, 0);
      scopePosition = List.filled(stack_length, 0);
    } else {
      ArrayList.copy(stateStack, 0, stateStack = List.filled(stack_length, 0),
          0, old_stack_length);
      ArrayList.copy(locationStack, 0,
          locationStack = List.filled(stack_length, 0), 0, old_stack_length);
      ArrayList.copy(tempStack, 0, tempStack = List.filled(stack_length, 0), 0,
          old_stack_length);
      ArrayList.copy(prevStack, 0, prevStack = List.filled(stack_length, 0), 0,
          old_stack_length);
      ArrayList.copy(nextStack, 0, nextStack = List.filled(stack_length, 0), 0,
          old_stack_length);
      ArrayList.copy(scopeIndex, 0, scopeIndex = List.filled(stack_length, 0),
          0, old_stack_length);
      ArrayList.copy(scopePosition, 0,
          scopePosition = List.filled(stack_length, 0), 0, old_stack_length);
    }
    return;
  }

  void diagnose([final int error_token = 0]) {
    diagnoseEntry(0, error_token);
  }

  void diagnoseEntry(final int marker_kind, [final int? error_token]) {
    if (null != error_token) {
      diagnoseEntry2(marker_kind, error_token);
    } else {
      diagnoseEntry1(marker_kind);
    }
  }

  void diagnoseEntry1(final int marker_kind) {
    reallocateStacks();
    tempStackTop = 0;
    tempStack[tempStackTop] = START_STATE;
    tokStream.reset();
    int current_token, current_kind;
    if (marker_kind == 0) {
      current_token = tokStream.getToken();
      current_kind = tokStream.getKind(current_token);
    } else {
      current_token = tokStream.peek();
      current_kind = marker_kind;
    }
    final error_token = parseForError(current_kind);
    // If an error was found, start the diagnosis and recovery.
    if (error_token != 0) diagnoseEntry(marker_kind, error_token);
    return;
  }

  static int currentTimeMillis() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  void diagnoseEntry2(final int marker_kind, int error_token) {
    final action = IntTuple(1 << 18);
    final startTime = currentTimeMillis();
    var errorCount = 0;
    // Compute sequence of actions that leads us to the
    // error_token.
    if (stateStack.isEmpty) {
      reallocateStacks();
    }
    tempStackTop = 0;
    tempStack[tempStackTop] = START_STATE;
    tokStream.reset();
    int current_token, current_kind;
    if (marker_kind == 0) {
      current_token = tokStream.getToken();
      current_kind = tokStream.getKind(current_token);
    } else {
      current_token = tokStream.peek();
      current_kind = marker_kind;
    }
    parseUpToError(action, current_kind, error_token);
    // Start parsing
    stateStackTop = 0;
    stateStack[stateStackTop] = START_STATE;
    tempStackTop = stateStackTop;
    ArrayList.copy(tempStack, 0, stateStack, 0, tempStackTop + 1);
    tokStream.reset();
    if (marker_kind == 0) {
      current_token = tokStream.getToken();
      current_kind = tokStream.getKind(current_token);
    } else {
      current_token = tokStream.peek();
      current_kind = marker_kind;
    }
    locationStack[stateStackTop] = current_token;
    // Process a terminal
    int act;
    do {
      // Synchronize state stacks and update the location stack
      var prev_pos = -1;
      prevStackTop = -1;
      var next_pos = -1;
      nextStackTop = -1;
      var pos = stateStackTop;
      tempStackTop = stateStackTop - 1;
      ArrayList.copy(stateStack, 0, tempStack, 0, stateStackTop + 1);
      var action_index = 0;
      act = action.get(action_index++); // tAction(act, current_kind);
      // When a reduce action is encountered, we compute all REDUCE
      // and associated goto actions induced by the current token.
      // Eventually, a SHIFT, SHIFT-REDUCE, ACCEPT or ERROR action is
      // computed...
      while (act <= NUM_RULES) {
        do {
          tempStackTop -= rhs(act) - 1;
          act = ntAction(tempStack[tempStackTop], lhs(act));
        } while (act <= NUM_RULES);
        // ... Update the maximum useful position of the
        // (STATE_)STACK, push goto state into stack, and
        // compute next action on current symbol ...
        if (tempStackTop + 1 >= stateStack.length) reallocateStacks();
        pos = pos < tempStackTop ? pos : tempStackTop;
        tempStack[tempStackTop + 1] = act;
        act = action.get(action_index++); // tAction(act, current_kind);
      }
      // At this point, we have a shift, shift-reduce, accept or error
      // action.  STACK contains the configuration of the state stack
      // prior to executing any action on current_token. next_stack contains
      // the configuration of the state stack after executing all
      // reduce actions induced by current_token.  The variable pos indicates
      // the highest position in STACK that is still useful after the
      // reductions are executed.
      while (act > ERROR_ACTION ||
          act < ACCEPT_ACTION) // SHIFT-REDUCE action or SHIFT action ?
          {
        // if the parser needs to stop processing,
        // it may do so here.
        if (monitor != null && monitor!.isCancelled()) {
          return;
        }
        nextStackTop = tempStackTop + 1;
        for (var i = next_pos + 1; i <= nextStackTop; i++) {
          nextStack[i] = tempStack[i];
        }
        for (var k = pos + 1; k <= nextStackTop; k++) {
          locationStack[k] = locationStack[stateStackTop];
        }
        // If we have a shift-reduce, process it as well as
        // the goto-reduce actions that follow it.
        if (act > ERROR_ACTION) {
          act -= ERROR_ACTION;
          do {
            nextStackTop -= rhs(act) - 1;
            act = ntAction(nextStack[nextStackTop], lhs(act));
          } while (act <= NUM_RULES);
          pos = pos < nextStackTop ? pos : nextStackTop;
        }
        if (nextStackTop + 1 >= stateStack.length) reallocateStacks();
        tempStackTop = nextStackTop;
        nextStack[++nextStackTop] = act;
        next_pos = nextStackTop;
        // Simulate the parser through the next token without
        // destroying STACK or next_stack.
        current_token = tokStream.getToken();
        current_kind = tokStream.getKind(current_token);
        act = action.get(action_index++); // tAction(act, current_kind);
        while (act <= NUM_RULES) {
          // ... Process all goto-reduce actions following
          // reduction, until a goto action is computed ...
          do {
            final lhs_symbol = lhs(act);
            tempStackTop -= rhs(act) - 1;
            act = tempStackTop > next_pos
                ? tempStack[tempStackTop]
                : nextStack[tempStackTop];
            act = ntAction(act, lhs_symbol);
          } while (act <= NUM_RULES);
          // ... Update the maximum useful position of the
          // (STATE_)STACK, push GOTO state into stack, and
          // compute next action on current symbol ...
          if (tempStackTop + 1 >= stateStack.length) reallocateStacks();
          next_pos = next_pos < tempStackTop ? next_pos : tempStackTop;
          tempStack[tempStackTop + 1] = act;
          act = action.get(action_index++); // tAction(act, current_kind);
        }
        // No error was detected, Read next token into
        // PREVTOK element, advance CURRENT_TOKEN pointer and
        // update stacks.
        if (act != ERROR_ACTION) {
          prevStackTop = stateStackTop;
          for (var i = prev_pos + 1; i <= prevStackTop; i++) {
            prevStack[i] = stateStack[i];
          }
          prev_pos = pos;
          stateStackTop = nextStackTop;
          for (var k = pos + 1; k <= stateStackTop; k++) {
            stateStack[k] = nextStack[k];
          }
          locationStack[stateStackTop] = current_token;
          pos = next_pos;
        }
      }
      // At this stage, either we have an ACCEPT or an ERROR
      // action.
      if (act == ERROR_ACTION) {
        // An error was detected.
        errorCount += 1;
        // Check time and error limits after the first error encountered
        // Exit if number of errors exceeds maxError or if maxTime reached
        if (errorCount > 1) {
          if (maxErrors > 0 && errorCount > maxErrors) break;
          if (maxTime > 0 && currentTimeMillis() - startTime > maxTime) break;
        }
        final candidate = errorRecovery(current_token);
        // if the parser needs to stop processing,
        // it may do so here.
        if (monitor != null && monitor!.isCancelled()) return;
        act = stateStack[stateStackTop];
        // If the recovery was successful on a nonterminal candidate,
        // parse through that candidate and "read" the next token.
        if (candidate.symbol == 0) {
          break;
        } else if (candidate.symbol > NT_OFFSET) {
          final lhs_symbol = candidate.symbol - NT_OFFSET;
          act = ntAction(act, lhs_symbol);
          while (act <= NUM_RULES) {
            stateStackTop -= rhs(act) - 1;
            act = ntAction(stateStack[stateStackTop], lhs(act));
          }
          stateStack[++stateStackTop] = act;
          current_token = tokStream.getToken();
          current_kind = tokStream.getKind(current_token);
          locationStack[stateStackTop] = current_token;
        } else {
          current_kind = candidate.symbol;
          locationStack[stateStackTop] = candidate.location;
        }
        // At this stage, we have a recovery configuration. See how
        // far we can go with it.
        final next_token = tokStream.peek();
        tempStackTop = stateStackTop;
        ArrayList.copy(stateStack, 0, tempStack, 0, stateStackTop + 1);
        error_token = parseForError(current_kind);
        // If an error was found, compute the sequence of actions that reaches
        // the error token. Otherwise, claim victory...
        if (error_token != 0) {
          tokStream.reset(next_token);
          tempStackTop = stateStackTop;
          ArrayList.copy(stateStack, 0, tempStack, 0, stateStackTop + 1);
          parseUpToError(action, current_kind, error_token);
          tokStream.reset(next_token);
        } else {
          act = ACCEPT_ACTION;
        }
      }
    } while (act != ACCEPT_ACTION);
    return;
  }

  // Given the configuration consisting of the states in tempStack
  // and the sequence of tokens (current_kind, followed by the tokens
  // in tokStream), keep parsing until either the parse completes
  // successfully or it encounters an error. If the parse is not
  // succesful, we return the farthest token on which an error was
  // encountered. Otherwise, we return 0.
  int parseForError(int current_kind) {
    var error_token = 0;
    // Get next token in stream and compute initial action
    var curtok = tokStream.getPrevious(tokStream.peek()),
        act = tAction(tempStack[tempStackTop], current_kind);
    // Allocate configuration stack.
    final configuration_stack = ConfigurationStack(prs);
    // Keep parsing until we reach the end of file and succeed or
    // an error is encountered. The list of actions executed will
    // be store in the "action" tuple.
    for (;;) {
      if (act <= NUM_RULES) {
        tempStackTop--;
        do {
          tempStackTop -= rhs(act) - 1;
          act = ntAction(tempStack[tempStackTop], lhs(act));
        } while (act <= NUM_RULES);
      } else if (act > ERROR_ACTION) {
        curtok = tokStream.getToken();
        current_kind = tokStream.getKind(curtok);
        act -= ERROR_ACTION;
        do {
          tempStackTop -= rhs(act) - 1;
          act = ntAction(tempStack[tempStackTop], lhs(act));
        } while (act <= NUM_RULES);
      } else if (act < ACCEPT_ACTION) {
        curtok = tokStream.getToken();
        current_kind = tokStream.getKind(curtok);
      } else if (act == ERROR_ACTION) {
        error_token = error_token > curtok ? error_token : curtok;
        final configuration = configuration_stack.pop();
        if (configuration == null) {
          act = ERROR_ACTION;
        } else {
          tempStackTop = configuration.stack_top;
          configuration.retrieveStack(tempStack);
          act = configuration.act;
          curtok = configuration.curtok;
          // no need to execute: action.reset(configuration.action_length);
          current_kind = tokStream.getKind(curtok);
          tokStream.reset(tokStream.getNext(curtok));
          continue;
        }
        break;
      } else if (act > ACCEPT_ACTION) {
        if (configuration_stack.findConfiguration(
            tempStack, tempStackTop, curtok)) {
          act = ERROR_ACTION;
        } else {
          configuration_stack.push(tempStack, tempStackTop, act + 1, curtok, 0);
          act = baseAction(act);
        }
        continue;
      } else {
        break;
      } // assert(act == ACCEPT_ACTION);
      try {
        tempStack[++tempStackTop] = act;
      } on RangeError {
        reallocateStacks();
        tempStack[tempStackTop] = act;
      }
      act = tAction(act, current_kind);
    }
    return act == ERROR_ACTION ? error_token : 0;
  }

  // Given the configuration consisting of the states in tempStack
  // and the sequence of tokens (current_kind, followed by the tokens
  // in tokStream), parse up to error_token in the tokStream and store
  // all the parsing actions executed in the "action" tuple.
  void parseUpToError(final IntTuple action, int current_kind, final int error_token) {
    // Assume predecessor of next token and compute initial action
    var curtok = tokStream.getPrevious(tokStream.peek());
    var act = tAction(tempStack[tempStackTop], current_kind);
    // Allocate configuration stack.
    final configuration_stack = ConfigurationStack(prs);
    // Keep parsing until we reach the end of file and succeed or
    // an error is encountered. The list of actions executed will
    // be store in the "action" tuple.
    action.reset();
    for (;;) {
      if (act <= NUM_RULES) {
        action.add(act); // save this reduce action
        tempStackTop--;
        do {
          tempStackTop -= rhs(act) - 1;
          act = ntAction(tempStack[tempStackTop], lhs(act));
        } while (act <= NUM_RULES);
      } else if (act > ERROR_ACTION) {
        action.add(act); // save this shift-reduce action
        curtok = tokStream.getToken();
        current_kind = tokStream.getKind(curtok);
        act -= ERROR_ACTION;
        do {
          tempStackTop -= rhs(act) - 1;
          act = ntAction(tempStack[tempStackTop], lhs(act));
        } while (act <= NUM_RULES);
      } else if (act < ACCEPT_ACTION) {
        action.add(act); // save this shift action
        curtok = tokStream.getToken();
        current_kind = tokStream.getKind(curtok);
      } else if (act == ERROR_ACTION) {
        if (curtok != error_token) {
          final configuration = configuration_stack.pop();
          if (configuration == null) {
            act = ERROR_ACTION;
          } else {
            tempStackTop = configuration.stack_top;
            configuration.retrieveStack(tempStack);
            act = configuration.act;
            curtok = configuration.curtok;
            action.reset(configuration.action_length);
            current_kind = tokStream.getKind(curtok);
            tokStream.reset(tokStream.getNext(curtok));
            continue;
          }
        }
        break;
      } else if (act > ACCEPT_ACTION) {
        if (configuration_stack.findConfiguration(
            tempStack, tempStackTop, curtok)) {
          act = ERROR_ACTION;
        } else {
          configuration_stack.push(
              tempStack, tempStackTop, act + 1, curtok, action.size());
          act = baseAction(act);
        }
        continue;
      } else {
        break;
      } // assert(act == ACCEPT_ACTION);
      try {
        tempStack[++tempStackTop] = act;
      } on RangeError {
        reallocateStacks();
        tempStack[tempStackTop] = act;
      }
      act = tAction(act, current_kind);
    }
    action.add(ERROR_ACTION);
    return;
  }

  // Try to parse until first_symbol and all tokens in BUFFER have
  // been consumed, or an error is encountered. Return the number
  // of tokens that were expended before the parse blocked.
  int parseCheck(
      final List<int> stack, final int stack_top, final int first_symbol, final int buffer_position) {
    int buffer_index, current_kind;
    final local_stack = List<int>.filled(stack.length, 0);
    var local_stack_top = stack_top;
    for (var i = 0; i <= stack_top; i++) {
      local_stack[i] = stack[i];
    }
    final configuration_stack = ConfigurationStack(prs);
    // If the first symbol is a nonterminal, process it here.
    var act = local_stack[local_stack_top];
    if (first_symbol > NT_OFFSET) {
      final lhs_symbol = first_symbol - NT_OFFSET;
      buffer_index = buffer_position;
      current_kind = tokStream.getKind(buffer[buffer_index]);
      tokStream.reset(tokStream.getNext(buffer[buffer_index]));
      act = ntAction(act, lhs_symbol);
      while (act <= NUM_RULES) {
        local_stack_top -= rhs(act) - 1;
        act = ntAction(local_stack[local_stack_top], lhs(act));
      }
    } else {
      local_stack_top--;
      buffer_index = buffer_position - 1;
      current_kind = first_symbol;
      tokStream.reset(buffer[buffer_position]);
    }
    // Start parsing the remaining symbols in the buffer
    if (++local_stack_top >= local_stack.length) {
      return buffer_index;
    }
    local_stack[local_stack_top] = act;
    act = tAction(act, current_kind);
    for (;;) {
      if (act <= NUM_RULES) // reduce action
          {
        local_stack_top -= rhs(act);
        act = ntAction(local_stack[local_stack_top], lhs(act));
        while (act <= NUM_RULES) {
          local_stack_top -= rhs(act) - 1;
          act = ntAction(local_stack[local_stack_top], lhs(act));
        }
      } else if (act > ERROR_ACTION) // shift-reduce action
          {
        if (buffer_index++ == MAX_DISTANCE) break;
        current_kind = tokStream.getKind(buffer[buffer_index]);
        tokStream.reset(tokStream.getNext(buffer[buffer_index]));
        act -= ERROR_ACTION;
        do {
          local_stack_top -= rhs(act) - 1;
          act = ntAction(local_stack[local_stack_top], lhs(act));
        } while (act <= NUM_RULES);
      } else if (act < ACCEPT_ACTION) // shift action
          {
        if (buffer_index++ == MAX_DISTANCE) break;
        current_kind = tokStream.getKind(buffer[buffer_index]);
        tokStream.reset(tokStream.getNext(buffer[buffer_index]));
      } else if (act == ERROR_ACTION) {
        final configuration = configuration_stack.pop();
        if (configuration == null) {
          act = ERROR_ACTION;
        } else {
          local_stack_top = configuration.stack_top;
          configuration.retrieveStack(local_stack);
          act = configuration.act;
          buffer_index = configuration.curtok;
          // no need to execute: action.reset(configuration.action_length);
          current_kind = tokStream.getKind(buffer[buffer_index]);
          tokStream.reset(tokStream.getNext(buffer[buffer_index]));
          continue;
        }
        break;
      } else if (act > ACCEPT_ACTION) {
        if (configuration_stack.findConfiguration(
            local_stack, local_stack_top, buffer_index)) {
          act = ERROR_ACTION;
        } else {
          configuration_stack.push(
              local_stack, local_stack_top, act + 1, buffer_index, 0);
          act = baseAction(act);
        }
        continue;
      } else {
        break;
      }
      if (++local_stack_top >= local_stack.length) {
        break; // Stack overflow!!!
      }
      local_stack[local_stack_top] = act;
      act = tAction(act, current_kind);
    }
    return act == ACCEPT_ACTION ? MAX_DISTANCE : buffer_index;
  }

  //  This routine is invoked when an error is encountered.  It
  // tries to diagnose the error and recover from it.  If it is
  // successful, the state stack, the current token and the buffer
  // are readjusted; i.e., after a successful recovery,
  // state_stack_top points to the location in the state stack
  // that contains the state on which to recover; current_token
  // identifies the symbol on which to recover.
  // Up to three configurations may be available when this routine
  // is invoked. PREV_STACK may contain the sequence of states
  // preceding any action on prevtok, STACK always contains the
  // sequence of states preceding any action on current_token, and
  // NEXT_STACK may contain the sequence of states preceding any
  // action on the successor of current_token.
  RepairCandidate errorRecovery(final int error_token) {
    final prevtok = tokStream.getPrevious(error_token);
    // Try primary phase recoveries. If not successful, try secondary
    // phase recoveries.  If not successful and we are at end of the
    // file, we issue the end-of-file error and quit. Otherwise, ...
    var candidate = primaryPhase(error_token);
    if (candidate.symbol != 0) return candidate;
    candidate = secondaryPhase(error_token);
    if (candidate.symbol != 0) return candidate;
    // At this point, primary and (initial attempt at) secondary
    // recovery did not work.  We will now get into "panic mode" and
    // keep trying secondary phase recoveries until we either find
    // a successful recovery or have consumed the remaining input
    // tokens.
    if (tokStream.getKind(error_token) != EOFT_SYMBOL) {
      while (tokStream.getKind(buffer[BUFF_UBOUND]) != EOFT_SYMBOL) {
        candidate = secondaryPhase(buffer[MAX_DISTANCE - MIN_DISTANCE + 2]);
        if (candidate.symbol != 0) return candidate;
      }
    }
    // If no successful recovery is found and we have reached the
    // end of the file, check whether or not any scope recovery is
    // applicable at the end of the file after discarding some
    // states.
    final scope_repair = PrimaryRepairInfo();
    scope_repair.bufferPosition = BUFF_UBOUND;
    for (var top = stateStackTop; top >= 0; top--) {
      scopeTrial(scope_repair, stateStack, top);
      if (scope_repair.distance > 0) break;
    }
    // If any scope repair was successful, emit the message now
    for (var i = 0; i < scopeStackTop; i++) {
      emitError(SCOPE_CODE, -scopeIndex[i], locationStack[scopePosition[i]],
          buffer[1], nonterminalIndex(scopeLhs(scopeIndex[i])));
    }
    // If the original error_token was already pointing to the EOF, issue the EOF-reached message.
    if (tokStream.getKind(error_token) == EOFT_SYMBOL) {
      emitError(EOF_CODE, terminalIndex(EOFT_SYMBOL), prevtok, prevtok);
    } else {
      // We reached the end of the file while panicking. Delete all
      // remaining tokens in the input.
      int i = 0;
      for (i = BUFF_UBOUND; tokStream.getKind(buffer[i]) == EOFT_SYMBOL; i--) {
        //
      }
      emitError(DELETION_CODE, terminalIndex(tokStream.getKind(error_token)),
          error_token, buffer[i]);
    }
    // Create the "failed" candidate and return it.
    candidate.symbol = 0;
    candidate.location = buffer[BUFF_UBOUND]; // point to EOF
    return candidate;
  }

  // This function tries primary and scope recovery on each
  // available configuration.  If a successful recovery is found
  // and no secondary phase recovery can do better, a diagnosis is
  // issued, the configuration is updated and the function returns
  // "true".  Otherwise, it returns "false".
  RepairCandidate primaryPhase(final int error_token) {
    // Initialize the buffer.
    final i = nextStackTop >= 0 ? 3 : 2;
    buffer[i] = error_token;
    for (var j = i; j > 0; j--) {
      buffer[j - 1] = tokStream.getPrevious(buffer[j]);
    }
    for (var k = i + 1; k < BUFF_SIZE; k++) {
      buffer[k] = tokStream.getNext(buffer[k - 1]);
    }
    // If NEXT_STACK_TOP > 0 then the parse was successful on CURRENT_TOKEN
    // and the error was detected on the successor of CURRENT_TOKEN. In
    // that case, first check whether or not primary recovery is
    // possible on next_stack ...
    var repair = PrimaryRepairInfo();
    if (nextStackTop >= 0) {
      repair.bufferPosition = 3;
      checkPrimaryDistance(repair, nextStack, nextStackTop);
    }
    // ... Try primary recovery on the current token and compare
    // the quality of this recovery to the one on the next token...
    final base_repair = PrimaryRepairInfo(repair);
    base_repair.bufferPosition = 2;
    checkPrimaryDistance(base_repair, stateStack, stateStackTop);
    if (base_repair.distance > repair.distance ||
        base_repair.misspellIndex > repair.misspellIndex) repair = base_repair;
    // Finally, if prev_stack_top >= 0 try primary recovery on
    // the prev_stack configuration and compare it to the best
    // recovery computed thus far.
    if (prevStackTop >= 0) {
      final prev_repair = PrimaryRepairInfo(repair);
      prev_repair.bufferPosition = 1;
      checkPrimaryDistance(prev_repair, prevStack, prevStackTop);
      if (prev_repair.distance > repair.distance ||
          prev_repair.misspellIndex > repair.misspellIndex) {
        repair = prev_repair;
      }
    }
    // Before accepting the best primary phase recovery obtained,
    // ensure that we cannot do better with a similar secondary
    // phase recovery.
    final candidate = RepairCandidate();
    if (nextStackTop >= 0) // next_stack available
        {
      if (secondaryCheck(nextStack, nextStackTop, 3, repair.distance)) {
        return candidate;
      }
    } else if (secondaryCheck(stateStack, stateStackTop, 2, repair.distance)) {
      return candidate;
    }
    // First, adjust distance if the recovery is on the error token;
    // it is important that the adjustment be made here and not at
    // each primary trial to prevent the distance tests from being
    // biased in favor of deferred recoveries which have access to
    // more input tokens...
    repair.distance = repair.distance - repair.bufferPosition + 1;
    // ...Next, adjust the distance if the recovery is a deletion or
    // (some form of) substitution...
    if (repair.code == INVALID_CODE ||
        repair.code == DELETION_CODE ||
        repair.code == SUBSTITUTION_CODE ||
        repair.code == MERGE_CODE) repair.distance--;
    // ... After adjustment, check if the most successful primary
    // recovery can be applied.  If not, continue with more radical
    // recoveries...
    if (repair.distance < MIN_DISTANCE) return candidate;
    // When processing an insertion error, if the token preceeding
    // the error token is not available, we change the repair code
    // into a BEFORE_CODE to instruct the reporting routine that it
    // indicates that the repair symbol should be inserted before
    // the error token.
    if (repair.code == INSERTION_CODE) {
      if (tokStream.getKind(buffer[repair.bufferPosition - 1]) == 0) {
        repair.code = BEFORE_CODE;
      }
    }
    // Select the proper sequence of states on which to recover,
    // update stack accordingly and call diagnostic routine.
    if (repair.bufferPosition == 1) {
      stateStackTop = prevStackTop;
      ArrayList.copy(prevStack, 0, stateStack, 0, stateStackTop + 1);
    } else if (nextStackTop >= 0 && repair.bufferPosition >= 3) {
      stateStackTop = nextStackTop;
      ArrayList.copy(nextStack, 0, stateStack, 0, stateStackTop + 1);
      locationStack[stateStackTop] = buffer[3];
    }
    return primaryDiagnosis(repair);
  }

  //  This function checks whether or not a given state has a
  // candidate, whose string representaion is a merging of the two
  // tokens at positions buffer_position and buffer_position+1 in
  // the buffer.  If so, it returns the candidate in question;
  // otherwise it returns 0.
  int mergeCandidate(final int state, final int buffer_position) {
    final str = tokStream.getName(buffer[buffer_position]) +
        tokStream.getName(buffer[buffer_position + 1]);
    for (var k = asi(state); asr(k) != 0; k++) {
      final i = terminalIndex(asr(k));
      if (str.length == name(i).length) {
        if (str.toLowerCase() == (name(i).toLowerCase())) return asr(k);
      }
    }
    return 0;
  }

  // This procedure takes as arguments a parsing configuration
  // consisting of a state stack (stack and stack_top) and a fixed
  // number of input tokens (starting at buffer_position) in the
  // input BUFFER; and some reference arguments: repair_code,
  // distance, misspell_index, candidate, and stack_position
  // which it sets based on the best possible recovery that it
  // finds in the given configuration.  The effectiveness of a
  // a repair is judged based on two criteria:
  //       1) the number of tokens that can be parsed after the repair
  //              is applied: distance.
  //       2) how close to perfection is the candidate that is chosen:
  //              misspell_index.
  // When this procedure is entered, distance, misspell_index and
  // repair_code are assumed to be initialized.
  void checkPrimaryDistance(
      final PrimaryRepairInfo repair, final List<int> stck, final int stack_top) {
    //  First, try scope recovery.
    final scope_repair = PrimaryRepairInfo(repair);
    scopeTrial(scope_repair, stck, stack_top);
    if (scope_repair.distance > repair.distance) repair.copy(scope_repair);
    //  Next, try merging the error token with its successor.
    var symbol = mergeCandidate(stck[stack_top], repair.bufferPosition);
    if (symbol != 0) {
      final j = parseCheck(stck, stack_top, symbol, repair.bufferPosition + 2);
      if ((j > repair.distance) ||
          (j == repair.distance && repair.misspellIndex < 10)) {
        repair.misspellIndex = 10;
        repair.symbol = symbol;
        repair.distance = j;
        repair.code = MERGE_CODE;
      }
    }
    // Next, try deletion of the error token.
    final j = parseCheck(
        stck,
        stack_top,
        tokStream.getKind(buffer[repair.bufferPosition + 1]),
        repair.bufferPosition + 2);
    final k = tokStream.getKind(buffer[repair.bufferPosition]) == EOLT_SYMBOL &&
        tokStream.afterEol(buffer[repair.bufferPosition + 1])
        ? 10
        : 0;
    if (j > repair.distance ||
        (j == repair.distance && k > repair.misspellIndex)) {
      repair.misspellIndex = k;
      repair.code = DELETION_CODE;
      repair.distance = j;
    }
    // Update the error configuration by simulating all reduce and
    // goto actions induced by the error token. Then assign the top
    // most state of the new configuration to next_state.
    var next_state = stck[stack_top], max_pos = stack_top;
    tempStackTop = stack_top - 1;
    tokStream.reset(buffer[repair.bufferPosition + 1]);
    var tok = tokStream.getKind(buffer[repair.bufferPosition]),
        act = tAction(next_state, tok);
    while (act <= NUM_RULES) {
      do {
        final lhs_symbol = lhs(act);
        tempStackTop -= rhs(act) - 1;
        act = tempStackTop > max_pos
            ? tempStack[tempStackTop]
            : stck[tempStackTop];
        act = ntAction(act, lhs_symbol);
      } while (act <= NUM_RULES);
      max_pos = max_pos < tempStackTop ? max_pos : tempStackTop;
      tempStack[tempStackTop + 1] = act;
      next_state = act;
      act = tAction(next_state, tok);
    }
    //  Next, place the list of candidates in proper order.
    var root = 0;
    for (var i = asi(next_state); asr(i) != 0; i++) {
      symbol = asr(i);
      if (symbol != EOFT_SYMBOL && symbol != ERROR_SYMBOL) {
        if (root == 0) {
          list[symbol] = symbol;
        } else {
          list[symbol] = list[root];
          list[root] = symbol;
        }
        root = symbol;
      }
    }
    if (stck[stack_top] != next_state) {
      for (var i = asi(stck[stack_top]); asr(i) != 0; i++) {
        symbol = asr(i);
        if (symbol != EOFT_SYMBOL &&
            symbol != ERROR_SYMBOL &&
            list[symbol] == 0) {
          if (root == 0) {
            list[symbol] = symbol;
          } else {
            list[symbol] = list[root];
            list[root] = symbol;
          }
          root = symbol;
        }
      }
    }
    final head = list[root];
    list[root] = 0;
    root = head;
    //  Next, try insertion for each possible candidate available in
    // the current state, except EOFT and ERROR_SYMBOL.
    symbol = root;
    while (symbol != 0) {
      final m = parseCheck(stck, stack_top, symbol, repair.bufferPosition);
      final n = symbol == EOLT_SYMBOL &&
          tokStream.afterEol(buffer[repair.bufferPosition])
          ? 10
          : 0;
      if (m > repair.distance ||
          (m == repair.distance && n > repair.misspellIndex)) {
        repair.misspellIndex = n;
        repair.distance = m;
        repair.symbol = symbol;
        repair.code = INSERTION_CODE;
      }
      symbol = list[symbol];
    }
    //  Next, Try substitution for each possible candidate available
    // in the current state, except EOFT and ERROR_SYMBOL.
    symbol = root;
    while (symbol != 0) {
      final m = parseCheck(stck, stack_top, symbol, repair.bufferPosition + 1);
      final n = symbol == EOLT_SYMBOL &&
          tokStream.afterEol(buffer[repair.bufferPosition + 1])
          ? 10
          : misspell(symbol, buffer[repair.bufferPosition]);
      if (m > repair.distance ||
          (m == repair.distance && n > repair.misspellIndex)) {
        repair.misspellIndex = n;
        repair.distance = m;
        repair.symbol = symbol;
        repair.code = SUBSTITUTION_CODE;
      }
      final s = symbol;
      symbol = list[symbol];
      list[s] = 0; // reset element
    }
    // Next, we try to insert a nonterminal candidate in front of the
    // error token, or substituting a nonterminal candidate for the
    // error token. Precedence is given to insertion.
    for (var nt_index = nasi(stck[stack_top]);
    nasr(nt_index) != 0;
    nt_index++) {
      symbol = nasr(nt_index) + NT_OFFSET;
      var n = parseCheck(stck, stack_top, symbol, repair.bufferPosition + 1);
      if (n > repair.distance) {
        repair.misspellIndex = 0;
        repair.distance = n;
        repair.symbol = symbol;
        repair.code = INVALID_CODE;
      }
      n = parseCheck(stck, stack_top, symbol, repair.bufferPosition);
      if (n > repair.distance ||
          (n == repair.distance && repair.code == INVALID_CODE)) {
        repair.misspellIndex = 0;
        repair.distance = n;
        repair.symbol = symbol;
        repair.code = INSERTION_CODE;
      }
    }
    return;
  }

  // This procedure is invoked to issue a diagnostic message and
  // adjust the input buffer.  The recovery in question is either
  // the insertion of one or more scopes, the merging of the error
  // token with its successor, the deletion of the error token,
  // the insertion of a single token in front of the error token
  // or the substitution of another token for the error token.
  RepairCandidate primaryDiagnosis(final PrimaryRepairInfo repair) {
    //  Issue diagnostic.
    final prevtok = buffer[repair.bufferPosition - 1];
    final current_token = buffer[repair.bufferPosition];
    switch (repair.code) {
      case INSERTION_CODE:
      case BEFORE_CODE:
        {
          final name_index = repair.symbol > NT_OFFSET
              ? getNtermIndex(stateStack[stateStackTop], repair.symbol,
              repair.bufferPosition)
              : getTermIndex(stateStack, stateStackTop, repair.symbol,
              repair.bufferPosition);
          final tok = repair.code == INSERTION_CODE ? prevtok : current_token;
          emitError(repair.code, name_index, tok, tok);
          break;
        }
      case INVALID_CODE:
        {
          final name_index = getNtermIndex(stateStack[stateStackTop],
              repair.symbol, repair.bufferPosition + 1);
          emitError(repair.code, name_index, current_token, current_token);
          break;
        }
      case SUBSTITUTION_CODE:
        {
          int name_index;
          if (repair.misspellIndex >= 6) {
            name_index = terminalIndex(repair.symbol);
          } else {
            name_index = getTermIndex(stateStack, stateStackTop, repair.symbol,
                repair.bufferPosition + 1);
            if (name_index != terminalIndex(repair.symbol)) {
              repair.code = INVALID_CODE;
            }
          }
          emitError(repair.code, name_index, current_token, current_token);
          break;
        }
      case MERGE_CODE:
        emitError(repair.code, terminalIndex(repair.symbol), current_token,
            tokStream.getNext(current_token));
        break;
      case SCOPE_CODE:
        {
          for (var i = 0; i < scopeStackTop; i++) {
            emitError(
                repair.code,
                -scopeIndex[i],
                locationStack[scopePosition[i]],
                prevtok,
                nonterminalIndex(scopeLhs(scopeIndex[i])));
          }
          repair.symbol = scopeLhs(scopeIndex[scopeStackTop]) + NT_OFFSET;
          stateStackTop = scopePosition[scopeStackTop];
          emitError(
              repair.code,
              -scopeIndex[scopeStackTop],
              locationStack[scopePosition[scopeStackTop]],
              prevtok,
              getNtermIndex(stateStack[stateStackTop], repair.symbol,
                  repair.bufferPosition));
          break;
        }
      default: // deletion
        emitError(repair.code, terminalIndex(ERROR_SYMBOL), current_token,
            current_token);
    }
    //  Update buffer.
    final candidate = RepairCandidate();
    switch (repair.code) {
      case INSERTION_CODE:
      case BEFORE_CODE:
      case SCOPE_CODE:
        candidate.symbol = repair.symbol;
        candidate.location = buffer[repair.bufferPosition];
        tokStream.reset(buffer[repair.bufferPosition]);
        break;
      case INVALID_CODE:
      case SUBSTITUTION_CODE:
        candidate.symbol = repair.symbol;
        candidate.location = buffer[repair.bufferPosition];
        tokStream.reset(buffer[repair.bufferPosition + 1]);
        break;
      case MERGE_CODE:
        candidate.symbol = repair.symbol;
        candidate.location = buffer[repair.bufferPosition];
        tokStream.reset(buffer[repair.bufferPosition + 2]);
        break;
      default: // deletion
        candidate.location = buffer[repair.bufferPosition + 1];
        candidate.symbol = tokStream.getKind(buffer[repair.bufferPosition + 1]);
        tokStream.reset(buffer[repair.bufferPosition + 2]);
        break;
    }
    return candidate;
  }

  // This function takes as parameter an integer STACK_TOP that
  // points to a STACK element containing the state on which a
  // primary recovery will be made; the terminal candidate on which
  // to recover; and an integer: buffer_position, which points to
  // the position of the next input token in the BUFFER.  The
  // parser is simulated until a shift (or shift-reduce) action
  // is computed on the candidate.  Then we proceed to compute the
  // the name index of the highest level nonterminal that can
  // directly or indirectly produce the candidate.
  int getTermIndex(
      final List<int> stck, final int stack_top, int tok, final int buffer_position) {
    // Initialize stack index of temp_stack and initialize maximum
    // position of state stack that is still useful.
    var act = stck[stack_top], max_pos = stack_top, highest_symbol = tok;
    tempStackTop = stack_top - 1;
    // Compute all reduce and associated actions induced by the
    // candidate until a SHIFT or SHIFT-REDUCE is computed. ERROR
    // and ACCEPT actions cannot be computed on the candidate in
    // this context, since we know that it is suitable for recovery.
    tokStream.reset(buffer[buffer_position]);
    act = tAction(act, tok);
    while (act <= NUM_RULES) {
      // Process all goto-reduce actions following reduction,
      // until a goto action is computed ...
      do {
        final lhs_symbol = lhs(act);
        tempStackTop -= rhs(act) - 1;
        act = tempStackTop > max_pos
            ? tempStack[tempStackTop]
            : stck[tempStackTop];
        act = ntAction(act, lhs_symbol);
      } while (act <= NUM_RULES);
      // Compute new maximum useful position of (STATE_)stack,
      // push goto state into the stack, and compute next
      // action on candidate ...
      max_pos = max_pos < tempStackTop ? max_pos : tempStackTop;
      tempStack[tempStackTop + 1] = act;
      act = tAction(act, tok);
    }
    // At this stage, we have simulated all actions induced by the
    // candidate and we are ready to shift or shift-reduce it. First,
    // set tok and next_ptr appropriately and identify the candidate
    // as the initial highest_symbol. If a shift action was computed
    // on the candidate, update the stack and compute the next
    // action. Next, simulate all actions possible on the next input
    // token until we either have to shift it or are about to reduce
    // below the initial starting point in the stack (indicated by
    // max_pos as computed in the previous loop).  At that point,
    // return the highest_symbol computed.
    tempStackTop++; // adjust top of stack to reflect last goto
    // next move is shift or shift-reduce.
    final threshold = tempStackTop;
    tok = tokStream.getKind(buffer[buffer_position]);
    tokStream.reset(buffer[buffer_position + 1]);
    if (act > ERROR_ACTION) {
      act -= ERROR_ACTION;
    } else if (act < ACCEPT_ACTION) // shift on candidate
        {
      tempStack[tempStackTop + 1] = act;
      act = tAction(act, tok);
    }
    while (act <= NUM_RULES) {
      // Process all goto-reduce actions following reduction,
      // until a goto action is computed ...
      do {
        final lhs_symbol = lhs(act);
        tempStackTop -= rhs(act) - 1;
        if (tempStackTop < threshold) {
          return highest_symbol > NT_OFFSET
              ? nonterminalIndex(highest_symbol - NT_OFFSET)
              : terminalIndex(highest_symbol);
        }
        if (tempStackTop == threshold) highest_symbol = lhs_symbol + NT_OFFSET;
        act = tempStackTop > max_pos
            ? tempStack[tempStackTop]
            : stck[tempStackTop];
        act = ntAction(act, lhs_symbol);
      } while (act <= NUM_RULES);
      tempStack[tempStackTop + 1] = act;
      act = tAction(act, tok);
    }
    return highest_symbol > NT_OFFSET
        ? nonterminalIndex(highest_symbol - NT_OFFSET)
        : terminalIndex(highest_symbol);
  }

  // This function takes as parameter a starting state number:
  // start, a nonterminal symbol, A (candidate), and an integer,
  // buffer_position,  which points to the position of the next
  // input token in the BUFFER.
  // It returns the highest level non-terminal B such that
  // B =>*rm A.  I.e., there does not exists a nonterminal C such
  // that C =>+rm B. (Recall that for an LALR(k) grammar if
  // C =>+rm B, it cannot be the case that B =>+rm C)
  int getNtermIndex(final int start, final int sym, final int buffer_position) {
    var highest_symbol = sym - NT_OFFSET,
        tok = tokStream.getKind(buffer[buffer_position]);
    tokStream.reset(buffer[buffer_position + 1]);
    // Initialize stack index of temp_stack and initialize maximum
    // position of state stack that is still useful.
    tempStackTop = 0;
    tempStack[tempStackTop] = start;
    var act = ntAction(start, highest_symbol);
    if (act > NUM_RULES) // goto action?
        {
      tempStack[tempStackTop + 1] = act;
      act = tAction(act, tok);
    }
    while (act <= NUM_RULES) {
      // Process all goto-reduce actions following reduction,
      // until a goto action is computed ...
      do {
        tempStackTop -= rhs(act) - 1;
        if (tempStackTop < 0) return nonterminalIndex(highest_symbol);
        if (tempStackTop == 0) highest_symbol = lhs(act);
        act = ntAction(tempStack[tempStackTop], lhs(act));
      } while (act <= NUM_RULES);
      tempStack[tempStackTop + 1] = act;
      act = tAction(act, tok);
    }
    return nonterminalIndex(highest_symbol);
  }

  //  Check whether or not there is a high probability that a
  // given string is a misspelling of another.
  // Certain singleton symbols (such as ":" and ";") are also
  // considered to be misspellings of each other.
  int misspell(final int sym, final int tok) {
    // Set up the two strings in question. Note that there is a "0"
    // gate added at the end of each string. This is important as
    // the algorithm assumes that it can "peek" at the symbol immediately
    // following the one that is being analysed.
    var s1 = name(terminalIndex(sym)).toLowerCase();
    final n = s1.length;
    s1 += '\u0000';
    var s2 = (tokStream.getName(tok)).toLowerCase();
    final m = s2.length < MAX_NAME_LENGTH ? s2.length : MAX_NAME_LENGTH;
    s2 = s2.substring(0, m) + '\u0000';
    //  Singleton misspellings:
    //  ;      <---->     ,
    //  ;      <---->     :
    //  .      <---->     ,
    //  '      <---->     "
    if (n == 1 && m == 1) {
      if ((s1[0] == ';' && s2[0] == ',') ||
          (s1[0] == ',' && s2[0] == ';') ||
          (s1[0] == ';' && s2[0] == ':') ||
          (s1[0] == ':' && s2[0] == ';') ||
          (s1[0] == '.' && s2[0] == ',') ||
          (s1[0] == ',' && s2[0] == '.') ||
          (s1[0] == '\'' && s2[0] == '\"') ||
          (s1[0] == '\"' && s2[0] == '\'')) {
        return 3;
      }
    }
    // Scan the two strings. Increment "match" count for each match.
    // When a transposition is encountered, increase "match" count
    // by two but count it as one error. When a typo is found, skip
    // it and count it as one error. Otherwise we have a mismatch; if
    // one of the strings is longer, increment its index, otherwise,
    // increment both indices and continue.
    // This algorithm is an adaptation of a bool misspelling
    // algorithm proposed by Juergen Uhl.
    var count = 0, prefix_length = 0, num_errors = 0;
    var i = 0, j = 0;
    while ((i < n) && (j < m)) {
      if (s1[i] == s2[j]) {
        count++;
        i++;
        j++;
        if (num_errors == 0) prefix_length++;
      } else if (s1[i + 1] == s2[j] && s1[i] == s2[j + 1]) // transposition
          {
        count += 2;
        i += 2;
        j += 2;
        num_errors++;
      } else if (s1[i + 1] == s2[j + 1]) // mismatch
          {
        i += 2;
        j += 2;
        num_errors++;
      } else {
        if ((n - i) > (m - j)) {
          i++;
        } else if ((m - j) > (n - i)) {
          j++;
        } else {
          i++;
          j++;
        }
        num_errors++;
      }
    }
    if (i < n || j < m) num_errors++;
    if (num_errors > ((n < m ? n : m) / 6 + 1)) count = prefix_length;
    return (count * 10 / ((n < s1.length ? s1.length : n) + num_errors))
        .floor();
  }

  void scopeTrial(final PrimaryRepairInfo repair, final List<int> stack, final int stack_top) {
    if (stateSeen.length < stateStack.length) {
      stateSeen = List<int>.filled(stateStack.length, 0);
    }
    for (var i = 0; i < stateStack.length; i++) {
      stateSeen[i] = NIL;
    }
    statePoolTop = 0;
    if (statePool.length < stateStack.length) {
      statePool = List.filled(stateStack.length, null);
    }
    scopeTrialCheck(repair, stack, stack_top, 0);
    repair.code = SCOPE_CODE;
    repair.misspellIndex = 10;
    return;
  }

  void scopeTrialCheck(
      final PrimaryRepairInfo repair, final List<int> stack, final int stack_top, final int indx) {
    StateInfo? info;
    for (var i = stateSeen[stack_top]; i != NIL; i = info.next) {
      info = statePool[i];
      if (null == info) {
        break;
      }
      if (info.state == stack[stack_top]) return;
    }
    final old_state_pool_top = statePoolTop++;
    if (statePoolTop >= statePool.length) {
      ArrayList.copy(statePool, 0,
          statePool = List.filled(statePoolTop * 2, null), 0, statePoolTop);
    }
    statePool[old_state_pool_top] =
        StateInfo(stack[stack_top], stateSeen[stack_top]);
    stateSeen[stack_top] = old_state_pool_top;
    final action = IntTuple(1 << 3);
    for (var i = 0; i < SCOPE_SIZE; i++) {
      // Compute the action (or set of actions in case of conflicts) that
      // can be executed on the scope lookahead symbol. Save the action(s)
      // in the action tuple.
      action.reset();
      var act = tAction(stack[stack_top], scopeLa(i));
      if (act > ACCEPT_ACTION && act < ERROR_ACTION) // conflicting actions?
          {
        do {
          action.add(baseAction(act++));
        } while (baseAction(act) != 0);
      } else {
        action.add(act);
      }
      // For each action defined on the scope lookahead symbol,
      // try scope recovery.
      for (var action_index = 0; action_index < action.size(); action_index++) {
        tokStream.reset(buffer[repair.bufferPosition]);
        tempStackTop = stack_top - 1;
        var max_pos = stack_top;
        act = action.get(action_index);
        while (act <= NUM_RULES) {
          // ... Process all goto-reduce actions following
          // reduction, until a goto action is computed ...
          do {
            final lhs_symbol = lhs(act);
            tempStackTop -= rhs(act) - 1;
            act = tempStackTop > max_pos
                ? tempStack[tempStackTop]
                : stack[tempStackTop];
            act = ntAction(act, lhs_symbol);
          } while (act <= NUM_RULES);
          if (tempStackTop + 1 >= stateStack.length) return;
          max_pos = max_pos < tempStackTop ? max_pos : tempStackTop;
          tempStack[tempStackTop + 1] = act;
          act = tAction(act, scopeLa(i));
        }
        // If the lookahead symbol is parsable, then we check
        // whether or not we have a match between the scope
        // prefix and the transition symbols corresponding to
        // the states on top of the stack.
        if (act != ERROR_ACTION) {
          int j, k = scopePrefix(i);
          for (j = tempStackTop + 1;
          j >= (max_pos + 1) && inSymbol(tempStack[j]) == scopeRhs(k);
          j--) {
            k++;
          }
          if (j == max_pos) {
            for (j = max_pos;
            j >= 1 && inSymbol(stack[j]) == scopeRhs(k);
            j--) {
              k++;
            }
          }
          // If the prefix matches, check whether the state
          // newly exposed on top of the stack, (after the
          // corresponding prefix states are popped from the
          // stack), is in the set of "source states" for the
          // scope in question and that it is at a position
          // below the threshold indicated by MARKED_POS.
          final marked_pos = max_pos < stack_top ? max_pos + 1 : stack_top;
          if (scopeRhs(k) == 0 && j < marked_pos) // match?
              {
            final stack_position = j;
            for (j = scopeStateSet(i);
            stack[stack_position] != scopeState(j) && scopeState(j) != 0;
            j++) {
              // ?
            }
            // If the top state is valid for scope recovery,
            // the left-hand side of the scope is used as
            // starting symbol and we calculate how far the
            // parser can advance within the forward context
            // after parsing the left-hand symbol.
            if (scopeState(j) != 0) {
              // state was found
              final previous_distance = repair.distance;
              final distance = parseCheck(stack, stack_position, scopeLhs(i) + NT_OFFSET, repair.bufferPosition);
              // if the recovery is not successful, we
              // update the stack with all actions induced
              // by the left-hand symbol, and recursively
              // call SCOPE_TRIAL_CHECK to try again.
              // Otherwise, the recovery is successful. If
              // the new distance is greater than the
              // initial SCOPE_DISTANCE, we update
              // SCOPE_DISTANCE and set scope_stack_top to INDX
              // to indicate the number of scopes that are
              // to be applied for a succesful  recovery.
              // NOTE that this procedure cannot get into
              // an infinite loop, since each prefix match
              // is guaranteed to take us to a lower point
              // within the stack.
              if ((distance - repair.bufferPosition + 1) < MIN_DISTANCE) {
                var top = stack_position;
                act = ntAction(stack[top], scopeLhs(i));
                while (act <= NUM_RULES) {
                  top -= rhs(act) - 1;
                  act = ntAction(stack[top], lhs(act));
                }
                top++;
                j = act;
                act = stack[top]; // save
                stack[top] = j; // swap
                scopeTrialCheck(repair, stack, top, indx + 1);
                stack[top] = act; // restore
              } else if (distance > repair.distance) {
                scopeStackTop = indx;
                repair.distance = distance;
              }
              // If no other recovery possibility is left (due to
              // backtracking and we are at the end of the input,
              // then we favor a scope recovery over all other kinds
              // of recovery.
              if ( // TODO: main_configuration_stack.size() == 0 && // no other bactracking possibilities left
              tokStream.getKind(buffer[repair.bufferPosition]) ==
                  EOFT_SYMBOL &&
                  repair.distance == previous_distance) {
                scopeStackTop = indx;
                repair.distance = MAX_DISTANCE;
              }
              // If this scope recovery has beaten the
              // previous distance, then we have found a
              // better recovery (or this recovery is one
              // of a list of scope recoveries). Record
              // its information at the proper location
              // (INDX) in SCOPE_INDEX and SCOPE_STACK.
              if (repair.distance > previous_distance) {
                scopeIndex[indx] = i;
                scopePosition[indx] = stack_position;
                return;
              }
            }
          }
        }
      }
    }
  }

  // This function computes the ParseCheck distance for the best
  // possible secondary recovery for a given configuration that
  // either deletes none or only one symbol in the forward context.
  // If the recovery found is more effective than the best primary
  // recovery previously computed, then the function returns true.
  // Only misplacement, scope and manual recoveries are attempted;
  // simple insertion or substitution of a nonterminal are tried
  // in CHECK_PRIMARY_DISTANCE as part of primary recovery.
  bool secondaryCheck(
      final List<int> stack, final int stack_top, final int buffer_position, final int distance) {
    for (var top = stack_top - 1; top >= 0; top--) {
      final j = parseCheck(stack, top, tokStream.getKind(buffer[buffer_position]),
          buffer_position + 1);
      if (((j - buffer_position + 1) > MIN_DISTANCE) && (j > distance)) {
        return true;
      }
    }
    final scope_repair = PrimaryRepairInfo();
    scope_repair.bufferPosition = buffer_position + 1;
    scope_repair.distance = distance;
    scopeTrial(scope_repair, stack, stack_top);
    return (scope_repair.distance - buffer_position) > MIN_DISTANCE &&
        scope_repair.distance > distance;
  }

  // Secondary_phase is a bool function that checks whether or
  // not some form of secondary recovery is applicable to one of
  // the error configurations. First, if "next_stack" is available,
  // misplacement and secondary recoveries are attempted on it.
  // Then, in any case, these recoveries are attempted on "stack".
  // If a successful recovery is found, a diagnosis is issued, the
  // configuration is updated and the function returns "true".
  // Otherwise, the function returns false.
  RepairCandidate secondaryPhase(final int error_token) {
    final repair = SecondaryRepairInfo();
    final misplaced_repair = SecondaryRepairInfo();
    // If the next_stack is available, try misplaced and secondary
    // recovery on it first.
    var next_last_index = 0;
    if (nextStackTop >= 0) {
      int save_location;
      buffer[2] = error_token;
      buffer[1] = tokStream.getPrevious(buffer[2]);
      buffer[0] = tokStream.getPrevious(buffer[1]);
      for (var k = 3; k < BUFF_UBOUND; k++) {
        buffer[k] = tokStream.getNext(buffer[k - 1]);
      }
      buffer[BUFF_UBOUND] = tokStream.badToken(); // elmt not available
      // If we are at the end of the input stream, compute the
      // index position of the first EOFT symbol (last useful
      // index).
      for (next_last_index = MAX_DISTANCE - 1;
      next_last_index >= 1 &&
          tokStream.getKind(buffer[next_last_index]) == EOFT_SYMBOL;
      next_last_index--) {
        // ?
      }
      next_last_index = next_last_index + 1;
      save_location = locationStack[nextStackTop];
      locationStack[nextStackTop] = buffer[2];
      misplaced_repair.numDeletions = nextStackTop;
      misplacementRecovery(
          misplaced_repair, nextStack, nextStackTop, next_last_index, true);
      if (misplaced_repair.recoveryOnNextStack) misplaced_repair.distance++;
      repair.numDeletions = nextStackTop + BUFF_UBOUND;
      secondaryRecovery(repair, nextStack, nextStackTop, next_last_index, true);
      if (repair.recoveryOnNextStack) repair.distance++;
      locationStack[nextStackTop] = save_location;
    } else // next_stack not available, initialize ...
        {
      misplaced_repair.numDeletions = stateStackTop;
      repair.numDeletions = stateStackTop + BUFF_UBOUND;
    }
    // Try secondary recovery on the "stack" configuration.
    buffer[3] = error_token;
    buffer[2] = tokStream.getPrevious(buffer[3]);
    buffer[1] = tokStream.getPrevious(buffer[2]);
    buffer[0] = tokStream.getPrevious(buffer[1]);
    for (var k = 4; k < BUFF_SIZE; k++) {
      buffer[k] = tokStream.getNext(buffer[k - 1]);
    }
    int last_index;
    for (last_index = MAX_DISTANCE - 1;
    last_index >= 1 && tokStream.getKind(buffer[last_index]) == EOFT_SYMBOL;
    last_index--) {
      // ?
    }
    last_index++;
    misplacementRecovery(
        misplaced_repair, stateStack, stateStackTop, last_index, false);
    secondaryRecovery(repair, stateStack, stateStackTop, last_index, false);
    // If a successful misplaced recovery was found, compare it with
    // the most successful secondary recovery.  If the misplaced
    // recovery either deletes fewer symbols or parse-checks further
    // then it is chosen.
    if (misplaced_repair.distance > MIN_DISTANCE) {
      if (misplaced_repair.numDeletions <= repair.numDeletions ||
          (misplaced_repair.distance - misplaced_repair.numDeletions) >=
              (repair.distance - repair.numDeletions)) {
        repair.code = MISPLACED_CODE;
        repair.stackPosition = misplaced_repair.stackPosition;
        repair.bufferPosition = 2;
        repair.numDeletions = misplaced_repair.numDeletions;
        repair.distance = misplaced_repair.distance;
        repair.recoveryOnNextStack = misplaced_repair.recoveryOnNextStack;
      }
    }
    // If the successful recovery was on next_stack, update: stack,
    // buffer, location_stack and last_index.
    if (repair.recoveryOnNextStack) {
      stateStackTop = nextStackTop;
      ArrayList.copy(nextStack, 0, stateStack, 0, stateStackTop + 1);
      buffer[2] = error_token;
      buffer[1] = tokStream.getPrevious(buffer[2]);
      buffer[0] = tokStream.getPrevious(buffer[1]);
      for (var k = 3; k < BUFF_UBOUND; k++) {
        buffer[k] = tokStream.getNext(buffer[k - 1]);
      }
      buffer[BUFF_UBOUND] = tokStream.badToken(); // elmt not available
      locationStack[nextStackTop] = buffer[2];
      last_index = next_last_index;
    }
    // Next, try scope recoveries after deletion of one, two, three,
    // four ... buffer_position tokens from the input stream.
    if (repair.code == SECONDARY_CODE || repair.code == DELETION_CODE) {
      final scope_repair = PrimaryRepairInfo();
      for (scope_repair.bufferPosition = 2;
      scope_repair.bufferPosition <= repair.bufferPosition &&
          repair.code != SCOPE_CODE;
      scope_repair.bufferPosition++) {
        scopeTrial(scope_repair, stateStack, stateStackTop);
        final j = scope_repair.distance == MAX_DISTANCE
            ? last_index
            : scope_repair.distance;
        final k = scope_repair.bufferPosition - 1;
        if ((scope_repair.distance - k) > MIN_DISTANCE &&
            (j - k) > (repair.distance - repair.numDeletions)) {
          final i = scopeIndex[scopeStackTop]; // upper bound
          repair.code = SCOPE_CODE;
          repair.symbol = scopeLhs(i) + NT_OFFSET;
          repair.stackPosition = stateStackTop;
          repair.bufferPosition = scope_repair.bufferPosition;
        }
      }
    }
    // If a successful repair was not found, quit!  Otherwise, issue
    // diagnosis and adjust configuration...
    final candidate = RepairCandidate();
    if (repair.code == 0) return candidate;
    secondaryDiagnosis(repair);
    // Update buffer based on number of elements that are deleted.
    switch (repair.code) {
      case MISPLACED_CODE:
        candidate.location = buffer[2];
        candidate.symbol = tokStream.getKind(buffer[2]);
        tokStream.reset(tokStream.getNext(buffer[2]));
        break;
      case DELETION_CODE:
        candidate.location = buffer[repair.bufferPosition];
        candidate.symbol = tokStream.getKind(buffer[repair.bufferPosition]);
        tokStream.reset(tokStream.getNext(buffer[repair.bufferPosition]));
        break;
      default: // SCOPE_CODE || SECONDARY_CODE
        candidate.symbol = repair.symbol;
        candidate.location = buffer[repair.bufferPosition];
        tokStream.reset(buffer[repair.bufferPosition]);
        break;
    }
    return candidate;
  }

  // This bool function checks whether or not a given
  // configuration yields a better misplacement recovery than
  // the best misplacement recovery computed previously.
  void misplacementRecovery(final SecondaryRepairInfo repair, final List<int> stack,
      final int stack_top, final int last_index, final bool stack_flag) {
    var previous_loc = buffer[2], stack_deletions = 0;
    for (var top = stack_top - 1; top >= 0; top--) {
      if (locationStack[top] < previous_loc) stack_deletions++;
      previous_loc = locationStack[top];
      final parse_distance =
      parseCheck(stack, top, tokStream.getKind(buffer[2]), 3),
          j = parse_distance == MAX_DISTANCE ? last_index : parse_distance;
      if ((parse_distance > MIN_DISTANCE) &&
          (j - stack_deletions) > (repair.distance - repair.numDeletions)) {
        repair.stackPosition = top;
        repair.distance = j;
        repair.numDeletions = stack_deletions;
        repair.recoveryOnNextStack = stack_flag;
      }
    }
    return;
  }

  // This function checks whether or not a given
  // configuration yields a better secondary recovery than the
  // best misplacement recovery computed previously.
  void secondaryRecovery(final SecondaryRepairInfo repair, final List<int> stack,
      final int stack_top, final int last_index, final bool stack_flag) {
    var previous_loc = buffer[2], stack_deletions = 0;
    for (var top = stack_top;
    top >= 0 && repair.numDeletions >= stack_deletions;
    top--) {
      if (locationStack[top] < previous_loc) stack_deletions++;
      previous_loc = locationStack[top];
      for (var i = 2;
      i <= (last_index - MIN_DISTANCE + 1) &&
          (repair.numDeletions >= (stack_deletions + i - 1));
      i++) {
        var parse_distance =
        parseCheck(stack, top, tokStream.getKind(buffer[i]), i + 1),
            j = parse_distance == MAX_DISTANCE ? last_index : parse_distance;
        if ((parse_distance - i + 1) > MIN_DISTANCE) {
          final k = stack_deletions + i - 1;
          if ((k < repair.numDeletions) ||
              (j - k) > (repair.distance - repair.numDeletions) ||
              ((repair.code == SECONDARY_CODE) &&
                  (j - k) == (repair.distance - repair.numDeletions))) {
            repair.code = DELETION_CODE;
            repair.distance = j;
            repair.stackPosition = top;
            repair.bufferPosition = i;
            repair.numDeletions = k;
            repair.recoveryOnNextStack = stack_flag;
          }
        }
        for (var l = nasi(stack[top]); l >= 0 && nasr(l) != 0; l++) {
          final symbol = nasr(l) + NT_OFFSET;
          parse_distance = parseCheck(stack, top, symbol, i);
          j = parse_distance == MAX_DISTANCE ? last_index : parse_distance;
          if ((parse_distance - i + 1) > MIN_DISTANCE) {
            final k = stack_deletions + i - 1;
            if (k < repair.numDeletions ||
                (j - k) > (repair.distance - repair.numDeletions)) {
              repair.code = SECONDARY_CODE;
              repair.symbol = symbol;
              repair.distance = j;
              repair.stackPosition = top;
              repair.bufferPosition = i;
              repair.numDeletions = k;
              repair.recoveryOnNextStack = stack_flag;
            }
          }
        }
      }
    }
    return;
  }

  // This procedure is invoked to issue a secondary diagnosis and
  // adjust the input buffer.  The recovery in question is either
  // an automatic scope recovery, a manual scope recovery, a
  // secondary substitution or a secondary deletion.
  void secondaryDiagnosis(final SecondaryRepairInfo repair) {
    switch (repair.code) {
      case SCOPE_CODE:
        {
          if (repair.stackPosition < stateStackTop) {
            emitError(DELETION_CODE, terminalIndex(ERROR_SYMBOL),
                locationStack[repair.stackPosition], buffer[1]);
          }
          for (var i = 0; i < scopeStackTop; i++) {
            emitError(
                SCOPE_CODE,
                -scopeIndex[i],
                locationStack[scopePosition[i]],
                buffer[1],
                nonterminalIndex(scopeLhs(scopeIndex[i])));
          }
          repair.symbol = scopeLhs(scopeIndex[scopeStackTop]) + NT_OFFSET;
          stateStackTop = scopePosition[scopeStackTop];
          emitError(
              SCOPE_CODE,
              -scopeIndex[scopeStackTop],
              locationStack[scopePosition[scopeStackTop]],
              buffer[1],
              getNtermIndex(stateStack[stateStackTop], repair.symbol,
                  repair.bufferPosition));
          break;
        }
      default:
        emitError(
            repair.code,
            repair.code == SECONDARY_CODE
                ? getNtermIndex(stateStack[repair.stackPosition], repair.symbol,
                repair.bufferPosition)
                : terminalIndex(ERROR_SYMBOL),
            locationStack[repair.stackPosition],
            buffer[repair.bufferPosition - 1]);
        stateStackTop = repair.stackPosition;
    }
    return;
  }

  // This method is invoked by an LPG PARSER or a semantic
  // routine to process an error message.
  void emitError(int msg_code, final int name_index, final int left_token, final int right_token,
      [final int scope_name_index = 0]) {
    var token_name =
    name_index >= 0 && !(name(name_index).toUpperCase() == ('ERROR'))
        ? '\"' + name(name_index) + '\"'
        : '';
    if (msg_code == INVALID_CODE) {
      msg_code = token_name.isEmpty ? INVALID_CODE : INVALID_TOKEN_CODE;
    }
    if (msg_code == SCOPE_CODE) {
      token_name = '\"';
      for (var i = scopeSuffix(-name_index); scopeRhs(i) != 0; i++) {
        if (!isNullable(scopeRhs(i))) {
          final symbol_index = scopeRhs(i) > NT_OFFSET
              ? nonterminalIndex(scopeRhs(i) - NT_OFFSET)
              : terminalIndex(scopeRhs(i));
          if (name(symbol_index).isNotEmpty) {
            if (token_name.length > 1) {
              token_name += ' ';
            } // add a space separator
            token_name += name(symbol_index);
          }
        }
      }
      token_name += '\"';
    }
    tokStream.reportError(msg_code, left_token, right_token, token_name);
    return;
  }

  // keep looking ahead until we compute a valid action
  int lookahead(int act, final int token) {
    act = prs.lookAhead(act - LA_STATE_OFFSET, tokStream.getKind(token));
    return act > LA_STATE_OFFSET
        ? lookahead(act, tokStream.getNext(token))
        : act;
  }

  // Compute the next action defined on act and sym. If this
  // action requires more lookahead, these lookahead symbols
  // are in the token stream beginning at the next token that
  // is yielded by peek().
  int tAction(int act, final int sym) {
    act = prs.tAction(act, sym);
    return act > LA_STATE_OFFSET ? lookahead(act, tokStream.peek()) : act;
  }
}

// LexStream contains an array of characters as the input stream to be parsed.
// There are methods to retrieve and classify characters.
// The lexparser "token" is implemented simply as the index of the next character in the array.
// The user must subclass LexStreamBase and implement the abstract methods: getKind.
class LexStream implements ILexStream {
  static const int DEFAULT_TAB = 1;

  int index = -1;
  int streamLength = 0;
  String inputChars = '';
  String fileName = '';
  late IntSegmentedTuple lineOffsets;
  int tab = DEFAULT_TAB;
  IPrsStream? prsStream;

  LexStream(final String fileName,
      [final String? inputChars,
        this.tab = DEFAULT_TAB,
        final IntSegmentedTuple? lineOffsets]) {
    this.lineOffsets = IntSegmentedTuple(12);
    setLineOffset(-1);
    initialize(fileName, inputChars, lineOffsets);
  }

  static Future<String> fromStringStream(final Stream<String> stream) async {
    final data = StringBuffer();
    await stream.listen((final buf) {
      data.write(buf);
    }).asFuture<dynamic>();
    return data.toString();
  }

  static Future<String> fromStream(final Stream<List<int>> stream,
      {final Encoding encoding = systemEncoding}) {
    final data = stream.transform(encoding.decoder);
    return fromStringStream(data);
  }

  static Future<String> fromPath(final String path,
      {final Encoding encoding = systemEncoding}) {
    return fromStream(File(path).openRead());
  }

  void initialize(
      final String fileName, String? inputChars, final IntSegmentedTuple? lineOffsets) {
    inputChars ??= File(fileName).readAsStringSync(encoding: systemEncoding);
    if (inputChars.isEmpty) {
      return;
    }
    setInputChars(inputChars);
    setStreamLength(inputChars.length);
    setFileName(fileName);
    if (lineOffsets != null) {
      this.lineOffsets = lineOffsets;
    } else {
      computeLineOffsets();
    }
  }

  void computeLineOffsets() {
    lineOffsets.reset();
    setLineOffset(-1);
    for (var i = 0; i < inputChars.length; i++) {
      if (inputChars.codeUnitAt(i) == 0x0A) {
        setLineOffset(i);
      }
    }
  }

  void setInputChars(final String inputChars) {
    this.inputChars = inputChars;
    index = -1; // reset the start index to the beginning of the input
  }

  String getInputChars() {
    return inputChars;
  }

  void setFileName(final String fileName) {
    this.fileName = fileName;
  }

  @override
  String getFileName() {
    return fileName;
  }

  void setLineOffsets(final IntSegmentedTuple lineOffsets) {
    this.lineOffsets = lineOffsets;
  }

  IntSegmentedTuple getLineOffsets() {
    return lineOffsets;
  }

  void setTab(final int tab) {
    this.tab = tab;
  }

  int getTab() {
    return tab;
  }

  void setStreamIndex(final int index) {
    this.index = index;
  }

  int getStreamIndex() {
    return index;
  }

  void setStreamLength(final int streamLength) {
    this.streamLength = streamLength;
  }

  @override
  int getStreamLength() {
    return streamLength;
  }

  void setLineOffset(final int i) {
    lineOffsets.add(i);
  }

  @override
  int getLineOffset(final int i) {
    return lineOffsets.get(i);
  }

  @override
  void setPrsStream(final IPrsStream prsStream) {
    prsStream.setLexStream(this);
    this.prsStream = prsStream;
  }

  @override
  IPrsStream? getIPrsStream() {
    return prsStream;
  }

  @override
  List<String> orderedExportedSymbols() {
    return [];
  }

  @override
  String getCharValue(final int i) {
    return inputChars[i];
  }

  @override
  int getIntValue(final int i) {
    return inputChars.codeUnitAt(i);
  }

  int getLine2() {
    return getLineCount();
  }

  @override
  int getLineCount() {
    return lineOffsets.size() - 1;
  }

  @override
  int getLineNumberOfCharAt(final int i) {
    final index = lineOffsets.binarySearch(i);
    return index < 0
        ? -index
        : index == 0
        ? 1
        : index;
  }

  @override
  int getColumnOfCharAt(final int i) {
    var lineNo = getLineNumberOfCharAt(i), start = lineOffsets.get(lineNo - 1);
    if (start + 1 >= streamLength) return 1;
    for (var k = start + 1; k < i; k++) {
      if (inputChars[k] == '\t') {
        final offset = (k - start) - 1;
        start -= (tab - 1) - offset % tab;
      }
    }
    return i - start;
  }

  // Methods that implement the TokenStream Interface.
  // Note that this function updates the lineOffsets table
  // as a side-effect when the next character is a line feed.
  // If this is not the expected behavior then this function should
  // be overridden.
  int getToken2() {
    return index = getNext(index);
  }

  @override
  int getToken([final int? end_token]) {
    if (null == end_token) {
      return getToken2();
    }
    return index = index < end_token ? getNext(index) : streamLength;
  }

  @override
  int getKind(final int i) {
    return 0;
  }

  int next(final int i) {
    return getNext(i);
  }

  @override
  int getNext(int i) {
    return ++i < streamLength ? i : streamLength;
  }

  int previous(final int i) {
    return getPrevious(i);
  }

  @override
  int getPrevious(final int i) {
    return i <= 0 ? 0 : i - 1;
  }

  @override
  String getName(final int i) {
    return i >= getStreamLength() ? '' : '' + getCharValue(i);
  }

  @override
  int peek() {
    return getNext(index);
  }

  @override
  void reset([final int? i]) {
    if (null == i) {
      reset1();
      return;
    }
    index = i - 1;
  }

  void reset1() {
    index = -1;
  }

  @override
  int badToken() {
    return 0;
  }

  @override
  int getLine(final int i) {
    return getLineNumberOfCharAt(i);
  }

  @override
  int getColumn(final int i) {
    return getColumnOfCharAt(i);
  }

  @override
  int getEndLine(final int i) {
    return getLine(i);
  }

  @override
  int getEndColumn(final int i) {
    return getColumnOfCharAt(i);
  }

  @override
  bool afterEol(final int i) {
    return i < 1
        ? true
        : getLineNumberOfCharAt(i - 1) < getLineNumberOfCharAt(i);
  }

  int getFirstErrorToken(final int i) {
    return getFirstRealToken(i);
  }

  @override
  int getFirstRealToken(final int i) {
    return i;
  }

  int getLastErrorToken(final int i) {
    return getLastRealToken(i);
  }

  @override
  int getLastRealToken(final int i) {
    return i;
  }

  // Here is where we report errors.  The default method is simply to print the error message to the console.
  // However, the user may supply an error message handler to process error messages.  To support that
  // a message handler interface is provided that has a single method handleMessage().  The user has his
  // error message handler class implement the IMessageHandler interface and provides an object of this type
  // to the runtime using the setMessageHandler(errorMsg) method. If the message handler object is set,
  // the reportError methods will invoke its handleMessage() method.
  IMessageHandler? errMsg; // this is the error message handler object

  @override
  void setMessageHandler(final IMessageHandler errMsg) {
    this.errMsg = errMsg;
  }

  @override
  IMessageHandler? getMessageHandler() {
    return errMsg;
  }

  @override
  void makeToken(final int startLoc, final int endLoc, final int kind) {
    if (prsStream != null) {
      prsStream!.makeToken(startLoc, endLoc, kind);
    } else {
      reportLexicalError(startLoc, endLoc);
    } // make it a lexical error
  }

  /// See IMessageHandler for a description of the List<int> return value.
  @override
  Location getLocation(final int left_loc, final int right_loc) {
    final length = (right_loc < streamLength ? right_loc : streamLength - 1) -
        left_loc +
        1;
    return Location(
        left_loc,
        length,
        getLineNumberOfCharAt(left_loc),
        getColumnOfCharAt(left_loc),
        getLineNumberOfCharAt(right_loc),
        getColumnOfCharAt(right_loc));
  }

  @override
  void reportError(final int errorCode, final int leftToken, final int rightToken, final dynamic errorInfo,
      [final int errorToken = 0]) {
    // TODO: implement reportError
  }

  @override
  void reportLexicalError(final int left_loc, final int right_loc,
      [int? errorCode,
        final int? error_left_loc_arg,
        final int? error_right_loc_arg,
        final List<String>? errorInfo_arg]) {
    // TODO: implement reportLexicalError
    var error_left_loc = 0;
    if (error_left_loc_arg != null) {
      error_left_loc = error_left_loc_arg;
    }
    var error_right_loc = 0;
    if (error_right_loc_arg != null) {
      error_right_loc = error_right_loc_arg;
    }
    var errorInfo = <String>[];
    if (errorInfo_arg != null) {
      errorInfo = errorInfo_arg;
    }
    if (null == errorCode) {
      errorCode = right_loc >= streamLength
          ? EOF_CODE
          : left_loc == right_loc
          ? LEX_ERROR_CODE
          : INVALID_TOKEN_CODE;
      final tokenText = errorCode == EOF_CODE
          ? 'End-of-file '
          : errorCode == INVALID_TOKEN_CODE
          ? '\"' + inputChars.substring(left_loc, right_loc + 1) + '\" '
          : '\"' + getCharValue(left_loc) + '\" ';
      error_left_loc = 0;
      error_right_loc = 0;
      errorInfo = [tokenText];
    }
    if (null == errMsg) {
      final locationInfo = getFileName() +
          ':' +
          getLineNumberOfCharAt(left_loc).toString() +
          ':' +
          getColumnOfCharAt(left_loc).toString() +
          ':' +
          getLineNumberOfCharAt(right_loc).toString() +
          ':' +
          getColumnOfCharAt(right_loc).toString() +
          ':' +
          error_left_loc.toString() +
          ':' +
          error_right_loc.toString() +
          ':' +
          errorCode.toString() +
          ': ';
      stdout.write('****Error: ' + locationInfo);
      for (var i = 0; i < errorInfo.length; i++) {
        stdout.write(errorInfo[i] + ' ');
      }
      stdout.writeln(errorMsgText[errorCode]);
    } else {
      errMsg!.handleMessage(
          errorCode,
          getLocation(left_loc, right_loc),
          getLocation(error_left_loc, error_right_loc),
          getFileName(),
          errorInfo);
    }
  }

  @override
  String toStringWithOffset(final int startOffset, final int endOffset) {
    final length = endOffset - startOffset + 1;
    return endOffset >= inputChars.length
        ? '\$EOF'
        : length <= 0
        ? ''
        : inputChars.substring(startOffset, endOffset + 1);
  }
}

// This Tuple class can be used to construct a dynamic
// array of integers. The space for the array is allocated in
// blocks of size 2**LOG_BLKSIZE. In declaring a tuple the user
// may specify an estimate of how many elements he expects.
// Based on that estimate, suitable values will be calculated
// for log_blksize and base_increment. If these estimates are
// found to be off later, more space will be allocated.
class IntSegmentedTuple {
  int top = 0;
  int _size = 0;

  int log_blksize = 3;
  int base_size = 4;

  late List<List<int>> base;

  // Allocate another block of storage for the dynamic array.
  void allocateMoreSpace() {
    // The variable size always indicates the maximum number of
    // elements that has been allocated for the array.
    // Initially, it is set to 0 to indicate that the array is empty.
    // The pool of available elements is divided into segments of size
    // 2**log_blksize each. Each segment is pointed to by a slot in
    // the array base.
    // By dividing size by the size of the segment we obtain the
    // index for the next segment in base. If base is full, it is
    // reallocated.
    final k = _size >> log_blksize; /* which segment? */
    // If the base is overflowed, reallocate it and initialize the new
    // elements to NULL.
    // Otherwise, allocate a new segment and place its adjusted address
    // in base[k]. The adjustment allows us to index the segment directly,
    // instead of having to perform a subtraction for each reference.
    // See operator[] below.
    if (k == base_size) {
      base_size *= 2;
      ArrayList.copy(base, 0, base = List.filled(base_size, []), 0, k);
    }
    base[k] = List.filled(1 << log_blksize, 0);
    // Finally, we update SIZE.
    _size += 1 << log_blksize;
    return;
  }

  // This function is invoked with an integer argument n. It ensures
  // that enough space is allocated for n elements in the dynamic array.
  // I.e., that the array will be indexable in the range  (0..n-1)
  // Note that this function can be used as a garbage collector.  When
  // invoked with no argument(or 0), it frees up all dynamic space that
  // was allocated for the array.

  void resize(final int? arg) {
    int n;
    if (null == arg) {
      n = 0;
    } else {
      n = arg;
    }
    // If array did not previously contain enough space, allocate
    // the necessary additional space. Otherwise, if the array had
    // more blocks than are needed, release the extra blocks.
    if (n > _size) {
      do {
        allocateMoreSpace();
      } while (n > _size);
    }
    top = n;
  }

  // This function is used to reset the size of a dynamic array without
  // allocating or deallocting space. It may be invoked with an integer
  // argument n which indicates the new size or with no argument which
  // indicates that the size should be reset to 0.
  void reset([final int n = 0]) {
    top = n;
  }

  // Return size of the dynamic array.
  int size() {
    return top;
  }

  // Can the tuple be indexed with i?
  bool outOfRange(final int i) {
    return i < 0 || i >= top;
  }

  // Return a reference to the ith element of the dynamic array.
  // Note that no check is made here to ensure that 0 <= i < top.
  // Such a check might be useful for debugging and a range exception
  // should be thrown if it yields true.
  int get(final int i) {
    return base[i >> log_blksize][i % (1 << log_blksize)];
  }

  // Insert an element in the dynamic array at the location indicated.
  void set(final int i, final int element) {
    base[i >> log_blksize][i % (1 << log_blksize)] = element;
  }

  // Add an element to the dynamic array and return the top index.
  int NextIndex() {
    final i = top++;
    if (i == _size) allocateMoreSpace();
    return i;
  }

  // Add an element to the dynamic array and return a reference to
  // that new element.
  void add(final int element) {
    final i = NextIndex();
    base[i >> log_blksize][i % (1 << log_blksize)] = element;
  }

  // If array is sorted, this function will find the index location
  // of a given element if it is contained in the array. Otherwise, it
  // will return the negation of the index of the element prior to
  // which the new element would be inserted in the array.
  int binarySearch(final int element) {
    var low = 0;
    var high = top;
    while (high > low) {
      final mid = ((high + low) / 2).floor();
      final mid_element = get(mid);
      if (element == mid_element) {
        return mid;
      } else if (element < mid_element) {
        high = mid;
      } else {
        low = mid + 1;
      }
    }
    return -low;
  }

  // Constructor of a Tuple
  IntSegmentedTuple([final int? log_blksize_, final int? base_size_]) {
    if (log_blksize_ != null) log_blksize = log_blksize_;
    if (base_size_ != null) base_size = base_size_ <= 0 ? 4 : base_size_;
    base = List.filled(base_size, []);
  }
}

// PrsStream holds an arraylist of tokens "lexed" from the input stream.
class PrsStream implements IPrsStream {
  ILexStream iLexStream = EscapeStrictPropertyInitializationLexStream();
  List<int> kindMap = [];
  ArrayList<dynamic> tokens = ArrayList<dynamic>();
  ArrayList<dynamic> adjuncts = ArrayList<dynamic>();
  int index = 0;
  int len = 0;

  PrsStream([final ILexStream? iLexStream]) {
    if (iLexStream != null) {
      this.iLexStream = iLexStream;
      iLexStream.setPrsStream(this);
      resetTokenStream();
    }
  }

  @override
  List<String> orderedExportedSymbols() {
    return [];
  }

  @override
  void remapTerminalSymbols(
      final List<String>? ordered_parser_symbols, final int eof_symbol) {
    // SMS 12 Feb 2008
    // lexStream might be null, maybe only erroneously, but it has happened
    if (iLexStream is EscapeStrictPropertyInitializationLexStream) {
      throw NullPointerException(
          'PrsStream.remapTerminalSymbols(..):  lexStream is null');
    }
    final ordered_lexer_symbols = iLexStream.orderedExportedSymbols();
    if (ordered_lexer_symbols == null) {
      throw NullExportedSymbolsException();
    }
    if (ordered_parser_symbols == null) {
      throw const NullTerminalSymbolsException();
    }
    final unimplemented_symbols = ArrayList<dynamic>();
    if (ordered_lexer_symbols != ordered_parser_symbols) {
      kindMap = List.filled(ordered_lexer_symbols.length, 0);
      final terminal_map = <String, int>{};
      for (var i = 0; i < ordered_lexer_symbols.length; i++) {
        terminal_map[ordered_lexer_symbols[i]] = i;
      }
      for (var i = 0; i < ordered_parser_symbols.length; i++) {
        if (terminal_map.containsValue(ordered_parser_symbols[i])) {
          final k = terminal_map[ordered_parser_symbols[i]];
          kindMap[k!] = i;
        } else {
          if (i == eof_symbol) {
            throw const UndefinedEofSymbolException();
          }
          unimplemented_symbols.add(i);
        }
      }
    }
    if (unimplemented_symbols.size() > 0) {
      throw UnimplementedTerminalsException(unimplemented_symbols);
    }
  }

  @override
  int mapKind(final int kind) {
    return kindMap.isEmpty ? kind : kindMap[kind];
  }

  @override
  void resetTokenStream() {
    tokens = ArrayList<dynamic>();
    index = 0;
    adjuncts = ArrayList<dynamic>();
  }

  @override
  void setLexStream(final ILexStream lexStream) {
    iLexStream = lexStream;
    resetTokenStream();
  }

  void resetLexStream(final ILexStream? lexStream) {
    if (lexStream != null) {
      lexStream.setPrsStream(this);
      iLexStream = lexStream;
    }
  }

  @override
  void makeToken(final int startLoc, final int endLoc, final int kind) {
    final token = Token(startLoc, endLoc, mapKind(kind), this);
    token.setTokenIndex(tokens.size());
    tokens.add(token);
    token.setAdjunctIndex(adjuncts.size());
  }

  @override
  void removeLastToken() {
    final last_index = tokens.size() - 1;
    final token = tokens.get(last_index) as Token;
    var adjuncts_size = adjuncts.size();
    while (adjuncts_size > token.getAdjunctIndex()) {
      adjuncts.remove(--adjuncts_size);
    }
    tokens.remove(last_index);
  }

  @override
  int makeErrorToken(final int firsttok, final int lasttok, final int errortok, final int kind) {
    final index = tokens.size(); // the next index
    // Note that when creating an error token, we do not remap its kind.
    // Since this is not a lexical operation, it is the responsibility of
    // the calling program (a parser driver) to pass to us the proper kind
    // that it wants for an error token.
    final token = ErrorToken(
        getIToken(firsttok),
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
  void addToken(final IToken token) {
    token.setTokenIndex(tokens.size());
    tokens.add(token);
    token.setAdjunctIndex(adjuncts.size());
  }

  @override
  void makeAdjunct(final int startLoc, final int endLoc, final int kind) {
    final token_index = tokens.size() - 1; // index of last token processed
    final adjunct = Adjunct(startLoc, endLoc, mapKind(kind), this);
    adjunct.setAdjunctIndex(adjuncts.size());
    adjunct.setTokenIndex(token_index);
    adjuncts.add(adjunct);
  }

  @override
  void addAdjunct(final IToken adjunct) {
    final token_index = tokens.size() - 1; // index of last token processed
    adjunct.setTokenIndex(token_index);
    adjunct.setAdjunctIndex(adjuncts.size());
    adjuncts.add(adjunct);
  }

  @override
  String getTokenText(final int i) {
    final t = tokens.get(i) as IToken;
    return t.toString();
  }

  @override
  int getStartOffset(final int i) {
    final t = tokens.get(i) as IToken;
    return t.getStartOffset();
  }

  @override
  int getEndOffset(final int i) {
    final t = tokens.get(i) as IToken;
    return t.getEndOffset();
  }

  @override
  int getTokenLength(final int i) {
    final t = tokens.get(i) as IToken;
    return t.getEndOffset() - t.getStartOffset() + 1;
  }

  @override
  int getLineNumberOfTokenAt(final int i) {
    final t = tokens.get(i) as IToken;
    return iLexStream.getLineNumberOfCharAt(t.getStartOffset());
  }

  @override
  int getEndLineNumberOfTokenAt(final int i) {
    final t = tokens.get(i) as IToken;
    return iLexStream.getLineNumberOfCharAt(t.getEndOffset());
  }

  @override
  int getColumnOfTokenAt(final int i) {
    final t = tokens.get(i) as IToken;
    return iLexStream.getColumnOfCharAt(t.getStartOffset());
  }

  @override
  int getEndColumnOfTokenAt(final int i) {
    final t = tokens.get(i) as IToken;
    return iLexStream.getColumnOfCharAt(t.getEndOffset());
  }

  @override
  List<String> orderedTerminalSymbols() {
    return [];
  }

  @override
  int getLineOffset(final int i) {
    return iLexStream.getLineOffset(i);
  }

  @override
  int getLineCount() {
    return iLexStream.getLineCount();
  }

  @override
  int getLineNumberOfCharAt(final int i) {
    return iLexStream.getLineNumberOfCharAt(i);
  }

  @override
  int getColumnOfCharAt(final int i) {
    return iLexStream.getColumnOfCharAt(i);
  }

  @override
  int getFirstErrorToken(final int i) {
    return getFirstRealToken(i);
  }

  @override
  int getFirstRealToken(int i) {
    while (i >= len) {
      i = (tokens.get(i) as ErrorToken).getFirstRealToken().getTokenIndex();
    }
    return i;
  }

  @override
  int getLastErrorToken(final int i) {
    return getLastRealToken(i);
  }

  @override
  int getLastRealToken(int i) {
    while (i >= len) {
      i = (tokens.get(i) as ErrorToken).getLastRealToken().getTokenIndex();
    }
    return i;
  }

  // TODO: should this function throw an exception instead of returning null?
  @override
  String getInputChars() {
    return iLexStream is LexStream
        ? (iLexStream as LexStream).getInputChars()
        : '';
  }

  // TODO: should this function throw an exception instead of returning null?
  @override
  List<int> getInputBytes() {
    return <int>[];
  }

  @override
  String toStringFromIndex(final int first_token, final int last_token) {
    return toStringFromToken(tokens.get(first_token) as IToken, tokens.get(last_token) as IToken);
  }

  @override
  String toStringFromToken(final IToken t1, final IToken t2) {
    return iLexStream.toStringWithOffset(
        t1.getStartOffset(), t2.getEndOffset());
  }

  @override
  int getSize() {
    return tokens.size();
  }

  void setSize() {
    len = tokens.size();
  }

  // This function returns the index of the token element
  // containing the offset specified. If such a token does
  // not exist, it returns the negation of the index of the
  // element immediately preceding the offset.
  @override
  int getTokenIndexAtCharacter(final int offset) {
    var low = 0, high = tokens.size();
    while (high > low) {
      final mid = ((high + low) / 2).floor();
      final mid_element = tokens.get(mid) as IToken;
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
  IToken? getTokenAtCharacter(final int offset) {
    final tokenIndex = getTokenIndexAtCharacter(offset);
    return (tokenIndex < 0) ? null : getTokenAt(tokenIndex);
  }

  @override
  IToken getTokenAt(final int i) {
    return tokens.get(i) as IToken;
  }

  @override
  IToken getIToken(final int i) {
    return tokens.get(i) as IToken;
  }

  @override
  ArrayList<dynamic> getTokens() {
    return tokens;
  }

  @override
  int getStreamIndex() {
    return index;
  }

  @override
  int getStreamLength() {
    return len;
  }

  @override
  void setStreamIndex(final int index) {
    this.index = index;
  }

  void setStreamLength2() {
    len = tokens.size();
  }

  @override
  void setStreamLength([final int? len]) {
    if (len == null) {
      setStreamLength2();
      return;
    }
    this.len = len;
  }

  @override
  ILexStream getILexStream() {
    return iLexStream;
  }

  ILexStream getLexStream() {
    return iLexStream;
  }

  @override
  void dumpTokens() {
    if (getSize() <= 2) return;
    stdout.write(' Kind \tOffset \tLen \tLine \tCol \tText\n');
    for (var i = 1; i < getSize() - 1; i++) {
      dumpToken(i);
    }
  }

  @override
  void dumpToken(final int i) {
    stdout.write(' (' + getKind(i).toString() + ')');
    stdout.write(' \t' + getStartOffset(i).toString());
    stdout.write(' \t' + getTokenLength(i).toString());
    stdout.write(' \t' + getLineNumberOfTokenAt(i).toString());
    stdout.write(' \t' + getColumnOfTokenAt(i).toString());
    stdout.write(' \t' + getTokenText(i));
    stdout.write('\n');
  }

  List<IToken> getAdjunctsFromIndex(final int i) {
    final start_index = (tokens.get(i) as IToken).getAdjunctIndex(),
        end_index = i + 1 == tokens.size()
            ? adjuncts.size()
            : (tokens.get(getNext(i)) as IToken).getAdjunctIndex(),
        size = end_index - start_index;
    final slice = List<IToken?>.filled(size, null);
    for (var j = start_index, k = 0; j < end_index; j++, k++) {
      slice[k] = adjuncts.get(j) as IToken?;
    }
    final ret = <IToken>[];
    for (final item in slice) {
      if (null != item) {
        ret.add(item);
      }
    }
    return ret;
  }

  // Return an iterator for the adjuncts that follow token i.
  @override
  List<IToken> getFollowingAdjuncts(final int i) {
    return getAdjunctsFromIndex(i);
  }

  @override
  List<IToken> getPrecedingAdjuncts(final int i) {
    return getAdjunctsFromIndex(getPrevious(i));
  }

  @override
  ArrayList<dynamic> getAdjuncts() {
    return adjuncts;
  }

  // Methods that implement the TokenStream Interface
  int getToken2() {
    return getNext(index);
  }

  @override
  int getToken([final int? end_token]) {
    if (null == end_token) {
      return getToken2();
    }
    return index = index < end_token ? getNext(index) : len - 1;
  }

  @override
  int getKind(final int i) {
    final t = tokens.get(i) as IToken;
    return t.getKind();
  }

  @override
  int getNext(int i) {
    return ++i < len ? i : len - 1;
  }

  @override
  int getPrevious(final int i) {
    return i <= 0 ? 0 : i - 1;
  }

  @override
  String getName(final int i) {
    return getTokenText(i);
  }

  @override
  int peek() {
    return getNext(index);
  }

  void reset1() {
    index = 0;
  }

  void reset2(final int i) {
    index = getPrevious(i);
  }

  @override
  void reset([final int? i]) {
    if (null == i) {
      reset1();
    } else {
      reset2(i);
    }
  }

  @override
  int badToken() {
    return 0;
  }

  @override
  int getLine(final int i) {
    return getLineNumberOfTokenAt(i);
  }

  @override
  int getColumn(final int i) {
    return getColumnOfTokenAt(i);
  }

  @override
  int getEndLine(final int i) {
    return getEndLineNumberOfTokenAt(i);
  }

  @override
  int getEndColumn(final int i) {
    return getEndColumnOfTokenAt(i);
  }

  @override
  bool afterEol(final int i) {
    return i < 1
        ? true
        : getEndLineNumberOfTokenAt(i - 1) < getLineNumberOfTokenAt(i);
  }

  @override
  String getFileName() {
    return iLexStream.getFileName();
  }

  // Here is where we report errors.  The default method is simply to print the error message to the console.
  // However, the user may supply an error message handler to process error messages.  To support that
  // a message handler interface is provided that has a single method handleMessage().  The user has his
  // error message handler class implement the IMessageHandler interface and provides an object of this type
  // to the runtime using the setMessageHandler(errorMsg) method. If the message handler object is set,
  // the reportError methods will invoke its handleMessage() method.
  // IMessageHandler errMsg = null; // the error message handler object is declared in LexStream
  @override
  void setMessageHandler(final IMessageHandler errMsg) {
    iLexStream.setMessageHandler(errMsg);
  }

  @override
  IMessageHandler? getMessageHandler() {
    return iLexStream.getMessageHandler();
  }

  @override
  void reportError(final int errorCode, final int leftToken, final int rightToken, final dynamic errorInfo,
      [final int errorToken = 0]) {
    late List<String> tempInfo;
    if (errorInfo is String) {
      tempInfo = [errorInfo];
    } else if (errorInfo is List<String>) {
      tempInfo = errorInfo;
    } else {
      tempInfo = [];
    }
    iLexStream.reportLexicalError(
        getStartOffset(leftToken),
        getEndOffset(rightToken),
        errorCode,
        getStartOffset(errorToken),
        getEndOffset(errorToken),
        tempInfo);
  }
}

class Adjunct extends AbstractToken {
  Adjunct(final int startOffset, final int endOffset, final int kind, final IPrsStream? prsStream)
      : super(startOffset, endOffset, kind, prsStream);

  @override
  List<IToken> getFollowingAdjuncts() {
    return [];
  }

  @override
  List<IToken> getPrecedingAdjuncts() {
    return [];
  }
}

class BadParseException implements Exception {
  final int error_token;

  const BadParseException(this.error_token);
}

class BadParseSymFileException implements Exception {
  String? str;

  BadParseSymFileException([this.str]);

  @override
  String toString() {
    return str ?? 'BadParseSymFileException';
  }
}

class ConfigurationElement {
  ConfigurationElement? next;

  StateElement? last_element;
  int stack_top = 0, action_length = 0, conflict_index = 0, curtok = 0, act = 0;

  void retrieveStack(final List<int> stack) {
    var tail = last_element;
    for (var i = stack_top; i >= 0; i--) {
      if (tail == null) return;
      stack[i] = tail.number;
      tail = tail.parent;
    }
    return;
  }
}

class ConfigurationStack {
  static const int TABLE_SIZE = 1021; // 1021 is a prime

  List<ConfigurationElement?> table = List.filled(TABLE_SIZE, null);

  ObjectTuple configuration_stack = ObjectTuple(1 << 12);

  late StateElement state_root;

  int max_configuration_size = 0, stacks_size = 0, state_element_size = 0;

  late ParseTable prs;

  ConfigurationStack(this.prs) {
    state_element_size++;
    state_root = StateElement();
    state_root.parent = null;
    state_root.siblings = null;
    state_root.children = null;
    state_root.number = prs.getStartState();
  }

  StateElement makeStateList(
      StateElement parent, final List<int> stack, final int index, final int stack_top) {
    for (var i = index; i <= stack_top; i++) {
      state_element_size++;
      final state = StateElement();
      state.number = stack[i];
      state.parent = parent;
      state.children = null;
      state.siblings = null;
      parent.children = state;
      parent = state;
    }
    return parent;
  }

  StateElement findOrInsertStack(
      final StateElement root, final List<int> stack, final int index, final int stack_top) {
    final state_number = stack[index];
    for (StateElement? p = root; p != null; p = p.siblings) {
      if (p.number == state_number) {
        return index == stack_top
            ? p
            : p.children == null
            ? makeStateList(p, stack, index + 1, stack_top)
            : findOrInsertStack(p.children!, stack, index + 1, stack_top);
      }
    }
    state_element_size++;
    final node = StateElement();
    node.number = state_number;
    node.parent = root.parent;
    node.children = null;
    node.siblings = root.siblings;
    root.siblings = node;
    return index == stack_top
        ? node
        : makeStateList(node, stack, index + 1, stack_top);
  }

  bool findConfiguration(final List<int> stack, final int stack_top, final int curtok) {
    final last_element = findOrInsertStack(state_root, stack, 0, stack_top);
    final hash_address = curtok % TABLE_SIZE;
    for (var configuration = table[hash_address];
    configuration != null;
    configuration = configuration.next) {
      if (configuration.curtok == curtok &&
          last_element == configuration.last_element) return true;
    }
    return false;
  }

  void push(final List<int> stack, final int stack_top, final int conflict_index, final int curtok,
      final int action_length) {
    final configuration = ConfigurationElement();
    final hash_address = curtok % TABLE_SIZE;
    configuration.next = table[hash_address];
    table[hash_address] = configuration;
    max_configuration_size++; // keep track of number of configurations
    configuration.stack_top = stack_top;
    stacks_size +=
    stack_top + 1; // keep track of number of stack elements processed
    configuration.last_element =
        findOrInsertStack(state_root, stack, 0, stack_top);
    configuration.conflict_index = conflict_index;
    configuration.curtok = curtok;
    configuration.action_length = action_length;
    configuration_stack.add(configuration);
    return;
  }

  ConfigurationElement? pop() {
    if (configuration_stack.size() > 0) {
      final index = configuration_stack.size() - 1;
      final configuration =
      (configuration_stack.get(index) as ConfigurationElement?)!;
      configuration.act = prs.baseAction(configuration.conflict_index++);
      if (prs.baseAction(configuration.conflict_index) == 0) {
        configuration_stack.reset(index);
      }
      return configuration;
    }
    return null;
  }

  ConfigurationElement? top() {
    ConfigurationElement? configuration;
    if (configuration_stack.size() > 0) {
      final index = configuration_stack.size() - 1;
      configuration = (configuration_stack.get(index) as ConfigurationElement?)!;
      configuration.act = prs.baseAction(configuration.conflict_index);
    }
    return configuration;
  }

  int size() {
    return configuration_stack.size();
  }

  int maxConfigurationSize() {
    return max_configuration_size;
  }

  int numStateElements() {
    return state_element_size;
  }

  int stacksSize() {
    return stacks_size;
  }
}

class RepairCandidate {
  int symbol = 0;
  int location = 0;
}

class PrimaryRepairInfo {
  int distance = 0;
  int misspellIndex = 0;
  int code = 0;
  int bufferPosition = 0;
  int symbol = 0;

  PrimaryRepairInfo([final PrimaryRepairInfo? clone]) {
    if (null != clone) {
      copy(clone);
    }
  }

  void copy(final PrimaryRepairInfo c) {
    distance = c.distance;
    misspellIndex = c.misspellIndex;
    code = c.code;
    bufferPosition = c.bufferPosition;
    symbol = c.symbol;
  }
}

class SecondaryRepairInfo {
  int code = 0;
  int distance = 0;
  int bufferPosition = 0;
  int stackPosition = 0;
  int numDeletions = 0;
  int symbol = 0;

  bool recoveryOnNextStack = false;
}

class StateInfo {
  int state;
  int next;

  StateInfo(this.state, this.next);
}

class ErrorToken extends Token {
  late IToken firstToken, lastToken, errorToken;

  ErrorToken(this.firstToken, this.lastToken, final this.errorToken,
      final int startOffset, final int endOffset, final int kind)
      : super(startOffset, endOffset, kind, firstToken.getIPrsStream());

  IToken getFirstToken() {
    return getFirstRealToken();
  }

  IToken getFirstRealToken() {
    return firstToken;
  }

  IToken getLastToken() {
    return getLastRealToken();
  }

  IToken getLastRealToken() {
    return lastToken;
  }

  IToken getErrorToken() {
    return errorToken;
  }

  @override
  List<IToken> getPrecedingAdjuncts() {
    return firstToken.getPrecedingAdjuncts();
  }

  @override
  List<IToken> getFollowingAdjuncts() {
    return lastToken.getFollowingAdjuncts();
  }
}

/// Low-Level interface to act as recipient for error messages generated by a
/// parser/compiler.
class Location {
  int left_loc;
  int length;
  int start_line;
  int start_column;
  int end_line;
  int end_column;

  Location(this.left_loc, this.length, this.start_line, this.start_column,
      this.end_line, this.end_column);
}

// This Tuple class can be used to construct a dynamic
// array of integers. The space for the array is allocated in
// blocks of size 2**LOG_BLKSIZE. In declaring a tuple the user
// may specify an estimate of how many elements he expects.
// Based on that estimate, suitable values will be calculated
// for log_blksize and base_increment. If these estimates are
// found to be off later, more space will be allocated.
class IntTuple {
  late List<int> array;
  int top = 0;

  // This function is used to reset the size of a dynamic array without
  // allocating or deallocting space. It may be invoked with an integer
  // argument n which indicates the new size or with no argument which
  // indicates that the size should be reset to 0.

  void reset([final int n = 0]) {
    top = n;
  }

  // Return size of the dynamic array.
  int size() {
    return top;
  }

  int capacity() {
    return array.length;
  }

  // Return a reference to the ith element of the dynamic array.
  // Note that no check is made here to ensure that 0 <= i < top.
  // Such a check might be useful for debugging and a range exception
  // should be thrown if it yields true.
  int get(final int i) {
    return array[i];
  }

  // Insert an element in the dynamic array at the location indicated.
  void set(final int i, final int element) {
    array[i] = element;
  }

  // Add an element to the dynamic array and return the top index.
  int nextIndex() {
    final i = top++;
    if (i >= array.length) {
      ArrayList.copy(array, 0, array = List.filled(i * 2, 0), 0, i);
    }
    return i;
  }

  // Add an element to the dynamic array and return a reference to
  // that new element.
  void add(final int element) {
    final i = nextIndex();
    array[i] = element;
  }

  // Constructor of a Tuple
  IntTuple([final int estimate = 10]) {
    array = List.filled(estimate, 0);
  }
}

class MismatchedInputCharsException implements Exception {
  final String? str;

  const MismatchedInputCharsException(final String this.str);

  @override
  String toString() {
    return str ?? 'MismatchedInputCharsException';
  }
}

class NotBacktrackParseTableException implements Exception {
  final String? str;

  const NotBacktrackParseTableException([final this.str]);

  @override
  String toString() {
    return str ?? 'NotBacktrackParseTableException';
  }
}

class NotDeterministicParseTableException implements Exception {
  final String? str;

  const NotDeterministicParseTableException([this.str]);

  @override
  String toString() {
    return str ?? 'NotDeterministicParseTableException';
  }
}

class NullExportedSymbolsException implements Exception {
  String? str;

  NullExportedSymbolsException([final String? str_]) {
    str = str_;
  }

  @override
  String toString() {
    return str ?? 'NullExportedSymbolsException';
  }
}

class NullPointerException implements Exception {
  String? str;

  NullPointerException([final String? str_]) {
    str = str_;
  }

  @override
  String toString() {
    return str ?? 'NullPointerException';
  }
}

class NullTerminalSymbolsException implements Exception {
  final String? str;

  const NullTerminalSymbolsException([final this.str]);

  @override
  String toString() {
    return str ?? 'NullTerminalSymbolsException';
  }
}

// This Tuple class can be used to construct a dynamic
// array of integers. The space for the array is allocated in
// blocks of size 2**LOG_BLKSIZE. In declaring a tuple the user
// may specify an estimate of how many elements he expects.
// Based on that estimate, suitable values will be calculated
// for log_blksize and base_increment. If these estimates are
// found to be off later, more space will be allocated.
class ObjectTuple {
  late List<Object?> array;
  int top = 0;

  // This function is used to reset the size of a dynamic array without
  // allocating or deallocating space. It may be invoked with an integer
  // argument n which indicates the new size or with no argument which
  // indicates that the size should be reset to 0.
  // void reset() { reset(0); }
  void reset([final int n = 0]) {
    top = n;
  }

  // Return size of the dynamic array.
  int size() {
    return top;
  }

  // Return a reference to the ith element of the dynamic array.
  // Note that no check is made here to ensure that 0 <= i < top.
  // Such a check might be useful for debugging and a range exception
  // should be thrown if it yields true.
  Object? get(final int i) {
    return array[i];
  }

  // Insert an element in the dynamic array at the location indicated.
  void set(final int i, final Object element) {
    array[i] = element;
  }

  // Add an element to the dynamic array and return the top index.
  int nextIndex() {
    final i = top++;
    if (i >= array.length) {
      ArrayList.copy(
          array, 0, array = List.filled(i * 2, null, growable: false), 0, i);
    }
    return i;
  }

  // Add an element to the dynamic array and return a reference to
  // that new element.
  void add(final Object element) {
    final i = nextIndex();
    array[i] = element;
  }

  // Constructor of a Tuple
  ObjectTuple([final int estimate = 10]) {
    array = List<Object?>.filled(estimate, null, growable: false);
  }
}

class EscapeStrictPropertyInitializationLexStream implements ILexStream {
  @override
  bool afterEol(final int i) {
    // TODO: implement afterEol
    throw UnimplementedError();
  }

  @override
  int badToken() {
    // TODO: implement badToken
    throw UnimplementedError();
  }

  @override
  String getCharValue(final int i) {
    // TODO: implement getCharValue
    throw UnimplementedError();
  }

  @override
  int getColumn(final int i) {
    // TODO: implement getColumn
    throw UnimplementedError();
  }

  @override
  int getColumnOfCharAt(final int i) {
    // TODO: implement getColumnOfCharAt
    throw UnimplementedError();
  }

  @override
  int getEndColumn(final int i) {
    // TODO: implement getEndColumn
    throw UnimplementedError();
  }

  @override
  int getEndLine(final int i) {
    // TODO: implement getEndLine
    throw UnimplementedError();
  }

  @override
  String getFileName() {
    // TODO: implement getFileName
    throw UnimplementedError();
  }

  @override
  int getFirstRealToken(final int i) {
    // TODO: implement getFirstRealToken
    throw UnimplementedError();
  }

  @override
  IPrsStream getIPrsStream() {
    // TODO: implement getIPrsStream
    throw UnimplementedError();
  }

  @override
  int getIntValue(final int i) {
    // TODO: implement getIntValue
    throw UnimplementedError();
  }

  @override
  int getKind(final int i) {
    // TODO: implement getKind
    throw UnimplementedError();
  }

  @override
  int getLastRealToken(final int i) {
    // TODO: implement getLastRealToken
    throw UnimplementedError();
  }

  @override
  int getLine(final int i) {
    // TODO: implement getLine
    throw UnimplementedError();
  }

  @override
  int getLineCount() {
    // TODO: implement getLineCount
    throw UnimplementedError();
  }

  @override
  int getLineNumberOfCharAt(final int i) {
    // TODO: implement getLineNumberOfCharAt
    throw UnimplementedError();
  }

  @override
  int getLineOffset(final int i) {
    // TODO: implement getLineOffset
    throw UnimplementedError();
  }

  @override
  Location getLocation(final int left_loc, final int right_loc) {
    // TODO: implement getLocation
    throw UnimplementedError();
  }

  @override
  IMessageHandler getMessageHandler() {
    // TODO: implement getMessageHandler
    throw UnimplementedError();
  }

  @override
  String getName(final int i) {
    // TODO: implement getName
    throw UnimplementedError();
  }

  @override
  int getNext(final int i) {
    // TODO: implement getNext
    throw UnimplementedError();
  }

  @override
  int getPrevious(final int i) {
    // TODO: implement getPrevious
    throw UnimplementedError();
  }

  IPrsStream getPrsStream() {
    // TODO: implement getPrsStream
    throw UnimplementedError();
  }

  @override
  int getStreamLength() {
    // TODO: implement getStreamLength
    throw UnimplementedError();
  }

  @override
  int getToken([final int? end_token]) {
    // TODO: implement getToken
    throw UnimplementedError();
  }

  @override
  void makeToken(final int startLoc, final int endLoc, final int kind) {
    // TODO: implement makeToken
  }

  @override
  List<String> orderedExportedSymbols() {
    // TODO: implement orderedExportedSymbols
    throw UnimplementedError();
  }

  @override
  int peek() {
    // TODO: implement peek
    throw UnimplementedError();
  }

  @override
  void reportError(final int errorCode, final int leftToken, final int rightToken, final dynamic errorInfo,
      [final int errorToken = 0]) {
    throw UnimplementedError();
  }

  @override
  void reportLexicalError(final int left_loc, final int right_loc,
      [final int? errorCode,
        final int? error_left_loc,
        final int? error_right_loc,
        final List<String>? errorInfo]) {
    throw UnimplementedError();
  }

  @override
  void reset([final int? i]) {
    throw UnimplementedError();
  }

  @override
  void setMessageHandler(final IMessageHandler errMsg) {
    throw UnimplementedError();
  }

  @override
  void setPrsStream(final IPrsStream stream) {
    throw UnimplementedError();
  }

  @override
  String toStringWithOffset(final int startOffset, final int endOffset) {
    // TODO: implement toStringWithOffset
    throw UnimplementedError();
  }
}

class Stacks {
  final int STACK_INCREMENT = 1024;
  int stateStackTop = 0;

  List<int> stateStack = [];
  List<int> locationStack = [];
  List<Object?> parseStack = [];

  // Given a rule of the form     A ::= x1 x2 ... xn     n > 0
  // the function GETTOKEN(i) yields the symbol xi, if xi is a terminal
  // or ti, if xi is a nonterminal that produced a string of the form
  // xi => ti w.
  int getToken(final int i) {
    return locationStack[stateStackTop + (i - 1)];
  }

  // Given a rule of the form     A ::= x1 x2 ... xn     n > 0
  // The function GETSYM(i) yields the AST subtree associated with symbol
  // xi. NOTE that if xi is a terminal, GETSYM(i) is undefined ! (However,
  // see token_action below.)
  // setSYM1(Object ast) is a function that allows us to assign an AST
  // tree to GETSYM(1).
  Object? getSym(final int i) {
    return parseStack[stateStackTop + (i - 1)];
  }

  void setSym1(final Object? ast) {
    parseStack[stateStackTop] = ast;
  }

  // Allocate or reallocate all the stacks. Their sizes should always be the same.
  void reallocateStacks() {
    final old_stack_length = stateStack.length;
    final stack_length = old_stack_length + STACK_INCREMENT;
    if (stateStack.isEmpty) {
      stateStack = List.filled(stack_length, 0);
      locationStack = List.filled(stack_length, 0);
      parseStack = List.filled(stack_length, null);
    } else {
      ArrayList.copy(stateStack, 0, stateStack = List.filled(stack_length, 0),
          0, old_stack_length);
      ArrayList.copy(locationStack, 0,
          locationStack = List.filled(stack_length, 0), 0, old_stack_length);
      ArrayList.copy(parseStack, 0,
          parseStack = List.filled(stack_length, null), 0, old_stack_length);
    }
    return;
  }

  // Allocate or reallocate the state stack only.
  void reallocateStateStack() {
    final old_stack_length = stateStack.length;
    final stack_length = old_stack_length + STACK_INCREMENT;
    if (stateStack.isEmpty) {
      stateStack = List.filled(stack_length, 0);
    } else {
      ArrayList.copy(stateStack, 0, stateStack = List.filled(stack_length, 0),
          0, old_stack_length);
    }
    return;
  }

  // Allocate location and parse stacks using the size of the state stack.
  void allocateOtherStacks() {
    locationStack = List.filled(stateStack.length, 0);
    parseStack = List.filled(stateStack.length, null);
    return;
  }
}

class StateElement {
  StateElement? parent, children, siblings;
  int number = 0;
}

class Token extends AbstractToken {
  Token(final int startOffset, final int endOffset, final int kind, final IPrsStream? iPrsStream)
      : super(startOffset, endOffset, kind, iPrsStream);

  // Return an iterator for the adjuncts that follow token i.
  @override
  List<IToken> getFollowingAdjuncts() {
    return getIPrsStream()!.getFollowingAdjuncts(getTokenIndex());
  }

  @override
  List<IToken> getPrecedingAdjuncts() {
    return getIPrsStream()!.getPrecedingAdjuncts(getTokenIndex());
  }
}

class TokenStreamNotIPrsStreamException implements Exception {
  String? str;

  TokenStreamNotIPrsStreamException([final this.str]);

  @override
  String toString() {
    return str ?? 'TokenStreamNotIPrsStreamException';
  }
}

class UnavailableParserInformationException implements Exception {
  final String? str;

  const UnavailableParserInformationException([final this.str]);

  @override
  String toString() {
    return str ?? 'Unavailable parser Information Exception';
  }
}

class UndefinedEofSymbolException implements Exception {
  final String? str;

  const UndefinedEofSymbolException([final this.str]);

  @override
  String toString() {
    return str ?? 'UndefinedEofSymbolException';
  }
}

class UnimplementedTerminalsException implements Exception {
  final ArrayList<dynamic>? symbols;

  UnimplementedTerminalsException(this.symbols);

  ArrayList<dynamic>? getSymbols() {
    return symbols;
  }
}

class UnknownStreamType implements Exception {
  final String? str;

  const UnknownStreamType([this.str]);

  @override
  String toString() {
    return str ?? 'UnknownStreamType';
  }
}

class ArrayList<E> {
  List<E> content = List<E>.empty(growable: true);

  ArrayList<E> clone() {
    final result = ArrayList<E>();
    for (var i = 0; i < content.length; i++) {
      result.content.add(content[i]);
    }
    return result;
  }

  void clear() {
    content = List.empty(growable: true);
  }

  void remove(final dynamic indexOrElem) {
    content.remove(indexOrElem);
  }

  void removeAll() {
    clear();
  }

  List<E> toArray() {
    final result = List<E>.empty(growable: true);
    for (final entry in content) {
      result.add(entry);
    }
    return result;
  }

  int size() {
    return content.length;
  }

  void add(final E elem) {
    content.add(elem);
  }

  E get(final int index) {
    return content[index];
  }

  bool contains(final E val) {
    return content.contains(val);
  }

  bool isEmpty() {
    return content.isEmpty;
  }

  void set(final int index, final E element) {
    content[index] = element;
  }

  int indexOf(final E element, [final int start = 0]) {
    return content.indexOf(element, start);
  }

  int lastIndexOf(final E element, [final int? start]) {
    return content.lastIndexOf(element, start);
  }

  static void copy<T>(final List<T> sourceArray, final int sourceIndex,
      final List<T> destinationArray, final int destinationIndex, final int length) {
    List.copyRange(destinationArray, destinationIndex, sourceArray, sourceIndex,
        sourceIndex + length);
  }
}
// endregion

// region constants
const int STACK_INCREMENT = 256;
const int BUFF_UBOUND = 31;
const int BUFF_SIZE = 32;
const int MAX_DISTANCE = 30;
const int MIN_DISTANCE = 3;
const int LEX_ERROR_CODE = 0;
const int ERROR_CODE = 1;
const int BEFORE_CODE = 2;
const int INSERTION_CODE = 3;
const int INVALID_CODE = 4;
const int SUBSTITUTION_CODE = 5;
const int SECONDARY_CODE = 5;
const int DELETION_CODE = 6;
const int MERGE_CODE = 7;
const int MISPLACED_CODE = 8;
const int SCOPE_CODE = 9;
const int EOF_CODE = 10;
const int INVALID_TOKEN_CODE = 11;
const int ERROR_RULE_ERROR_CODE = 11;
const int ERROR_RULE_WARNING_CODE = 12;
const int NO_MESSAGE_CODE = 13;
const int EOF = 0xffff;
/// The following constants can be used as indexes to dereference
/// values in the msgLocation and errorLocation arrays.
///
/// Locations are constructed by the method getLocation in LexStream which
/// takes two arguments: a start and an end location and returns an array
/// of 6 integers.
const int OFFSET_INDEX = 0;
const int LENGTH_INDEX = 1;
const int START_LINE_INDEX = 2;
const int START_COLUMN_INDEX = 3;
const int END_LINE_INDEX = 4;
const int END_COLUMN_INDEX = 5;
const List<String> errorMsgText = [
  /* LEX_ERROR_CODE */
  'unexpected character ignored',
  //$NON-NLS-1$
  /* ERROR_CODE */
  'parsing terminated at this token',
  //$NON-NLS-1$
  /* BEFORE_CODE */
  ' inserted before this token',
  //$NON-NLS-1$
  /* INSERTION_CODE */
  ' expected after this token',
  //$NON-NLS-1$
  /* INVALID_CODE */
  'unexpected input discarded',
  //$NON-NLS-1$
  /* SUBSTITUTION_CODE, SECONDARY_CODE */
  ' expected instead of this input',
  //$NON-NLS-1$
  /* DELETION_CODE */
  ' unexpected token(s) ignored',
  //$NON-NLS-1$
  /* MERGE_CODE */
  ' formed from merged tokens',
  //$NON-NLS-1$
  /* MISPLACED_CODE */
  'misplaced construct(s)',
  //$NON-NLS-1$
  /* SCOPE_CODE */
  ' inserted to complete scope',
  //$NON-NLS-1$
  /* EOF_CODE */
  ' reached after this token',
  //$NON-NLS-1$
  /* INVALID_TOKEN_CODE, ERROR_RULE_ERROR */
  ' is invalid',
  //$NON-NLS-1$
  /* ERROR_RULE_WARNING */
  ' is ignored',
  //$NON-NLS-1$
  /* NO_MESSAGE_CODE */
  ''
  //$NON-NLS-1$
];
// endregion