import 'package:finance/data/repositories/auth/auth_repository.dart';
import 'package:finance/data/services/api/auth/auth_service.dart';
import 'package:finance/data/services/local/auth/auth_local_service.dart';
import 'package:finance/domain/models/user.dart';
import 'package:finance/utils/result.dart';
import 'package:logging/logging.dart';

class AuthRepository extends IAuthRepository {
  final IAuthService _authService;
  final IAuthLocalService _authLocalService;

  AuthRepository({
    required IAuthService authService,
    required IAuthLocalService authLocalService,
  }) : _authService = authService,
       _authLocalService = authLocalService;

  final _log = Logger('AuthRepository');

  @override
  bool get isAuthenticated => _authService.isAuthenticated;

  @override
  Future<Result<IUser>> getUser() async {
    final userLocal = await _authLocalService.getUser();

    switch (userLocal) {
      case Ok<IUser>():
        return Result.ok(userLocal.value);
      case Error<IUser>():
        return Result.error(userLocal.error);
    }
  }

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authService.login(email: email, password: password);

      switch (result) {
        case Ok<IUser>():
          final setUser = await _authLocalService.setUser(result.value);

          switch (setUser) {
            case Ok<void>():
              return Result.ok(null);
            case Error<void>():
              _log.warning(setUser.error);
              return Result.error(setUser.error);
          }
        case Error<IUser>():
          _log.warning(result.error);
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      final result = await _authService.logout();

      switch (result) {
        case Ok<void>():
          await _authLocalService.removeUser();
          return Result.ok(null);
        case Error<void>():
          _log.warning(result.error);
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> recovery({required String email}) async {
    try {
      final result = await _authService.recovery(email: email);

      switch (result) {
        case Ok<void>():
          return Result.ok(null);
        case Error<void>():
          _log.warning(result.error);
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
    }
  }
}
