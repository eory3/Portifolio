import 'package:finance/config/assets.dart';
import 'package:finance/config/breakpoints.dart';
import 'package:finance/routing/routes.dart';
import 'package:finance/ui/auth/login/view_model/login_viewmodel.dart';
import 'package:finance/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  final LoginViewModel viewModel;
  const LoginScreen({super.key, required this.viewModel});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.login.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.login.removeListener(_onResult);
    widget.viewModel.login.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.login.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                final height = MediaQuery.of(context).size.height;

                return Row(
                  children: [
                    if (maxWidth >= Breakpoints.desktop) ...[
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: height,
                          child: Stack(
                            fit: StackFit.expand,
                            alignment: Alignment.center,
                            clipBehavior: Clip.hardEdge,
                            children: [
                              Image.asset(Assets.imageLogin, fit: BoxFit.cover),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).scaffoldBackgroundColor.withAlpha(700),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Column(
                                      spacing: 20,
                                      children: [
                                        Text(
                                          'Acesso ao Sistema',
                                          style:
                                              maxWidth > Breakpoints.desktop
                                                  ? Theme.of(
                                                    context,
                                                  ).textTheme.displayMedium
                                                  : Theme.of(
                                                    context,
                                                  ).textTheme.displaySmall,
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Gestor Financeiro',
                                          style:
                                              maxWidth > Breakpoints.desktop
                                                  ? Theme.of(
                                                    context,
                                                  ).textTheme.displayLarge
                                                  : Theme.of(
                                                    context,
                                                  ).textTheme.displayMedium,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Form(
                          key: widget.viewModel.formKey,
                          child: ListenableBuilder(
                            listenable: widget.viewModel,
                            builder: (context, child) {
                              bool loading = widget.viewModel.login.running;

                              return SizedBox(
                                height: 550,
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 60,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      spacing: 25,
                                      children: [
                                        Text(
                                          'Login',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.displayLarge,
                                        ),
                                        TextFormField(
                                          controller:
                                              widget.viewModel.emailController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'E-mail',
                                          ),
                                          enabled: !loading,
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'E-mail é obrigatório';
                                            }

                                            if (!Validator.isValidEmail(
                                              value,
                                            )) {
                                              return 'E-mail inválido';
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller:
                                              widget
                                                  .viewModel
                                                  .passwordController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Senha',
                                            suffixIcon: IconButton(
                                              onPressed:
                                                  widget
                                                      .viewModel
                                                      .setVisiblePassword
                                                      .execute,
                                              icon:
                                                  !widget
                                                          .viewModel
                                                          .visiblePassword
                                                      ? Icon(Icons.visibility)
                                                      : Icon(
                                                        Icons.visibility_off,
                                                      ),
                                            ),
                                          ),
                                          obscureText:
                                              !widget.viewModel.visiblePassword,
                                          enabled: !loading,
                                          textInputAction: TextInputAction.done,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          onFieldSubmitted: (value) {
                                            if (!loading) {
                                              widget.viewModel.login.execute();
                                            }
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Senha é obrigatória';
                                            }

                                            if (value.length < 6) {
                                              return 'Senha deve ter no mínimo 6 caracteres';
                                            }
                                            return null;
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton(
                                              onPressed:
                                                  loading
                                                      ? null
                                                      : () => context.go(
                                                        Routes.recovery,
                                                      ),
                                              child: Text(
                                                'Esqueci minha senha',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: FilledButton(
                                              onPressed:
                                                  loading
                                                      ? null
                                                      : widget
                                                          .viewModel
                                                          .login
                                                          .execute,
                                              child:
                                                  loading
                                                      ? Text('Carregando...')
                                                      : Text('Entrar'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onResult() {
    if (widget.viewModel.login.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.viewModel.login.message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
      widget.viewModel.login.clearResult();
    }
  }
}
