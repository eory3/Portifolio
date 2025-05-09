import 'package:auto_size_text/auto_size_text.dart';
import 'package:finance/utils/format.dart';
import 'package:flutter/material.dart';

class CardsInfoWidget extends StatelessWidget {
  final double totalEntry;
  final double totalOutput;
  final double balance;

  const CardsInfoWidget({
    super.key,
    required this.totalEntry,
    required this.totalOutput,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _CardInfo(
            title: 'Entradas',
            value: totalEntry,
            icon: Icons.arrow_circle_up,
          ),
          _CardInfo(
            title: 'Saídas',
            value: totalOutput,
            icon: Icons.arrow_circle_down,
          ),
          _CardInfo(
            title: 'Saldo',
            value: balance,
            icon: Icons.account_balance_wallet,
          ),
        ],
      ),
    );
  }
}

class _CardInfo extends StatelessWidget {
  final String title;
  final double value;
  final IconData icon;

  const _CardInfo({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              spacing: 8,
              children: [
                Icon(icon, size: 30),
                AutoSizeText(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  minFontSize: 1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AutoSizeText(
                  Format.currencyPtBr(value),
                  style: Theme.of(context).textTheme.titleLarge,
                  minFontSize: 1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
