import 'package:finance/domain/models/transaction.dart';
import 'package:finance/utils/format.dart';
import 'package:flutter/material.dart';

class ListTransactionWidget extends StatelessWidget {
  final List<ITransaction> transactions;
  final Function(String id) deleteTransaction;

  const ListTransactionWidget({
    super.key,
    required this.transactions,
    required this.deleteTransaction,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma transação lançada.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final finance = transactions[index];

        return Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              key: ValueKey(finance.id),
              title: Text(Format.currencyPtBr(finance.value)),
              subtitle: Text(finance.description),
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Dia ${finance.day}'),
                  Text(finance.type),
                  Text(finance.category),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteTransaction(finance.id!),
              ),
            ),
          ),
        );
      },
    );
  }
}
