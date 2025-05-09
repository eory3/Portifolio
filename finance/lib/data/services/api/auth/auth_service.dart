import 'package:finance/domain/models/user.dart';
import 'package:finance/utils/result.dart';

abstract class IAuthService {
  bool get isAuthenticated;
  Future<Result<IUser>> login({
    required String email,
    required String password,
  });
  Future<Result<void>> logout();
  Future<Result<void>> recovery({required String email});
}
