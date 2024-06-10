import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ProductosRealtimePage extends StatefulWidget {
  const ProductosRealtimePage({super.key});

  @override
  State<ProductosRealtimePage> createState() => _ProductosRealtimePageState();
}

class _ProductosRealtimePageState extends State<ProductosRealtimePage> {
  TextEditingController nameProductController = TextEditingController();
  TextEditingController priceProductController = TextEditingController();
  List<Map> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  final DatabaseReference _productosRef =
      FirebaseDatabase.instance.ref().child('productos');

  Future<void> addProduct() async {
    String name = nameProductController.text;
    double price = double.parse(priceProductController.text);

    await _productosRef.push().set({
      'name': name,
      'price': price,
    });

    nameProductController.clear();
    priceProductController.clear();
  }

  Future<void> loadProducts() async {
    _productosRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> productsMap =
            event.snapshot.value as Map<dynamic, dynamic>;
        List<Map> productList = productsMap.entries
            .map((e) => {
                  'key': e.key,
                  'name': e.value['name'],
                  'price': e.value['price'],
                })
            .toList();
        setState(() {
          products = productList;
        });
      }
    });
  }

  Future<void> deleteProduct(String key) async {
    await _productosRef.child(key).remove();
  }

  Future<void> updateProduct(String key) async {
    String name = nameProductController.text;
    double price = double.parse(priceProductController.text);

    await _productosRef.child(key).update({
      'name': name,
      'price': price,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos Realtime'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: nameProductController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del producto',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: priceProductController,
                decoration: const InputDecoration(
                  labelText: 'Precio del producto',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: addProduct,
                child: const Text('Agregar producto'),
              ),
              const SizedBox(height: 20),
              const Text('Productos'),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(products[index]['name']),
                      subtitle: Text(products[index]['price'].toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              nameProductController.text = products[index]['name'];
                              priceProductController.text = products[index]['price'].toString();
                              // updateProduct(products[index]['key']);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                deleteProduct(products[index]['key']),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: products.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
