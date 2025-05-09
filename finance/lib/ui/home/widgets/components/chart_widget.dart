import 'package:finance/config/breakpoints.dart';
import 'package:finance/domain/models/transaction.dart';
import 'package:finance/utils/format.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartWidget extends StatefulWidget {
  final List<String> categories;
  final List<ITransaction> transactions;
  const ChartWidget({
    super.key,
    required this.categories,
    required this.transactions,
  });

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        return AspectRatio(
          aspectRatio: 1.3,
          child: Row(
            children: <Widget>[
              const SizedBox(height: 18),
              Expanded(
                flex: 80,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex =
                                pieTouchResponse
                                    .touchedSection!
                                    .touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: _pieChartSectionData(),
                    ),
                  ),
                ),
              ),
              if (maxWidth > Breakpoints.tablet)
                Expanded(
                  flex: 20,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Indicator(
                          color: Colors.green.shade600,
                          text: 'Saldo Disponível',
                          isSquare: true,
                        ),
                        SizedBox(height: 4),
                        Indicator(
                          color: Colors.red.shade600,
                          text: 'Saldo Gasto',
                          isSquare: true,
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              const SizedBox(width: 28),
            ],
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _pieChartSectionData() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      final totalEntry = widget.transactions
          .where((element) => element.type == 'Entrada')
          .fold(0.0, (previousValue, element) => previousValue + element.value);

      final totalOutput = widget.transactions
          .where((element) => element.type == 'Saída')
          .fold(0.0, (previousValue, element) => previousValue + element.value);

      final balance = totalEntry > 0 ? totalEntry - totalOutput : 0.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.red.shade600,
            value: totalOutput,
            title: 'Gastos\n ${Format.currencyPtBr(totalOutput)}',
            radius: radius,
            titleStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: fontSize,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.green.shade600,
            value: balance,
            title: 'Restante\n ${Format.currencyPtBr(balance)}',
            radius: radius,
            titleStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: fontSize,
              shadows: shadows,
            ),
          );
        default:
          return PieChartSectionData(
            color: Colors.green.shade600,
            value: balance,
            title: 'Saldo Total \n ${Format.currencyPtBr(balance)}',
            radius: radius,
            titleStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: fontSize,
              shadows: shadows,
            ),
          );
      }
    });
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
