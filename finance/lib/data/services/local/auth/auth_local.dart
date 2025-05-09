import 'package:finance/config/environment.dart';
import 'package:finance/data/services/config/local_data_service.dart';
import 'package:finance/data/services/local/auth/auth_local_service.dart';
import 'package:finance/data/services/models/user.dart';
import 'package:finance/domain/models/user.dart';
import 'package:finance/utils/result.dart';

class AuthLocalService implements IAuthLocalService {
  final ILocalDataService _localDataService;

  AuthLocalService({required ILocalDataService localDataService})
    : _localDataService = localDataService;

  @override
  Future<Result<IUser>> getUser() async {
    final user = await _localDataService.get(Environment.localKeys.user);

    switch (user) {
      case Ok<String>():
        return Result.ok(UserModel.fromJson(user.value));
      case Error<String>():
        return Result.error(user.error);
    }
  }

  @override
  Future<Result<void>> removeUser() async {
    final result = await _localDataService.remove(Environment.localKeys.user);

    switch (result) {
      case Ok<void>():
        return Result.ok(null);
      case Error<void>():
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<void>> setUser(IUser user) async {
    final result = await _localDataService.set(
      Environment.localKeys.user,
      (user as UserModel).toJson(),
    );

    switch (result) {
      case Ok<void>():
        return Result.ok(null);
      case Error<void>():
        return Result.error(result.error);
    }
  }
}
