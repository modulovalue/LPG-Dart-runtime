//
// This Tuple class can be used to construct a dynamic
// array of integers. The space for the array is allocated in
// blocks of size 2**LOG_BLKSIZE. In declaring a tuple the user
// may specify an estimate of how many elements he expects.
// Based on that estimate, suitable values will be calculated
// for log_blksize and base_increment. If these estimates are
// found to be off later, more space will be allocated.
//
class IntTuple {
  late List<int> array;
  int top = 0;

  //
  // This function is used to reset the size of a dynamic array without
  // allocating or deallocting space. It may be invoked with an integer
  // argument n which indicates the new size or with no argument which
  // indicates that the size should be reset to 0.
  //

  void reset([int n = 0]) {
    top = n;
  }

  //
  // Return size of the dynamic array.
  //
  int size() {
    return top;
  }
  int capacity(){
    return array.length;
  }
  //
  // Return a reference to the ith element of the dynamic array.
  //
  // Note that no check is made here to ensure that 0 <= i < top.
  // Such a check might be useful for debugging and a range exception
  // should be thrown if it yields true.
  //
  int get(int i) {
    return array[i];
  }

  //
  // Insert an element in the dynamic array at the location indicated.
  //
  void set(int i, int element) {
    array[i] = element;
  }

  //
  // Add an element to the dynamic array and return the top index.
  //
  int nextIndex() {
    var i = top++;
    if (i >= array.length) {
      List.copyRange(array, 0, array = List.filled(i * 2,0), 0, i);
    }
    return i;
  }

  //
  // Add an element to the dynamic array and return a reference to
  // that new element.
  //
  void add(int element) {
    var i = nextIndex();
    array[i] = element;
  }

  //
  // Constructor of a Tuple
  //

  IntTuple([int estimate = 10]) {
    array = List.filled(estimate, 0);
  }
}
