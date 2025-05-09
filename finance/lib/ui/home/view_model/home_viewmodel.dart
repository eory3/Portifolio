import 'package:finance/data/repositories/auth/auth_repository.dart';
import 'package:finance/domain/models/user.dart';
import 'package:finance/utils/command.dart';
import 'package:finance/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required IAuthRepository authRepository})
    : _authRepository = authRepository {
    load = Command0(_load)..execute();
    logout = Command0(_logout);
  }

  late final Command0 load;
  late final IAuthRepository _authRepository;
  late final Command0 logout;

  IUser? _user;
  IUser? get user => _user;

  final _log = Logger('HomeViewModel');

  Future<Result<void>> _load() async {
    final result = await _authRepository.getUser();

    switch (result) {
      case Ok<IUser>():
        _user = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error<IUser>():
        notifyListeners();
        _log.warning('Erro ao carregar usuário. ${result.error}');
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _logout() async {
    final result = await _authRepository.logout();

    switch (result) {
      case Ok<void>():
        return Result.ok(null);
      case Error<void>():
        _log.warning('Erro ao sair da aplicação. ${result.error}');
        return Result.error(result.error);
    }
  }
}
