import 'package:first_flutter_project/ui/pages/cart_page.dart';
import 'package:first_flutter_project/ui/pages/detail_page.dart';
import 'package:first_flutter_project/ui/pages/list_product_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Configuration des routes
  final router = GoRouter(
    routes: [
      // Route principale : Liste des produits
      GoRoute(
        path: "/",
        builder: (_, __) => ListProductPage(),
      ),

      // Route pour afficher les détails d'un produit via son ID
      GoRoute(
        name: "detail",
        path: "/detail/:idProduct",
        builder: (context, state) {
          // Récupérer l'ID du produit depuis les paramètres
          final idProduct = state.pathParameters['idProduct']!;
          return DetailPage(productId: idProduct);
        },
      ),

      // Route pour le panier
      GoRoute(
        name: "cart",
        path: "/cart",
        builder: (_, __) => const PanierPage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
