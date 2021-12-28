class ArrayList<E>  {

    List content = List.empty(growable: true);

    ArrayList<E>   clone()
    {
      var result = ArrayList<E>();
      for (var i = 0; i < content.length; i++) {
          result.content.add(content[i]);
      }
      return result;
    }


    void clear() {
      content = List.empty(growable: true);
    }

    void remove(indexOrElem) {
      content.remove(indexOrElem);
    }

    void removeAll() {
      clear();
    }

  List<E> toArray() {
      var result =List<E>.empty(growable: true);
      for(var entry in content ){
        result.add(entry);
      }
      return result;
  }

  int size() {
      return content.length;
  }

  void add(E elem) {
    content.add(elem);
  }

  E get(int index){
      return content[index];
  }

  bool contains(E val) {
      return content.contains(val);
  }

  bool isEmpty() {
      return content.isEmpty;
  }

  void set(int index,  E element) {
    content[index] = element;
  }

  int indexOf(E element, [int start = 0]) {
    return content.indexOf(element,start);}

  int lastIndexOf(E element, [int? start]) {
    return content.lastIndexOf(element,start);
  }
  static void copy<T>(
        List<T> sourceArray,
        int sourceIndex,
        List<T> destinationArray,
        int destinationIndex,
        int length){
      List.copyRange(destinationArray,destinationIndex,sourceArray,sourceIndex,sourceIndex+length);
    }


}


