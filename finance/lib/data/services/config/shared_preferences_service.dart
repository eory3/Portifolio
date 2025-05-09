import 'package:finance/data/services/config/local_data_service.dart';
import 'package:finance/utils/result.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataService extends ILocalDataService {
  final _log = Logger('SharedPreferencesService');

  @override
  Future<Result<String>> get(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final result = sharedPreferences.getString(key);

    if (result != null) {
      return Result.ok(result);
    } else {
      _log.warning('Dado não encontrado no armazenamento local: $key');
      return Result.error('Falha ao obter dados do armazenamento local.');
    }
  }

  @override
  Future<Result<bool>> remove(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final result = await sharedPreferences.remove(key);

    if (result) {
      return Result.ok(true);
    } else {
      _log.warning('Dado não encontrado no armazenamento local: $key');
      return Result.error('Falha ao remover dados do armazenamento local.');
    }
  }

  @override
  Future<Result<bool>> set(String key, String value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final result = await sharedPreferences.setString(key, value);

    if (result) {
      return Result.ok(true);
    } else {
      _log.warning(
        'Falha ao salvar dado no armazenamento local: $key = $value',
      );
      return Result.error('Falha ao salvar dados no armazenamento local.');
    }
  }
}
