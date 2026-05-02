class CsvHeaderDetector {
  static int? findDateColumn(List<String> headers) {
    final normalized = headers.map(_normalize).toList();

    for (int i = 0; i < normalized.length; i++) {
      for (final keyword in _dateKeywords) {
        if (normalized[i].contains(keyword)) return i;
      }
    }

    return null;
  }

  static int? findAmountColumn(List<String> headers) {
    final normalized = headers.map(_normalize).toList();

    for (int i = 0; i < normalized.length; i++) {
      for (final keyword in _amountKeywords) {
        if (normalized[i].contains(keyword)) return i;
      }
    }

    return null;
  }

  static int? findDescriptionColumn(List<String> headers) {
    final normalized = headers.map(_normalize).toList();

    for (int i = 0; i < normalized.length; i++) {
      for (final keyword in _descriptionKeywords) {
        if (normalized[i].contains(keyword)) return i;
      }
    }

    return null;
  }

  static String _normalize(String s) {
    final lower = s.toLowerCase();

    return lower
        .replaceAll(RegExp(r'[áàãâä]'), 'a')
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[íìîï]'), 'i')
        .replaceAll(RegExp(r'[óòõôö]'), 'o')
        .replaceAll(RegExp(r'[úùûü]'), 'u')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .replaceAll(RegExp(r'[^a-z]'), '');
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
    'detalhe',
  };
}