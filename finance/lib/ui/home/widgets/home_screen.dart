import 'package:finance/routing/routes.dart';
import 'package:finance/ui/home/view_model/finance_viewmodel.dart';
import 'package:finance/ui/home/view_model/home_viewmodel.dart';
import 'package:finance/ui/home/widgets/components/cards_info_widget.dart';
import 'package:finance/ui/home/widgets/components/graphic_widget.dart';
import 'package:finance/ui/home/widgets/components/list_transaction_widget.dart';
import 'package:finance/ui/home/widgets/components/month_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  final HomeViewModel viewModel;
  final TransactionViewModel transactionViewModel;

  const HomeScreen({
    super.key,
    required this.viewModel,
    required this.transactionViewModel,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListenableBuilder(
          listenable: widget.transactionViewModel,
          builder: (context, child) {
            return RefreshIndicator(
              onRefresh: widget.viewModel.load.execute,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    centerTitle: true,
                    expandedHeight: 150,
                    actionsPadding: EdgeInsets.all(8),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.logout),
                        tooltip: 'Sair',
                        onPressed: widget.viewModel.logout.execute,
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Bem vindo(a) ${widget.viewModel.user?.firstName ?? ''}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      centerTitle: true,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: MonthWidget(
                      month: widget.transactionViewModel.monthSelected,
                      onMonthSelected: (month) {
                        widget.transactionViewModel.selectMonth.execute(month);
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: CardsInfoWidget(
                      totalEntry: widget.transactionViewModel.totalEntry,
                      totalOutput: widget.transactionViewModel.totalOutput,
                      balance: widget.transactionViewModel.balance,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child:
                        widget.transactionViewModel.transactions.isEmpty
                            ? const SizedBox.shrink()
                            : GraphicWidget(
                              categories:
                                  widget.transactionViewModel.categories,
                              transactions:
                                  widget.transactionViewModel.transactions,
                            ),
                  ),
                  SliverAppBar(
                    pinned: true,
                    centerTitle: true,
                    expandedHeight: 50,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Histórico de Lançamentos',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      centerTitle: true,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ListenableBuilder(
                      listenable: widget.transactionViewModel,
                      builder: (context, child) {
                        return ListTransactionWidget(
                          transactions:
                              widget.transactionViewModel.transactions,
                          deleteTransaction: (id) {
                            widget.transactionViewModel.delete.execute(id);
                          },
                        );
                      },
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: const SizedBox(height: 70),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 3,
          tooltip: "Adicionar",
          child: Icon(Icons.add),
          onPressed: () {
            context.push(Routes.transactionAdd);
          },
        ),
      ),
    );
  }
}
