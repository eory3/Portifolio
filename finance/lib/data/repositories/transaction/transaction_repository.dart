import 'package:finance/domain/models/transaction.dart';
import 'package:finance/utils/result.dart';

abstract class ITransactionRepository {
  Future<Result<List<ITransaction>>> get({required String month});
  Future<Result<ITransaction>> post({required ITransaction transaction});
  Future<Result<ITransaction>> update({required ITransaction transaction});
  Future<Result<void>> delete({required String id});
}
