
class UnavailableParserInformationException implements Exception {


  String? str;

  UnavailableParserInformationException([String? str]) {
    this.str = str;
  }

  @override
  String toString() {
    return str??'Unavailable parser Information Exception';
  }
}
