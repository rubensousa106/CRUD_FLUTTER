import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EcraScreen extends StatefulWidget {
  const EcraScreen({Key? key}) : super(key: key);
  static String routeName = "/ecra";

  @override
  State<EcraScreen> createState() => _EcraScreenState();
}

class _EcraScreenState extends State<EcraScreen> {
  // textfields controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();

  final CollectionReference _productss =
      FirebaseFirestore.instance.collection('Produtos');

  // Esta função é acionada quando o botão flutuante ou um dos botões de edição é pressionado
  // Adicionando um produto se nenhum documentSnapshot for passado
  // Se documentSnapshot != null então atualize um produto existente
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot[
          'nome']; //documentSnapshot elemeneto de conexao com a BD
      _priceController.text = documentSnapshot['preco']
          .toString(); //documentSnapshot elemeneto de conexao com a BD
      _categoriaController.text = documentSnapshot[
          'categoria']; //documentSnapshot elemeneto de conexao com a BD
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // impede que o teclado virtual cubra campos de texto
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Preco',
                  ),
                ),
                TextField(
                  controller: _categoriaController,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? nome = _nameController.text;
                    final double? preco =
                        double.tryParse(_priceController.text);
                    final String? categoria = _categoriaController.text;
                    if (nome != null && preco != null) {
                      if (action == 'create') {
                        // Persistencias dos campos na BD
                        await _productss.add({
                          "nome": nome,
                          "preco": preco,
                          "categoria": categoria
                        });
                      }

                      if (action == 'update') {
                        // Actualizacao dos campos
                        await _productss.doc(documentSnapshot!.id).update({
                          "nome": nome,
                          "preco": preco,
                          "categoria": categoria
                        });
                      }

                      // Inicialiacao dos campos
                      _nameController.text = '';
                      _priceController.text = '';
                      _categoriaController.text = "";

                      //Ocultar a folha inferior
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  // Deleteing a product by id
  Future<void> _deleteProduct(String productId) async {
    await _productss.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto Eliminado com sucesso')));
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Produtos'),
      ),
      // Usando o StreamBuilder para exibir todos os produtos do Firestore em tempo real
      body: StreamBuilder(
        stream: _productss.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['nome']),
                    subtitle: Text(documentSnapshot['preco'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Pressione este botão para editar um único produto
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          // Este botão ícone é usado para excluir um único produto
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Add new product
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
