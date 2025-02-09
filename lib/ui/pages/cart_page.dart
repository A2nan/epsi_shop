import 'package:first_flutter_project/bo/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PanierPage extends StatelessWidget {
  const PanierPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Votre panier'),
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('Votre panier est vide.'))
          : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, index) {
                final product = cart.items[index];
                return ListTile(
                  leading: Image.network(
                    product.image,
                    width: 90,
                    height: 90,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                          Icons.error); // Image par défaut en cas d'erreur
                    },
                  ),
                  title: Text(product.title),
                  subtitle: Text(product.getPrice()),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      context.read<Cart>().removeFromCart(product);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            // possible envoie de la requête vers https://ptsv3.com/t/EPSISHOPC2/
          },
          child: Text('Total : ${cart.totalPrice.toStringAsFixed(2)}€'),
        ),
      ),
    );
  }
}
