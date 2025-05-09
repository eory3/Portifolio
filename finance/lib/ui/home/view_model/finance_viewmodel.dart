import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:finance/data/repositories/transaction/transaction_repository.dart';
import 'package:finance/data/services/models/transaction.dart';
import 'package:finance/domain/models/transaction.dart';
import 'package:finance/utils/command.dart';
import 'package:finance/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class TransactionViewModel extends ChangeNotifier {
  TransactionViewModel({required ITransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository {
    load = Command0(_load)..execute();
    save = Command0(_save);
    get = Command1(_get);
    delete = Command1(_delete);
    _monthSelected = _months[DateTime.now().month - 1];
    selectMonth = Command1(_selectMonth);
  }

  final _log = Logger('TransactionViewModel');

  late final Command0 load;
  late final Command0 save;
  late final Command1<List<ITransaction>, String> get;
  late final Command1<void, String> delete;
  late final Command1<void, String> selectMonth;

  final ITransactionRepository _transactionRepository;

  final List<ITransaction> _transactions = [];
  List<ITransaction> get transactions => _transactions;

  double _totalEntry = 0.0;
  double get totalEntry => _totalEntry;
  double _totalOutput = 0.0;
  double get totalOutput => _totalOutput;
  double _balance = 0.0;
  double get balance => _balance;

  final List<String> _months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  String _monthSelected = '';
  String get monthSelected => _monthSelected;

  // Controller para adicionar
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  final MoneyMaskedTextController _valueController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
    initialValue: 0.0,
    precision: 2,
  );
  MoneyMaskedTextController get valueController => _valueController;

  final MaskedTextController _dateController = MaskedTextController(
    mask: "00/00/0000",
  );
  MaskedTextController get dateController => _dateController;

  final TextEditingController _descriptionController = TextEditingController();
  TextEditingController get descriptionController => _descriptionController;

  final List<String> _categories = [
    'Aluguel',
    'Artigos Religiosos',
    'Assinaturas',
    'Energia',
    'Farmácia',
    'Internet',
    'IFood',
    'Uber',
    'Zé',
    'Outros',
  ];
  List<String> get categories => _categories;

  final TextEditingController _categoryController = TextEditingController();
  TextEditingController get categoryController => _categoryController;

  final List<String> _types = ['Entrada', 'Saída'];
  List<String> get types => _types;

  final TextEditingController _typeController = TextEditingController();
  TextEditingController get typeController => _typeController;

  Future<Result<void>> _selectMonth(String month) async {
    notifyListeners();
    _monthSelected = _months[int.parse(month) - 1];
    return await _get(month);
  }

  Future<Result<List<ITransaction>>> _load() async {
    final month = DateTime.now().month.toString().padLeft(2, '0');
    return await _get(month);
  }

  Future<Result<List<ITransaction>>> _get(String month) async {
    notifyListeners();

    _transactions.clear();
    _totalEntry = 0.0;
    _totalOutput = 0.0;
    _balance = 0.0;

    final result = await _transactionRepository.get(month: month);

    switch (result) {
      case Ok<List<ITransaction>>():
        _transactions.addAll(result.value);

        _totalEntry = _transactions
            .where((element) => element.type == 'Entrada')
            .fold(
              0.0,
              (previousValue, element) => previousValue + element.value,
            );
        _totalOutput = _transactions
            .where((element) => element.type == 'Saída')
            .fold(
              0.0,
              (previousValue, element) => previousValue + element.value,
            );
        _balance = _totalEntry - _totalOutput;

        notifyListeners();
        return Result.ok(result.value);
      case Error<List<ITransaction>>():
        _log.warning('Erro ao carregar transactioniro. ${result.error}');
        notifyListeners();
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _delete(String id) async {
    notifyListeners();
    final result = await _transactionRepository.delete(id: id);

    switch (result) {
      case Ok<void>():
        _transactions.removeWhere((element) => element.id == id);
        notifyListeners();
        return Result.ok(null);
      case Error<void>():
        _log.warning('Erro ao deletar transactioniro. ${result.error}');
        notifyListeners();
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _save() async {
    notifyListeners();

    if (!_formKey.currentState!.validate()) {
      _log.fine('Campos obrigatórios não preenchidos.');
      notifyListeners();
      return Result.error('Existem campos obrigatórios não preenchidos.');
    }

    final date = _dateController.text;
    final day = date.split('/')[0];
    final month = date.split('/')[1];
    final year = date.split('/')[2];

    final ITransaction transaction = TransactionModel(
      value: _valueController.numberValue,
      date: date,
      description: _descriptionController.text,
      category: _categoryController.text,
      type: _typeController.text,
      day: day,
      month: month,
      year: year,
    );

    final result = await _transactionRepository.post(transaction: transaction);

    switch (result) {
      case Ok<ITransaction>():
        notifyListeners();
        return Result.ok(null);
      case Error<ITransaction>():
        notifyListeners();
        _log.warning('Erro ao salvar transactioniro. ${result.error}');
        return Result.error(result.error);
    }
  }
}
