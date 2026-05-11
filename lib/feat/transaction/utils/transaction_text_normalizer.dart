class TransactionTextNormalizer {
  static String normalize(String text) {
    final lower = text.toLowerCase();

    const accentMap = <String, String>{
      'á': 'a',
      'à': 'a',
      'â': 'a',
      'ã': 'a',
      'ä': 'a',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'í': 'i',
      'ì': 'i',
      'î': 'i',
      'ï': 'i',
      'ó': 'o',
      'ò': 'o',
      'ô': 'o',
      'õ': 'o',
      'ö': 'o',
      'ú': 'u',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ç': 'c',
      'ñ': 'n',
    };

    final normalized = StringBuffer();
    var previousWasSpace = false;

    for (final rune in lower.runes) {
      final char = String.fromCharCode(rune);
      final mapped = accentMap[char] ?? char;
      final isAlphaNum = _isAlphaNumeric(mapped);

      if (isAlphaNum) {
        normalized.write(mapped);
        previousWasSpace = false;
        continue;
      }

      if (!previousWasSpace) {
        normalized.write(' ');
        previousWasSpace = true;
      }
    }

    return normalized.toString().trim();
  }

  static bool _isAlphaNumeric(String value) {
    final codeUnit = value.codeUnitAt(0);
    final isNumber = codeUnit >= 48 && codeUnit <= 57;
    final isLowercaseLetter = codeUnit >= 97 && codeUnit <= 122;
    return isNumber || isLowercaseLetter;
  }
}
