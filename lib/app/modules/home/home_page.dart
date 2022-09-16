import 'package:adf_cuidapet/app/core/life_cycle/page_life_cycle_state.dart';
import 'package:adf_cuidapet/app/core/rest_client/rest_client.dart';
import 'package:adf_cuidapet/app/modules/home/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends PageLifeCycleState<HomeController, HomePage> {
  @override
  Map<String, dynamic>? get params => {'teste': 'teste life cycle'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Center(child: Text('logout')),
          ),
          TextButton(
            onPressed: () async {
              final categoriesResponse = await Modular.get<RestClient>()
                  .auth()
                  .get('/categories/'); //teste acessar categorias

              print(categoriesResponse.data);
            },
            child: Center(child: Text('Teste Refresh Token')),
          ),
        ],
      ),
    );
  }
}
