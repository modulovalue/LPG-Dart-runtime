/*
 * Created on Oct 7, 2004
 *
 *  To be used by an lpg generated lexer
*/

import java.io.IOException;

/**
 * @author fisher
 *
 */
 abstract class LpgLexStream extends LexStream
{
    /**
     * 
     */
     LpgLexStream() {
        super();
    }

    /**
     * @param tab
     */
     LpgLexStream(int tab) {
        super(tab);
    }

    /**
     * @param fileName
     */
     LpgLexStream(String fileName) throws IOException
    {
    	super(fileName);
    }

    /**
     * @param fileName
     * @param tab
     */
     LpgLexStream(String fileName, int tab) throws IOException
    {
    	super(fileName, tab);
    }

    /**
     * @param inputChars
     * @param fileName
     */
     LpgLexStream(char[] inputChars, String fileName) {
        super(inputChars, fileName);
    }

    /**
     * @param lineOffsets
     * @param inputChars
     * @param fileName
     */
     LpgLexStream(IntSegmentedTuple lineOffsets, char[] inputChars, String fileName) {
        super(lineOffsets, inputChars, fileName);
    }

    /**
     * @param inputChars
     * @param fileName
     * @param tab
     */
     LpgLexStream(char[] inputChars, String fileName, int tab) {
        super(inputChars, fileName, tab);
    }

    /**
     * @param lineOffsets
     * @param inputChars
     * @param fileName
     * @param tab
     */
     LpgLexStream(IntSegmentedTuple lineOffsets, char[] inputChars, String fileName, int tab) {
        super(lineOffsets, inputChars, fileName, tab);
    }

    /* (non-Javadoc)
     * @see lpg.runtime.TokenStream#getKind(int)
     */
     abstract int getKind(int i);

     abstract List<String> orderedExportedSymbols();
}
