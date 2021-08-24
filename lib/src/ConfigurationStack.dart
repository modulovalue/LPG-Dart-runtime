//
//
//
import 'ObjectTuple.dart';
import 'ConfigurationElement.dart';
import 'ParseTable.dart';
import 'StateElement.dart';

class ConfigurationStack {
  static const int TABLE_SIZE = 1021; // 1021 is a prime

  List<ConfigurationElement?> table = List.filled(TABLE_SIZE, null);

  ObjectTuple configuration_stack = ObjectTuple(1 << 12);

  late StateElement state_root;

  int max_configuration_size = 0, stacks_size = 0, state_element_size = 0;

  late ParseTable prs;

  ConfigurationStack(ParseTable prs) {
    this.prs = prs;

    state_element_size++;

    state_root = StateElement();
    state_root.parent = null;
    state_root.siblings = null;
    state_root.children = null;
    state_root.number = prs.getStartState();
  }

  StateElement makeStateList(
      StateElement parent, List<int> stack, int index, int stack_top) {
    for (var i = index; i <= stack_top; i++) {
      state_element_size++;

      var state = StateElement();
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
      StateElement root, List<int> stack, int index, int stack_top) {
    var state_number = stack[index];
    for (StateElement? p = root; p != null; p = p.siblings) {
      if (p.number == state_number) {
        return (index == stack_top
            ? p
            : p.children == null
                ? makeStateList(p, stack, index + 1, stack_top)
                : findOrInsertStack(p.children!, stack, index + 1, stack_top));
      }
    }

    state_element_size++;

    StateElement node = StateElement();
    node.number = state_number;
    node.parent = root.parent;
    node.children = null;
    node.siblings = root.siblings;
    root.siblings = node;

    return (index == stack_top
        ? node
        : makeStateList(node, stack, index + 1, stack_top));
  }

  bool findConfiguration(List<int> stack, int stack_top, int curtok) {
    var last_element = findOrInsertStack(state_root, stack, 0, stack_top);
    var hash_address = curtok % TABLE_SIZE;
    for (var configuration = table[hash_address];
        configuration != null;
        configuration = configuration.next) {
      if (configuration.curtok == curtok &&
          last_element == configuration.last_element) return true;
    }

    return false;
  }

  //
  //
  //
  void push(List<int> stack, int stack_top, int conflict_index, int curtok,
      int action_length) {
    var configuration = ConfigurationElement();
    var hash_address = curtok % TABLE_SIZE;
    configuration.next = table[hash_address];
    table[hash_address] = configuration;
    max_configuration_size++; // keep track of number of configurations

    configuration.stack_top = stack_top;
    stacks_size +=
        (stack_top + 1); // keep track of number of stack elements processed
    configuration.last_element =
        findOrInsertStack(state_root, stack, 0, stack_top);
    configuration.conflict_index = conflict_index;
    configuration.curtok = curtok;
    configuration.action_length = action_length;

    configuration_stack.add(configuration);

    return;
  }

  //
  //
  //
  ConfigurationElement? pop() {
    ConfigurationElement? configuration;
    if (configuration_stack.size() > 0) {
      var index = configuration_stack.size() - 1;
      var configuration =
          configuration_stack.get(index) as ConfigurationElement;
      configuration.act = prs.baseAction(configuration.conflict_index++);
      if (prs.baseAction(configuration.conflict_index) == 0) {
        configuration_stack.reset(index);
      }
    }

    return configuration;
  }

  //
  //
  //
  ConfigurationElement? top() {
    ConfigurationElement? configuration;
    if (configuration_stack.size() > 0) {
      var index = configuration_stack.size() - 1;
      configuration = configuration_stack.get(index) as ConfigurationElement;
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
