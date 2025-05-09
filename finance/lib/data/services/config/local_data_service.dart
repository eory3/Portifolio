import 'package:finance/utils/result.dart';

abstract class ILocalDataService {
  Future<Result<String>> get(String key);
  Future<Result<void>> set(String key, String value);
  Future<Result<void>> remove(String key);
}
