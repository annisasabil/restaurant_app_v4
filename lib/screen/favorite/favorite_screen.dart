import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurants_app/provider/favorite/local_database_provider.dart';
import 'package:restaurants_app/screen/home/restaurants_card_widget.dart';
import 'package:restaurants_app/static/nav_route.dart';

class FavoriteScreen extends StatefulWidget{
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<LocalDatabaseProvider>();
      provider.loadAllRestaurantsValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite List")),
      body: Consumer<LocalDatabaseProvider>(
        builder: (context, provider, child) {
          final favoriteList = provider.restaurantsList ?? [];

          if (favoriteList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  Text(
                    "No Favorited",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: favoriteList.length,
            itemBuilder: (context, index) {
              final restaurants = favoriteList[index];
              return RestaurantsCardWidget(
                restaurants: restaurants,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    NavRoute.detailRoute.name,
                    arguments: restaurants.id,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}