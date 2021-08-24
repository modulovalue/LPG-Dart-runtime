

 class Stacks
{
    final int STACK_INCREMENT = 1024;
    int    stateStackTop=0;

     List<int>    stateStack=[];
      List<int>    locationStack=[];
      List<Object?> parseStack=[];

    //
    // Given a rule of the form     A ::= x1 x2 ... xn     n > 0
    //
    // the function GETTOKEN(i) yields the symbol xi, if xi is a terminal
    // or ti, if xi is a nonterminal that produced a string of the form
    // xi => ti w.
    //
     int getToken(int i)
    {
        return locationStack[stateStackTop + (i - 1)];
    }

    //
    // Given a rule of the form     A ::= x1 x2 ... xn     n > 0
    //
    // The function GETSYM(i) yields the AST subtree associated with symbol
    // xi. NOTE that if xi is a terminal, GETSYM(i) is undefined ! (However,
    // see token_action below.)
    //
    // setSYM1(Object ast) is a function that allows us to assign an AST
    // tree to GETSYM(1).
    //
     Object? getSym(int i) { return parseStack[stateStackTop + (i - 1)]; }
     void setSym1(Object ast) { parseStack[stateStackTop] = ast; }

    //
    // Allocate or reallocate all the stacks. Their sizes should always be the same.
    //
     void reallocateStacks()
    {
        var old_stack_length = stateStack.length;
        var   stack_length = old_stack_length + STACK_INCREMENT;
        if (stateStack.isEmpty)
        {
            stateStack = List.filled(stack_length, 0);
            locationStack = List.filled(stack_length, 0);
            parseStack = List.filled(stack_length, null);
        }
        else
        {
            List.copyRange(stateStack, 0, stateStack = List.filled(stack_length, 0), 0, old_stack_length);
            List.copyRange(locationStack, 0, locationStack = List.filled(stack_length, 0), 0, old_stack_length);
            List.copyRange(parseStack, 0, parseStack = List.filled(stack_length, null), 0, old_stack_length);
        }
        return;
    }

    //
    // Allocate or reallocate the state stack only.
    //
     void reallocateStateStack()
    {
        var old_stack_length = stateStack.length;
        var  stack_length = old_stack_length + STACK_INCREMENT;
        if (stateStack.isEmpty) {
          stateStack = List.filled(stack_length, 0);
        } else {
          List.copyRange(stateStack, 0, stateStack = List.filled(stack_length,0), 0, old_stack_length);
        }
        return;
    }

    //
    // Allocate location and parse stacks using the size of the state stack.
    //
     void allocateOtherStacks()
    {
        locationStack = List.filled(stateStack.length,0);
        parseStack = List.filled(stateStack.length,null);
        return;
    }
}
