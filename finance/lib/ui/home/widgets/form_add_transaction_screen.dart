import 'package:finance/config/environment.dart';
import 'package:finance/ui/core/ui/dialogs.dart';
import 'package:finance/ui/home/view_model/finance_viewmodel.dart';
import 'package:finance/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class FormAddTransactionScreen extends StatefulWidget {
  final TransactionViewModel viewModel;

  const FormAddTransactionScreen({super.key, required this.viewModel});

  @override
  State<FormAddTransactionScreen> createState() =>
      _FormAddTransactionScreenState();
}

class _FormAddTransactionScreenState extends State<FormAddTransactionScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.save.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant FormAddTransactionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.save.removeListener(_onResult);
    widget.viewModel.save.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.save.removeListener(_onResult);
    super.dispose();
  }

  Future<void> _selectDate() async {
    final firstDate = Environment.limitDate.firstDate;
    final lastDate = Environment.limitDate.lastDate;

    String selectedDate = widget.viewModel.dateController.text;

    DateTime? initialDate =
        selectedDate != ''
            ? DateTime.tryParse(
              Format.datePtBrToUs(widget.viewModel.dateController.text),
            )
            : DateTime.now();

    if (initialDate!.isBefore(firstDate)) {
      Dialogs.showError(
        context,
        title: 'Data inválida',
        message: 'Informe uma data após ${Format.datePtBr(firstDate)}.',
      );

      initialDate = DateTime.now();
    } else if (initialDate.isAfter(lastDate)) {
      Dialogs.showError(
        context,
        title: 'Data inválida',
        message: 'Informe uma data até ${Format.datePtBr(lastDate)}.',
      );

      initialDate = DateTime.now();
    } else {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );

      if (pickedDate != null) {
        widget.viewModel.dateController.text = Format.datePtBr(pickedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finanças'), centerTitle: true),
      body: SingleChildScrollView(
        child: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (_, child) {
            final loading = widget.viewModel.save.running;

            return Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: widget.viewModel.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 30,
                  children: [
                    Text(
                      'Adicionar Finanças',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),

                    // Valor
                    TextFormField(
                      enabled: !loading,
                      controller: widget.viewModel.valueController,
                      decoration: const InputDecoration(
                        label: Text('Valor'),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O valor é obrigatório.';
                        }

                        if (double.tryParse(Format.currencyPtBrToUs(value)) ==
                            null) {
                          return 'O valor está inválido.';
                        }

                        if (double.parse(Format.currencyPtBrToUs(value)) <= 0) {
                          return 'O valor deve ser maior que zero.';
                        }

                        return null;
                      },
                    ),

                    // Data
                    TextFormField(
                      enabled: !loading,
                      controller: widget.viewModel.dateController,
                      decoration: InputDecoration(
                        label: Text('Data'),
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: _selectDate,
                          icon: Icon(Icons.calendar_month),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'A data é obrigatória.';
                        }

                        if (DateTime.tryParse(Format.datePtBrToUs(value)) ==
                            null) {
                          return 'A data está inválida.';
                        }

                        return null;
                      },
                    ),

                    // Categorias
                    DropdownButtonFormField(
                      value: widget.viewModel.categoryController.text,
                      decoration: const InputDecoration(
                        label: Text('Categorias'),
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: '',
                          child: Text('Selecione uma categoria'),
                        ),
                        ...widget.viewModel.categories.map((String category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }),
                      ],
                      onChanged:
                          !loading
                              ? (value) {
                                widget.viewModel.categoryController.text =
                                    value.toString();
                              }
                              : null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'A categoria é obrigatória.';
                        }

                        return null;
                      },
                    ),

                    // Tipo de Lançamento
                    DropdownButtonFormField(
                      value: widget.viewModel.typeController.text,
                      decoration: const InputDecoration(
                        label: Text('Tipo de Lançamento'),
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: '',
                          child: Text('Selecione um tipo de lançamento'),
                        ),
                        ...widget.viewModel.types.map((String type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }),
                      ],
                      onChanged:
                          !loading
                              ? (value) {
                                widget.viewModel.typeController.text =
                                    value.toString();
                              }
                              : null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O tipo de lançamento é obrigatória.';
                        }

                        return null;
                      },
                    ),

                    // Descrição
                    TextFormField(
                      enabled: !loading,
                      controller: widget.viewModel.descriptionController,
                      decoration: const InputDecoration(
                        label: Text('Descrição'),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'A descrição é obrigatória.';
                        }

                        return null;
                      },
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: widget.viewModel.save.execute,
                        child:
                            loading
                                ? Text('Salvando...')
                                : const Text('Salvar'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onResult() {
    if (widget.viewModel.save.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          content: Text('Transação realizada com sucesso.'),
        ),
      );
      widget.viewModel.save.clearResult();
      context.pop();
    }

    if (widget.viewModel.save.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Text(widget.viewModel.save.message.toString()),
        ),
      );
      widget.viewModel.save.clearResult();
    }
  }
}
