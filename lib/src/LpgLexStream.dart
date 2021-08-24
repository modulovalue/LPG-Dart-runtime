/*
 * Created on Oct 7, 2004
 *
 *  To be used by an lpg generated lexer
*/

import 'IntSegmentedTuple.dart';
import 'LexStream.dart';

/// @author fisher
///
abstract class LpgLexStream extends LexStream {
  /// @param lineOffsets
  /// @param inputChars
  /// @param fileName
  /// @param tab
  LpgLexStream(String fileName,
      [String? inputChars,
      int tab = LexStream.DEFAULT_TAB,
      IntSegmentedTuple? lineOffsets])
      : super(fileName, inputChars, tab, lineOffsets) {}
}
