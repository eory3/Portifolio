import 'package:finance/domain/models/user.dart';
import 'package:finance/utils/result.dart';

abstract class IAuthLocalService {
  Future<Result<IUser>> getUser();
  Future<Result<void>> setUser(IUser user);
  Future<Result<void>> removeUser();
}
