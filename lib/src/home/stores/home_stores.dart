import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:listadecontatos/src/home/models/home_models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HomeStores extends ChangeNotifier {
  List<Pessoa> list = [];
  TextEditingController nomeController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  String? imagePath;

  final _dio = Dio();
  HomeStores() {
    _dio.options.headers['X-Parse-Application-Id'] =
        '0qvegijMMZSJHC9iCeEl4TnaKHSFSC8ztpuPlfkX';
    _dio.options.headers['X-Parse-REST-API-Key'] =
        'd26oG3D1aAPF991kTy7ofzpPXTlMvPmE2KhJgfSQ';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  Future<List<Pessoa>> getList() async {
    try {
      final result =
          await _dio.get("https://parseapi.back4app.com/classes/contatos");
      list.clear();
      for (var data in result.data['results']) {
        final pessoa = Pessoa.fromJson(data);
        list.add(pessoa);
      }
    } catch (e) {
      print("erro $e");
    }
    return list;
  }

  Future<void> cadastrarContato(Pessoa pessoa) async {
    try {
      final response = await _dio.post(
          "https://parseapi.back4app.com/classes/contatos",
          data: pessoa.toJson());
      if (response.statusCode == 201) {
        pessoa.objectId = response.data['results'];
        list.add(pessoa);
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> tirarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imagePath = pickedFile.path;
      notifyListeners();
    }
  }

  Future<void> escolherGaleira() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imagePath = pickedFile.path;
      notifyListeners();
    }
  }

  void showImageSourceDialog(BuildContext context, HomeStores homeStores) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Escolher Origem da Imagem'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Câmera'),
                onTap: () {
                  tirarFoto();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Galeria'),
                onTap: () {
                  escolherGaleira();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void exibirModalCadastro(context, HomeStores homeStores) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cadastro de Contato'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    showImageSourceDialog(context, homeStores);
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        imagePath != null ? FileImage(File(imagePath!)) : null,
                    child: imagePath == null
                        ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: numeroController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Numero'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (imagePath != null) {
                      final appDir = await getApplicationDocumentsDirectory();
                      final fileName = '${DateTime.now()}.jpg';
                      final savedImage = File('${appDir.path}/$fileName');
                      final imageFile = File(imagePath!);
                      await imageFile.copy(savedImage.path);
                      imagePath = savedImage.path;
                      notifyListeners();
                    }

                    cadastrarContato(Pessoa(
                        nome: nomeController.text,
                        numero: numeroController.text,
                        fotoPath: imagePath ?? ''));

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    numeroController.clear();
                    nomeController.clear();
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
