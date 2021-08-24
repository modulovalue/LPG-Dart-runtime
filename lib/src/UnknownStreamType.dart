class UnknownStreamType implements Exception {


  String? str;


  UnknownStreamType([String? str]) {
    this.str = str;
  }
  @override
  String toString() {
    return str??'UnknownStreamType';
  }
}
