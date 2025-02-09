import 'dart:convert';
import 'package:first_flutter_project/bo/cart.dart';
import 'package:first_flutter_project/bo/product.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  final String productId;

  DetailPage({required this.productId, super.key});

  // Récupérer les détails d'un produit spécifique via son ID
  Future<Product> getProductDetails(String productId) async {
    final response = await get(Uri.parse('https://fakestoreapi.com/products/$productId'));
    if (response.statusCode == 200) {
      final productMap = jsonDecode(response.body);
      return Product.fromMap(productMap);
    } else {
      throw Exception('Failed to load product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Détails du produit'),
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
      body: FutureBuilder<Product>(
        future: getProductDetails(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final product = snapshot.data!;
            return Column(
              children: [
                Image.network(
                  product.image,
                  height: 200,
                ),
                TitlePrice(product: product),
                Description(product: product),
                const Spacer(),
                AddCartButton(product: product),
              ],
            );
          } else {
            return const Center(child: Text('Produit introuvable'));
          }
        },
      ),
    );
  }
}

class AddCartButton extends StatelessWidget {
  final Product product;

  const AddCartButton({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () {
            context.read<Cart>().addToCart(product);

            // Affiche un message de confirmation
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${product.title} ajouté au panier !')),
            );
          },
          child: const Text('Ajouter au panier'),
        ),
      ),
    );
  }
}

class Description extends StatelessWidget {
  const Description({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        product.description,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class TitlePrice extends StatelessWidget {
  const TitlePrice({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            product.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            product.getPrice(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
