import 'package:finance/data/repositories/auth/auth_repository.dart';
import 'package:finance/utils/command.dart';
import 'package:finance/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class RecoveryViewModel extends ChangeNotifier {
  RecoveryViewModel({required IAuthRepository authRepository})
    : _authRepository = authRepository {
    recovery = Command0(_recovery);
  }

  late final IAuthRepository _authRepository;
  late final Command0 recovery;

  final _log = Logger('RecoveryViewModel');

  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  final _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  Future<Result<bool>> _recovery() async {
    notifyListeners();

    if (!_formKey.currentState!.validate()) {
      _log.fine('Campos obrigatórios não preenchidos.');
      return Result.error('Existem campos obrigatórios não preenchidos.');
    }

    final result = await _authRepository.recovery(
      email: _emailController.text.trim(),
    );

    switch (result) {
      case Ok<void>():
        notifyListeners();
        return Result.ok(true);
      case Error<void>():
        _log.warning(result.error);
        notifyListeners();
        return Result.error(result.error);
    }
  }
}
