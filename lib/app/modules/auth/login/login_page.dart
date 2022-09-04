import 'package:adf_cuidapet/app/core/ui/icons/cuidapeticons_icons.dart';
import 'package:adf_cuidapet/app/core/ui/widgets/cuidapet_default_button.dart';
import 'package:adf_cuidapet/app/core/ui/widgets/cuidapet_text_form_field.dart';
import 'package:adf_cuidapet/app/core/ui/widgets/rounded_button_with_icon.dart';
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
              RoundedButtonWithIcon(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Clicou no Facebook')));
                },
                width: 200,
                color: Colors.indigo,
                icon: Cuidapeticons.facebook,
                label: 'facebook',
              ),
              RoundedButtonWithIcon(
                onTap: () {},
                width: 200,
                color: Colors.orange,
                icon: Cuidapeticons.google,
                label: 'google',
              ),
              CuidapetDefaultButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('clicou'),
                    ),
                  );
                },
                label: 'Entrar',
                width: 200,
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
