//
// LexStream contains an array of characters as the input stream to be parsed.
// There are methods to retrieve and classify characters.
// The lexparser "token" is implemented simply as the index of the next character in the array.
// The user must subclass LexStreamBase and implement the abstract methods: getKind.
//
import 'dart:convert';

import 'IMessageHandler.dart';
import 'IntSegmentedTuple.dart';
import 'ParseErrorCodes.dart';
import 'Protocol.dart';
import 'dart:io';
import 'dart:async';

class LexStream implements ILexStream {
  static const int DEFAULT_TAB = 1;

  int index = -1;
  int streamLength = 0;
  String inputChars = '';
  String fileName = '';
  late IntSegmentedTuple lineOffsets;
  int tab = DEFAULT_TAB;
  IPrsStream? prsStream;

  LexStream(String fileName,
      [String? inputChars,
      int tab = DEFAULT_TAB,
      IntSegmentedTuple? lineOffsets]) {
    this.lineOffsets = IntSegmentedTuple(12);
    setLineOffset(-1);
    this.tab = tab;
    initialize(fileName, inputChars, lineOffsets);
  }

  static Future<String> fromStringStream(Stream<String> stream) async {
    final data = StringBuffer();
    await stream.listen((buf) {
      data.write(buf);
    }).asFuture();
    return data.toString();
  }

  static Future<String> fromStream(Stream<List<int>> stream,
      {Encoding encoding = utf8}) {
    final data = stream.transform(encoding.decoder);
    return fromStringStream(data);
  }

  static Future<String> fromPath(String path, {Encoding encoding = utf8}) {
    return fromStream(File(path).openRead());
  }

  void initialize(String fileName, String? inputChars,
      IntSegmentedTuple? lineOffsets) async {
    inputChars ??= await File(fileName).readAsString();
    /*if(inputChars == null) {
        return;
      }*/
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
    for (var i = 0; i < inputChars.length; i++)
      if (inputChars[i] == 0x0A) setLineOffset(i);
  }

  void setInputChars(String inputChars) {
    this.inputChars = inputChars;
    index = -1; // reset the start index to the beginning of the input
  }

  String getInputChars() {
    return inputChars;
  }

  void setFileName(String fileName) {
    this.fileName = fileName;
  }

  String getFileName() {
    return fileName;
  }

  void setLineOffsets(IntSegmentedTuple lineOffsets) {
    this.lineOffsets = lineOffsets;
  }

  IntSegmentedTuple getLineOffsets() {
    return lineOffsets;
  }

  void setTab(int tab) {
    this.tab = tab;
  }

  int getTab() {
    return tab;
  }

  void setStreamIndex(int index) {
    this.index = index;
  }

  int getStreamIndex() {
    return index;
  }

  void setStreamLength(int streamLength) {
    this.streamLength = streamLength;
  }

  @override
  int getStreamLength() {
    return streamLength;
  }

  void setLineOffset(int i) {
    lineOffsets.add(i);
  }

  @override
  int getLineOffset(int i) {
    return lineOffsets.get(i);
  }

