import 'BadParseException.dart';
import 'BadParseSymFileException.dart';
import 'IntTuple.dart';
import 'Monitor.dart';
import 'NotDeterministicParseTableException.dart';
import 'ParseTable.dart';
import 'RuleAction.dart';
import 'Stacks.dart';
import 'TokenStream.dart';
import 'UnavailableParserInformationException.dart';

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

  //
  // keep looking ahead until we compute a valid action
  //
  int lookahead(int act, int token) {
    act = prs.lookAhead(act - LA_STATE_OFFSET, tokStream.getKind(token));
    return (act > LA_STATE_OFFSET
        ? lookahead(act, tokStream.getNext(token))
        : act);
  }

  //
  // Compute the next action defined on act and sym. If this
  // action requires more lookahead, these lookahead symbols
  // are in the token stream beginning at the next token that
  // is yielded by peek().
  //
  int tAction1(int act, int sym) {
    act = prs.tAction(act, sym);
    return (act > LA_STATE_OFFSET ? lookahead(act, tokStream.peek()) : act);
  }

  //
  // Compute the next action defined on act and the next k tokens
  // whose types are stored in the array sym starting at location
  // index. The array sym is a circular buffer. If we reach the last
  // element of sym and we need more lookahead, we proceed to the
  // first element.
  //
  // assert(sym.length == prs.getMaxLa());
  //
  int tAction(int act, List<int> sym, int index) {
    act = prs.tAction(act, sym[index]);
    while (act > LA_STATE_OFFSET) {
      index = ((index + 1) % sym.length);
      act = prs.lookAhead(act - LA_STATE_OFFSET, sym[index]);
    }

    return act;
  }

  //
  // Process reductions and continue...
  //
  void processReductions() {
    do {
      stateStackTop -= (prs.rhs(currentAction) - 1);
      ra.ruleAction(currentAction);
      currentAction =
          prs.ntAction(stateStack[stateStackTop], prs.lhs(currentAction));
    } while (currentAction <= NUM_RULES);

    return;
  }

  //
  // The following functions can be invoked only when the parser is
  // processing actions. Thus, they can be invoked when the parser
  // was entered via the main entry point (parse()). When using
  // the incremental parser (via the entry point parse(int [], int)),
  // an Exception is thrown if any of these functions is invoked?
  // However, note that when parseActions() is invoked after successfully
  // parsing an input with the incremental parser, then they can be invoked.
  //
  int getCurrentRule() {
    if (taking_actions) return currentAction;
    throw UnavailableParserInformationException();
  }

  int getFirstToken1() {
    if (taking_actions) return getToken(1);
    throw UnavailableParserInformationException();
  }

  int getFirstToken([int? i]) {
    if (null == i) {
      return getFirstToken1();
    }
    if (taking_actions) {
      return getToken(i);
    }
    throw UnavailableParserInformationException();
  }

  int getLastToken1() {
    if (taking_actions) return lastToken;
    throw UnavailableParserInformationException();
  }

  int getLastToken([int? i]) {
    if (null == i) {
      return getLastToken1();
    }
    if (taking_actions) {
      return (i >= prs.rhs(currentAction)
          ? lastToken
          : tokStream.getPrevious(getToken(i + 1)));
    }
    throw UnavailableParserInformationException();
  }

  void setMonitor(Monitor? monitor) {
    this.monitor = monitor;
  }

  void reset1() {
    this.taking_actions = false;
    this.markerKind = 0;

    if (action != null) {
      action!.reset();
    }
  }

  void reset2(TokenStream tokStream, Monitor? monitor) {
    this.monitor = monitor;
    this.tokStream = tokStream;

    reset1();
  }

  void reset(
      [TokenStream? tokStream,
      ParseTable? prs,
      RuleAction? ra,
      Monitor? monitor]) {
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
      if (!prs.getBacktrack()) throw NotDeterministicParseTableException();
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
      [TokenStream? tokStream,
      ParseTable? prs,
      RuleAction? ra,
      Monitor? monitor])
      : super() {
    reset(tokStream, prs, ra, monitor);
  }

  //
  //
  //
  Object? parseEntry(int marker_kind) {
    //
    // Indicate that we are running the regular parser and that it's
    // ok to use the utility functions to query the parser.
    //
    taking_actions = true;

    //
    // Reset the token stream and get the first token.
    //
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

    //
    // Start parsing.
    //
    reallocateStacks(); // make initial allocation
    stateStackTop = -1;
    currentAction = START_STATE;

    ProcessTerminals:
    for (;;) {
      //
      // if the parser needs to stop processing,
      // it may do so here.
      //
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
      } else
        break ProcessTerminals;
    }

    taking_actions = false; // indicate that we are done

    if (currentAction == ERROR_ACTION) {
      throw BadParseException(curtok);
    }

    return parseStack[marker_kind == 0 ? 0 : 1];
  }

  //
  // This method is invoked when using the parser in an incremental mode
  // using the entry point parse(int [], int).
  //
  void resetParser() {
    resetParserEntry(0);
  }

  //
  // This method is invoked when using the parser in an incremental mode
  // using the entry point parse(int [], int).
  //
  void resetParserEntry(int marker_kind) {
    this.markerKind = marker_kind;

    if (stateStack == null) reallocateStacks(); // make initial allocation
    stateStackTop = 0;
    stateStack[stateStackTop] = START_STATE;
    if (action == null)
      action = new IntTuple(1 << 20);
    else
      action!.reset();

    //
    // Indicate that we are going to run the incremental parser and that
    // it's forbidden to use the utility functions to query the parser.
    //
    taking_actions = false;

    if (marker_kind != 0) {
      var sym = [markerKind];
      parse(sym, 0);
    }
  }

  //
  // Find a state in the state stack that has a valid action on ERROR token
  //
  bool recoverableState(int state) {
    for (var k = prs.asi(state); prs.asr(k) != 0; k++) {
      if (prs.asr(k) == ERROR_SYMBOL) return true;
    }
    return false;
  }

  //
  // Reset the parser at a point where it can legally process
  // the error token. If we can't do that, reset it to the beginning.
  //
  void errorReset() {
    var gate = (this.markerKind == 0 ? 0 : 1);
    for (; stateStackTop >= gate; stateStackTop--)
      if (recoverableState(stateStack[stateStackTop])) break;
    if (stateStackTop < gate) resetParserEntry(markerKind);
    return;
  }

  //
  // This is an incremental LALR(k) parser that takes as argument
  // the next k tokens in the input. If these k tokens are valid for
  // the current configuration, it advances past the first of the k
  // tokens and returns either:
  //
  //    . the last transition induced by that token
  //    . the Accept action
  //
  // If the tokens are not valid, the initial configuration remains
  // unchanged and the Error action is returned.
  //
  // Note that it is the user's responsibility to start the parser in a
  // proper configuration by initially invoking the method resetParser
  // prior to invoking this function.
  //
  int parse(List<int> sym, int index) {
    // assert(sym.length == prs.getMaxLa());

    //
    // First, we save the current length of the action tuple, in
    // case an error is encountered and we need to restore the
    // original configuration.
    //
    // Next, we declara and initialize the variable pos which will
    // be used to indicate the highest useful position in stateStack
    // as we are simulating the actions induced by the next k input
    // terminals in sym.
    //
    // The location stack will be used here as a temporary stack
    // to simulate these actions. We initialize its first useful
    // offset here.
    //
    int save_action_length = action!.size(),
        pos = stateStackTop,
        location_top = stateStackTop - 1;

    //
    // When a reduce action is encountered, we compute all REDUCE
    // and associated goto actions induced by the current token.
    // Eventually, a SHIFT, SHIFT-REDUCE, ACCEPT or ERROR action is
    // computed...
    //
    for (currentAction = tAction(stateStack[stateStackTop], sym, index);
        currentAction <= NUM_RULES;
        currentAction = tAction(currentAction, sym, index)) {
      action!.add(currentAction);
      do {
        location_top -= (prs.rhs(currentAction) - 1);
        var state = (location_top > pos
            ? locationStack[location_top]
            : stateStack[location_top]);
        currentAction = prs.ntAction(state, prs.lhs(currentAction));
      } while (currentAction <= NUM_RULES);

      //
      // ... Update the maximum useful position of the
      // stateSTACK, push goto state into stack, and
      // continue by compute next action on current symbol
      // and reentering the loop...
      //
      pos = pos < location_top ? pos : location_top;
      try {
        locationStack[location_top + 1] = currentAction;
      } on RangeError {
        reallocateStacks();
        locationStack[location_top + 1] = currentAction;
      }
    }

    //
    // At this point, we have a shift, shift-reduce, accept or error
    // action. stateSTACK contains the configuration of the state stack
    // prior to executing any action on the currenttoken. locationStack
    // contains the configuration of the state stack after executing all
    // reduce actions induced by the current token. The variable pos
    // indicates the highest position in the stateSTACK that is still
    // useful after the reductions are executed.
    //
    if (currentAction > ERROR_ACTION || // SHIFT-REDUCE action ?
        currentAction < ACCEPT_ACTION) // SHIFT action ?
    {
      action!.add(currentAction);
      //
      // If no error was detected, update the state stack with
      // the info that was temporarily computed in the locationStack.
      //
      stateStackTop = location_top + 1;
      for (var i = pos + 1; i <= stateStackTop; i++)
        stateStack[i] = locationStack[i];

      //
      // If we have a shift-reduce, process it as well as
      // the goto-reduce actions that follow it.
      //
      if (currentAction > ERROR_ACTION) {
        currentAction -= ERROR_ACTION;
        do {
          stateStackTop -= (prs.rhs(currentAction) - 1);
          currentAction =
              prs.ntAction(stateStack[stateStackTop], prs.lhs(currentAction));
        } while (currentAction <= NUM_RULES);
      }

      //
      // Process the  transition - either a shift action of
      // if we started out with a shift-reduce, the  GOTO
      // action that follows it.
      //
      try {
        stateStack[++stateStackTop] = currentAction;
      } on RangeError {
        reallocateStacks();
        stateStack[stateStackTop] = currentAction;
      }
    } else if (currentAction == ERROR_ACTION)
      action!.reset(save_action_length); // restore original action state.
    return currentAction;
  }

  //
  // Now do the  parse of the input based on the actions in
  // the list "action" and the sequence of tokens in the token stream.
  //
  Object? parseActions() {
    //
    // Indicate that we are processing actions now (for the incremental
    // parser) and that it's ok to use the utility functions to query the
    // parser.
    //
    taking_actions = true;

    tokStream.reset();
    lastToken = tokStream.getPrevious(tokStream.peek());
    var curtok = (markerKind == 0 ? tokStream.getToken() : lastToken);

    try {
      //
      // Reparse the input...
      //
      stateStackTop = -1;
      currentAction = START_STATE;

      for (var i = 0; i < action!.size(); i++) {
        //
        // if the parser needs to stop processing, it may do so here.
        //
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
    } catch (e) // if any exception is thrown, indicate BadParse
    {
      taking_actions = false; // indicate that we are done.
      throw BadParseException(curtok);
    }

    taking_actions = false; // indicate that we are done.
    action = null; // turn into garbage
    return parseStack[markerKind == 0 ? 0 : 1];
  }
}
