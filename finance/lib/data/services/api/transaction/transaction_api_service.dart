import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/data/services/api/transaction/transaction_service.dart';
import 'package:finance/data/services/models/transaction.dart';
import 'package:finance/domain/models/transaction.dart';
import 'package:finance/utils/result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

class TransactionApiService implements ITransactionService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  final _log = Logger('TransactionApiService');

  TransactionApiService({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore;

  @override
  Future<Result<List<ITransaction>>> get({required String month}) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        _log.warning('Usuário não autenticado');
        return Result.error('Usuário não autenticado');
      }

      final result = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .where('month', isEqualTo: month)
          .get()
          .then(
            (value) =>
                value.docs.map((e) => {...e.data(), 'id': e.id}).toList(),
          );

      if (result.isEmpty) {
        _log.warning('Nenhum dado encontrado para o mês: $month');
        return Result.error('Nenhum dado encontrado para o mês: $month');
      }

      final transactions =
          result.map((e) => TransactionModel.fromMap(e)).toList();

      return Result.ok(transactions);
    } catch (error) {
      _log.warning('Erro ao buscar finanças: $error');
      return Result.error('Erro ao buscar finanças: $error');
    }
  }

  @override
  Future<Result<ITransaction>> post({required ITransaction transaction}) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        _log.warning('Usuário não autenticado');
        return Result.error('Usuário não autenticado');
      }
      final transactionModel = transaction as TransactionModel;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .add(transactionModel.toMap());

      return Result.ok(transactionModel);
    } catch (error) {
      _log.warning('Erro ao buscar finanças: $error');
      return Result.error('Erro ao buscar finanças: $error');
    }
  }

  @override
  Future<Result<ITransaction>> update({
    required ITransaction transaction,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        _log.warning('Usuário não autenticado');
        return Result.error('Usuário não autenticado');
      }
      final transactionModel = transaction as TransactionModel;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(transactionModel.id)
          .update(transactionModel.toMap());

      return Result.ok(transactionModel);
    } catch (error) {
      _log.warning('Erro ao buscar finanças: $error');
      return Result.error('Erro ao buscar finanças: $error');
    }
  }

  @override
  Future<Result<void>> delete({required String id}) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        _log.warning('Usuário não autenticado');
        return Result.error('Usuário não autenticado');
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(id)
          .delete();

      return Result.ok(null);
    } catch (error) {
      _log.warning('Erro ao buscar finanças: $error');
      return Result.error('Erro ao buscar finanças: $error');
    }
  }
}