  @override
  void setPrsStream(IPrsStream prsStream) {
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
  String getCharValue(int i) {
    return inputChars[i];
  }

  @override
  int getIntValue(int i) {
    return inputChars.codeUnitAt(i);
  }

  /**
   * @deprecated replaced by {@link #getLineCount()}
   *
   */
  int getLine2() {
    return getLineCount();
  }

  @override
  int getLineCount() {
    return lineOffsets.size() - 1;
  }

  @override
  int getLineNumberOfCharAt(int i) {
    var index = lineOffsets.binarySearch(i);
    return index < 0
        ? -index
        : index == 0
            ? 1
            : index;
  }

  @override
  int getColumnOfCharAt(int i) {
    int lineNo = getLineNumberOfCharAt(i), start = lineOffsets.get(lineNo - 1);
    if (start + 1 >= streamLength) return 1;
    for (var k = start + 1; k < i; k++) {
      if (inputChars[k] == '\t') {
        var offset = (k - start) - 1;
        start -= ((tab - 1) - offset % tab);
      }
    }
    return i - start;
  }

  //
  // Methods that implement the TokenStream Interface.
  // Note that this function updates the lineOffsets table
  // as a side-effect when the next character is a line feed.
  // If this is not the expected behavior then this function should
  // be overridden.
  //
  int getToken2() {
    return index = getNext(index);
  }

  @override
  int getToken([int? end_token]) {
    if (null == end_token) {
      return getToken2();
    }

    return index = (index < end_token ? getNext(index) : streamLength);
  }

  int getKind(int i) {
    return 0;
  }

  /// @deprecated replaced by {@link #getNext()}
  ///
  int next(int i) {
    return getNext(i);
  }

  @override
  int getNext(int i) {
    return (++i < streamLength ? i : streamLength);
  }

  /// @deprecated replaced by {@link #getPrevious()}
  ///
  int previous(int i) {
    return getPrevious(i);
  }

  @override
  int getPrevious(int i) {
    return (i <= 0 ? 0 : i - 1);
  }

  @override
  String getName(int i) {
    return i >= getStreamLength() ? "" : "" + getCharValue(i);
  }

  @override
  int peek() {
    return getNext(index);
  }

  @override
  void reset([int? i]) {
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
  int getLine(int i) {
    return getLineNumberOfCharAt(i);
  }

  @override
  int getColumn(int i) {
    return getColumnOfCharAt(i);
  }

  int getEndLine(int i) {
    return getLine(i);
  }

  int getEndColumn(int i) {
    return getColumnOfCharAt(i);
  }

  bool afterEol(int i) {
    return (i < 1
        ? true
        : getLineNumberOfCharAt(i - 1) < getLineNumberOfCharAt(i));
  }

  /**
   * @deprecated replaced by {@link #getFirstRealToken()}
   *
   */
  int getFirstErrorToken(int i) {
    return getFirstRealToken(i);
  }

  int getFirstRealToken(int i) {
    return i;
  }

  /**
   * @deprecated replaced by {@link #getLastRealToken()}
   *
   */
  int getLastErrorToken(int i) {
    return getLastRealToken(i);
  }

  int getLastRealToken(int i) {
    return i;
  }

  //
  // Here is where we report errors.  The default method is simply to print the error message to the console.
  // However, the user may supply an error message handler to process error messages.  To support that
  // a message handler interface is provided that has a single method handleMessage().  The user has his
  // error message handler class implement the IMessageHandler interface and provides an object of this type
  // to the runtime using the setMessageHandler(errorMsg) method. If the message handler object is set,
  // the reportError methods will invoke its handleMessage() method.
  //
  IMessageHandler? errMsg; // this is the error message handler object

  @override
  void setMessageHandler(IMessageHandler errMsg) {
    this.errMsg = errMsg;
  }

  @override
  IMessageHandler? getMessageHandler() {
    return errMsg;
  }

  @override
  void makeToken(int startLoc, int endLoc, int kind) {
    if (prsStream != null) {
      prsStream!.makeToken(startLoc, endLoc, kind);
    } else {
      reportLexicalError(startLoc, endLoc);
    } // make it a lexical error
  }

  /// See IMessaageHandler for a description of the List<int> return value.
  @override
  List<int> getLocation(int left_loc, int right_loc) {
    var length = (right_loc < streamLength ? right_loc : streamLength - 1) -
        left_loc +
        1;
    return [
      left_loc,
      length,
      getLineNumberOfCharAt(left_loc),
      getColumnOfCharAt(left_loc),
      getLineNumberOfCharAt(right_loc),
      getColumnOfCharAt(right_loc)
    ];
  }

  @override
  void reportError(int errorCode, int leftToken, int rightToken, errorInfo,
      [int errorToken = 0]) {
    // TODO: implement reportError
  }

  @override
  void reportLexicalError(int left_loc, int right_loc,
      [int? errorCode,
      int? error_left_loc_arg,
      int? error_right_loc_arg,
      List<String>? errorInfo_arg]) {
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
      errorCode = (right_loc >= streamLength
          ? EOF_CODE
          : left_loc == right_loc
              ? LEX_ERROR_CODE
              : INVALID_TOKEN_CODE);
      var tokenText = (errorCode == EOF_CODE
          ? 'End-of-file '
          : errorCode == INVALID_TOKEN_CODE
              ? '\"' + inputChars.substring(left_loc, right_loc + 1) + '\" '
              : '\"' + getCharValue(left_loc) + '\" ');
      error_left_loc = 0;
      error_right_loc = 0;
      errorInfo = [tokenText];
    }

    if (null == errMsg) {
      var locationInfo = getFileName() +
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
        stdout.write(errorInfo[i] + " ");
      }

      stdout.write(errorMsgText[errorCode]);
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
  String toStringWithOffset(int startOffset, int endOffset) {
    // TODO: implement toStringWithOffset
    var length = endOffset - startOffset + 1;
    return (endOffset >= inputChars.length
        ? '\$EOF'
        : length <= 0
            ? ''
            : inputChars.substring(startOffset, length));
  }
}
