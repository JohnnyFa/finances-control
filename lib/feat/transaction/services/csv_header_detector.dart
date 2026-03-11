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

  static String _normalize(String s) {
    return s.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
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
}