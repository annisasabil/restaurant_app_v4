import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurants_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurants_app/provider/favorite/favorite_icon_provider.dart';
import 'package:restaurants_app/screen/detail/body_detail_screen.dart';
import 'package:restaurants_app/screen/favorite/favorite_icon_widget.dart';
import 'package:restaurants_app/static/restaurant_detail_result_state.dart';

class DetailScreen extends StatefulWidget{
  final String restaurantId;

  const DetailScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>{
  @override
  void initState(){
    super.initState();
    Future.microtask(() {
      context
          .read<RestaurantDetailProvider>()
          .fetchRestaurantDetail(widget.restaurantId);  
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurant Detail",
        style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          ChangeNotifierProvider(
            create: (context) => FavoriteIconProvider(),
            child: Consumer<RestaurantDetailProvider>(
              builder: (context, value, child){
                return switch(value.resultState){
                  RestaurantDetailLoadedState(data: var restaurant) =>
                    FavoriteIconWidget(restaurant: restaurant),
                  _ => const SizedBox(),
                };
              },
            ),
          ),
        ],
      ),
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, value, child){
          final state = value.resultState;

          if(state is RestaurantDetailLoadingState){
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
                strokeWidth: 3,
              ),
            );
          } else if(state is RestaurantDetailLoadedState){
            return BodyDetailScreen(restaurant: state.data);
          } else if(state is RestaurantDetailErrorState){
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Oops! Detail is unavailable",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Please check your internet connection.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}