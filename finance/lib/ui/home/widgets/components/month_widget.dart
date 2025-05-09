import 'package:flutter/material.dart';

class MonthWidget extends StatelessWidget {
  final String month;
  final Function(String month) onMonthSelected;

  const MonthWidget({
    super.key,
    required this.month,
    required this.onMonthSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Mês de ', style: Theme.of(context).textTheme.titleLarge),
            ElevatedButton(
              onPressed: () async {
                await _showDialog(context).then((value) {
                  if (value != null) {
                    onMonthSelected(value.toString().padLeft(2, '0'));
                  }
                });
              },
              style: Theme.of(context).elevatedButtonTheme.style,
              child: Text(month),
            ),
          ],
        ),
      ),
    );
  }
}

Future<int?> _showDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Center(child: const Text('Selecione um Mês')),
        contentPadding: const EdgeInsets.all(10),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    _ButtonSelectMonth(title: 'Janeiro', month: 1),
                    _ButtonSelectMonth(title: 'Fevereiro', month: 2),
                    _ButtonSelectMonth(title: 'Março', month: 3),
                    _ButtonSelectMonth(title: 'Abril', month: 4),
                    _ButtonSelectMonth(title: 'Maio', month: 5),
                    _ButtonSelectMonth(title: 'Junho', month: 6),
                    _ButtonSelectMonth(title: 'Julho', month: 7),
                    _ButtonSelectMonth(title: 'Agosto', month: 8),
                    _ButtonSelectMonth(title: 'Setembro', month: 9),
                    _ButtonSelectMonth(title: 'Outubro', month: 10),
                    _ButtonSelectMonth(title: 'Novembro', month: 11),
                    _ButtonSelectMonth(title: 'Dezembro', month: 12),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}

class _ButtonSelectMonth extends StatelessWidget {
  final int month;
  final String title;

  const _ButtonSelectMonth({required this.month, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 115,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(month),
        style: Theme.of(context).elevatedButtonTheme.style,
        child: Text(title),
      ),
    );
  }
}
