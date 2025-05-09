import 'package:finance/data/repositories/transaction/transaction_repository.dart';
import 'package:finance/data/services/api/transaction/transaction_service.dart';
import 'package:finance/domain/models/transaction.dart';
import 'package:finance/utils/result.dart';

class TransactionRepository implements ITransactionRepository {
  final ITransactionService _transactionService;

  TransactionRepository({required ITransactionService transactionService})
    : _transactionService = transactionService;

  @override
  Future<Result<List<ITransaction>>> get({required String month}) async {
    final result = await _transactionService.get(month: month);

    switch (result) {
      case Ok<List<ITransaction>>():
        return Result.ok(result.value);
      case Error<List<ITransaction>>():
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<ITransaction>> post({required ITransaction transaction}) async {
    final result = await _transactionService.post(transaction: transaction);

    switch (result) {
      case Ok<ITransaction>():
        return Result.ok(result.value);
      case Error<ITransaction>():
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<ITransaction>> update({
    required ITransaction transaction,
  }) async {
    final result = await _transactionService.update(transaction: transaction);

    switch (result) {
      case Ok<ITransaction>():
        return Result.ok(result.value);
      case Error<ITransaction>():
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<void>> delete({required String id}) async {
    final result = await _transactionService.delete(id: id);

    switch (result) {
      case Ok<void>():
        return Result.ok(null);
      case Error<void>():
        return Result.error(result.error);
    }
  }
}
