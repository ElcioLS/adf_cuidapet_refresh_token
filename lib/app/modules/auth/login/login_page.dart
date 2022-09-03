import 'package:adf_cuidapet/app/core/ui/icons/cuidapeticons_icons.dart';
import 'package:adf_cuidapet/app/core/ui/widgets/cuidapet_text_form_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final testeEC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CuidapetTextFormField(
                label: 'Login',
                obscureText: false,
                controller: testeEC,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Valor obrigatório';
                  }
                  return null;
                },
              ),
              Text(testeEC.text),
              ElevatedButton(
                onPressed: () {
                  formKey.currentState?.validate();
                  print(testeEC.text);
                },
                child: const Text('Validar'),
              ),
              const Icon(Cuidapeticons.facebook),
              const Icon(Cuidapeticons.google),
            ],
          ),
        ),
      ),
    );
  }
}
