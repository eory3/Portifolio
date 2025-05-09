import 'package:finance/data/repositories/auth/auth_repository.dart';
import 'package:finance/utils/command.dart';
import 'package:finance/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({required IAuthRepository authRepository}) {
    _authRepository = authRepository;
    setVisiblePassword = Command0(_setVisiblePassword);
    login = Command0(_login);
  }

  late final Command0 setVisiblePassword;
  late final Command0 login;
  late final IAuthRepository _authRepository;

  bool _visiblePassword = false;
  bool get visiblePassword => _visiblePassword;

  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  final _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  final _log = Logger('LoginViewModel');

  Future<Result<bool>> _setVisiblePassword() async {
    _visiblePassword = !_visiblePassword;
    notifyListeners();
    return Result.ok(_visiblePassword);
  }

  Future<Result<bool>> _login() async {
    notifyListeners();

    if (!_formKey.currentState!.validate()) {
      _log.fine('Campos obrigatórios não preenchidos.');
      return Result.error('Existem campos obrigatórios não preenchidos.');
    }

    final result = await _authRepository.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
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
