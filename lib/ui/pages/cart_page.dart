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
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section pour afficher le prix hors TVA, la TVA, et le prix TTC
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prix hors TVA : ${cart.totalPrice.toStringAsFixed(2)}€',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'TVA (20%) : ${cart.tvaHorsTaxes.toStringAsFixed(2)}€',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Prix TTC : ${cart.totalPriceAvecTva.toStringAsFixed(2)}€',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Liste des produits
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, index) {
                      final product = cart.items[index];
                      return ListTile(
                        leading: Image.network(
                          product.image,
                          width: 90,
                          height: 90,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
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
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: cart.items.isEmpty
              ? null // Désactiver si le panier est vide
              : () {
                  // Envoi de la requête vers l'API
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Paiement en cours...')),
                  );

                  // Vider le panier après le paiement
                  context.read<Cart>().clearCart();
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: cart.items.isEmpty
                ? Colors.grey // Couleur grise si désactivé
                : Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white, // Couleur du texte
            disabledForegroundColor: Colors.white54, // Texte grisé si désactivé
          ),
          child: const Text('Procéder au paiement'),
        ),
      ),
    );
  }
}
