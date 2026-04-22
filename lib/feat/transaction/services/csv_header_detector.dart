enum AccountType {
  credit,
  checking,
}

class CsvHeaderDetector {
  static int? findDateColumn(List<String> headers) {
    final normalized = headers.map(_normalize).toList();

    for (int i = 0; i < normalized.length; i++) {
      if (_dateKeywords.contains(normalized[i])) return i;
    }

    return null;
  }

  static int? findAmountColumn(List<String> headers) {
    final normalized = headers.map(_normalize).toList();

    for (int i = 0; i < normalized.length; i++) {
      if (_amountKeywords.contains(normalized[i])) return i;
    }

    return null;
  }

  static int? findDescriptionColumn(List<String> headers) {
    final normalized = headers.map(_normalize).toList();

    for (int i = 0; i < normalized.length; i++) {
      if (_descriptionKeywords.contains(normalized[i])) return i;
    }

    return null;
  }

  static AccountType detectAccountType(List<String> headers) {
    final normalizedHeaders = headers.map(_normalize).toList();

    final isCredit = normalizedHeaders.any(
      (header) => _creditHeaderKeywords.any(header.contains),
    );

    if (isCredit) return AccountType.credit;

    final isChecking = normalizedHeaders.any(
      (header) => _checkingHeaderKeywords.any(header.contains),
    );

    if (isChecking) return AccountType.checking;

    return AccountType.checking;
  }

  static String normalizeText(String s) => _normalize(s);

  static String _normalize(String s) {
    final lower = s.toLowerCase().trim();

    return lower
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('ä', 'a')
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('ë', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ì', 'i')
        .replaceAll('î', 'i')
        .replaceAll('ï', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ò', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ö', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ù', 'u')
        .replaceAll('û', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ç', 'c')
        .replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  static const _dateKeywords = {
    'date',
    'data',
    'postedat',
    'transactiondate',
  };

  static const _amountKeywords = {
    'amount',
    'valor',
    'value',
    'price',
  };

  static const _descriptionKeywords = {
    'description',
    'descricao',
    'historico',
    'merchant',
    'title',
  };

  static const _creditHeaderKeywords = {
    'categoria',
    'cartao',
  };

  static const _checkingHeaderKeywords = {
    'identificador',
    'tipo',
  };
}
