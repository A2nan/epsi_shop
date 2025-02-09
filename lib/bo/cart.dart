import 'package:flutter/material.dart';
import '../bo/product.dart';

class Cart with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  // Nouvelle méthode `getAll()`
  List<Product> getAll() {
    return _items;
  }

  int get itemCount => _items.length;

  void addToCart(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  // Méthode pour vider le panier
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
  
  // Montant de la TVA (20% du prix hors taxes)
  double get tvaHorsTaxes {
    return totalPrice * 0.20;
  }

    // Total sans TVA
  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.price);
  }

  // Total avec 20% de TVA
  double get totalPriceAvecTva {
    return totalPrice * 1.20;
  }
}
