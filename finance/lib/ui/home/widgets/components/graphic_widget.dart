import 'package:finance/domain/models/transaction.dart';
import 'package:finance/ui/home/widgets/components/chart_widget.dart';
import 'package:flutter/material.dart';

class GraphicWidget extends StatelessWidget {
  // TODO: Ajustar para trazer as categorias do backend
  final List<String> categories;
  final List<ITransaction> transactions;
  const GraphicWidget({
    super.key,
    required this.categories,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        spacing: 20,
        children: [
          Text(
            'Gráfico de Consumo',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Card(
            elevation: 3,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: ChartWidget(
                categories: categories,
                transactions: transactions,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
