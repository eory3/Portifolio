abstract class Environment {
  static final httpKeys = _HttpKeys();
  static final localKeys = _LocalKeys();
  static final limitDate = _LimitDate();
  static final collectionsKeys = _CollectionsKeys();
}

final class _HttpKeys {
  final String baseUrl = 'https://api.example.com/';
  final String teste = 'teste';
}

final class _LocalKeys {
  final String user = 'user';
  final String token = 'token';
}

final class _CollectionsKeys {
  final String users = 'users';
  final String transactions = 'transactions';
  final String categories = 'categories';
  final String types = 'types';
}

final class _LimitDate {
  final DateTime firstDate = DateTime(1000);
  final DateTime lastDate = DateTime(9999, 12, 31);
}
