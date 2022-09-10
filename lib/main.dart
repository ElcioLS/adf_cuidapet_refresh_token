import 'package:adf_cuidapet/app/app_module.dart';
import 'package:adf_cuidapet/app/app_widget.dart';
import 'package:adf_cuidapet/app/core/application_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
//Até aqui tudo funcionando

Future<void> main() async {
  await ApplicationConfig().configureApp();

  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}
