import 'package:flutter/material.dart';
import 'package:listadecontatos/src/home/screens/home_screen.dart';
import 'package:listadecontatos/src/home/stores/home_stores.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Desafio Cep',
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<HomeStores>(create: (_) => HomeStores()),
          ],
          child: const HomeScreen(),
        ));
  }
}
