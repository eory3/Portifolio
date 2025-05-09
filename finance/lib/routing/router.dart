import 'package:finance/data/repositories/auth/auth_repository.dart';
import 'package:finance/routing/routes.dart';
import 'package:finance/ui/auth/login/view_model/login_viewmodel.dart';
import 'package:finance/ui/auth/login/widgets/login_screen.dart';
import 'package:finance/ui/auth/recovery/view_model/recovery_viewmodel.dart';
import 'package:finance/ui/auth/recovery/widgets/recovery_screen.dart';
import 'package:finance/ui/home/view_model/finance_viewmodel.dart';
import 'package:finance/ui/home/view_model/home_viewmodel.dart';
import 'package:finance/ui/home/widgets/form_add_transaction_screen.dart';
import 'package:finance/ui/home/widgets/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter router(IAuthRepository authRepository) => GoRouter(
  initialLocation: Routes.home,
  debugLogDiagnostics: true,
  redirect: _redirect,
  refreshListenable: authRepository,
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        final viewModel = HomeViewModel(authRepository: context.read());

        final transactionViewModel = TransactionViewModel(
          transactionRepository: context.read(),
        );

        return HomeScreen(
          viewModel: viewModel,
          transactionViewModel: transactionViewModel,
        );
      },
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        final viewModel = LoginViewModel(authRepository: context.read());

        return LoginScreen(viewModel: viewModel);
      },
    ),
    GoRoute(
      path: Routes.recovery,
      builder: (context, state) {
        final viewModel = RecoveryViewModel(authRepository: context.read());
        return RecoveryScreen(viewModel: viewModel);
      },
    ),
    GoRoute(
      path: Routes.transactionAdd,
      builder: (context, state) {
        final viewModel = TransactionViewModel(
          transactionRepository: context.read(),
        );

        return FormAddTransactionScreen(viewModel: viewModel);
      },
    ),
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final loggedIn = context.read<IAuthRepository>().isAuthenticated;
  final loggingIn = state.matchedLocation == Routes.login;
  final recoveryIn = state.matchedLocation == Routes.recovery;

  // Se o usuário não estiver logado e não estiver tentando recuperar a senha redireciona para a página de login
  if (!loggedIn && !recoveryIn) {
    return Routes.login;
  }

  // Se o usuário estiver logado e tentar acessar a página de login ou de recuperação de senha redireciona para a home
  if (loggedIn && (loggingIn || recoveryIn)) {
    return Routes.home;
  }

  // Deixa o usuário prosseguir para a página desejada
  return null;
}
