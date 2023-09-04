import 'package:flutter/material.dart';
import 'package:listadecontatos/src/home/models/home_models.dart';
import 'package:listadecontatos/src/home/stores/home_stores.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final homeStores = Provider.of<HomeStores>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Contatos'),
      ),
      body: FutureBuilder<List<Pessoa>>(
        future: homeStores.getList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum contato encontrado.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final contato = snapshot.data![index];
                return ListTile(
                  title: Text(contato.nome),
                  subtitle: Text(contato.numero),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: contato.fotoPath != null
                        ? FileImage(File(contato.fotoPath))
                        : null,
                    child: contato.fotoPath == null
                        ? Icon(Icons.person, size: 40, color: Colors.white)
                        : null,
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          homeStores.exibirModalCadastro(context, homeStores);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
