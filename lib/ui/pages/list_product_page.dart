import 'dart:convert';

import 'package:first_flutter_project/bo/cart.dart';
import 'package:first_flutter_project/bo/product.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class ListProductPage extends StatelessWidget {
  ListProductPage({super.key});

  Future<List<Product>> getProducts() async {
    Response res = await get(Uri.parse('https://fakestoreapi.com/products'));
    if (res.statusCode == 200) {
      List<dynamic> listMapProducts = jsonDecode(res.body);
      //convertir liste en liste de produits
      return listMapProducts.map((lm) => Product.fromMap(lm)).toList();
    }
    return Future.error('Erreur de chargement');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('EPSI Shop'),
        actions: [
          IconButton(
            onPressed: () => context.go("/cart/"),
            icon: Badge(
              label: Text(context.watch<Cart>().getAll().length.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final listProducts = snapshot.data!;
            return ListView.builder(
              itemCount: listProducts.length,
              itemBuilder: (ctx, index) {
                final product = listProducts[index];
                return InkWell(
                  onTap: () {
                    // Naviguer vers la page de détail
                    context.go("/detail/${product.id}");
                  },
                  child: ListTile(
                    leading:
                        Image.network(product.image, width: 90, height: 90),
                    title: Text(product.title),
                    subtitle: Text(product.getPrice()),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        context.read<Cart>().addToCart(product);

                        // Affiche un message de confirmation
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('${product.title} ajouté au panier !')),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Erreur de chargement'));
          }
        },
      ),
    );
  }
}
