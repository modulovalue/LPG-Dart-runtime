import 'StateElement.dart';

class ConfigurationElement {
  ConfigurationElement? next;

  StateElement? last_element;
  int stack_top = 0, action_length = 0, conflict_index = 0, curtok = 0, act = 0;

  void retrieveStack(List<int> stack) {
    var tail = last_element;
    for (var i = stack_top; i >= 0; i--) {
      if (tail == null) return;
      stack[i] = tail.number;
      tail = tail.parent;
    }
    return;
  }
}
