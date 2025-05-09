import 'package:finance/config/assets.dart';
import 'package:finance/config/breakpoints.dart';
import 'package:finance/routing/routes.dart';
import 'package:finance/ui/auth/recovery/view_model/recovery_viewmodel.dart';
import 'package:finance/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecoveryScreen extends StatefulWidget {
  final RecoveryViewModel viewModel;
  const RecoveryScreen({super.key, required this.viewModel});

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.recovery.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant RecoveryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.recovery.removeListener(_onResult);
    widget.viewModel.recovery.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.recovery.removeListener(_onResult);
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
                                          'Recupere sua senha de forma descomplicada',
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
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: widget.viewModel.formKey,
                          child: ListenableBuilder(
                            listenable: widget.viewModel,
                            builder: (context, child) {
                              bool loading = widget.viewModel.recovery.running;

                              return SizedBox(
                                height: 550,
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 20,
                                      bottom: 60,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 15,
                                          ),
                                          child: IconButton(
                                            onPressed:
                                                () => context.go(Routes.login),
                                            icon: const Icon(Icons.arrow_back),
                                            iconSize: 32,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            spacing: 40,
                                            children: [
                                              Text(
                                                'Recuperação de Senha',
                                                style:
                                                    Theme.of(
                                                      context,
                                                    ).textTheme.displayLarge,
                                              ),
                                              TextFormField(
                                                controller:
                                                    widget
                                                        .viewModel
                                                        .emailController,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'E-mail',
                                                ),
                                                enabled: !loading,
                                                textInputAction:
                                                    TextInputAction.done,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                onFieldSubmitted: (value) {
                                                  if (!loading) {
                                                    widget.viewModel.recovery
                                                        .execute();
                                                  }
                                                },
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 20,
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
                                                                .recovery
                                                                .execute,
                                                    child:
                                                        loading
                                                            ? Text(
                                                              'Carregando...',
                                                            )
                                                            : Text('Recuperar'),
                                                  ),
                                                ),
                                              ),
                                            ],
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
    if (widget.viewModel.recovery.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Email enviado com sucesso, verifique sua caixa de entrada.',
          ),
          duration: const Duration(seconds: 5),
        ),
      );
      widget.viewModel.recovery.clearResult();
    }

    if (widget.viewModel.recovery.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.viewModel.recovery.message.toString()),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
      widget.viewModel.recovery.clearResult();
    }
  }
}
