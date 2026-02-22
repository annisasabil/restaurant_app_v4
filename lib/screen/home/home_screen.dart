import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurants_app/provider/home/restaurants_list_provider.dart';
import 'package:restaurants_app/screen/home/restaurants_card_widget.dart';
import 'package:restaurants_app/static/nav_route.dart';
import 'package:restaurants_app/static/restaurant_list_result_state.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState(){
    super.initState();
    Future.microtask(() {
      context.read<RestaurantsListProvider>().fetchRestaurantsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Restaurant",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              "Recommendation for you!",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
          ],
          
        ),
      ),
      body: Consumer<RestaurantsListProvider>(
        builder: (context, value, child){
          final state = value.resultState;

          if(state is RestaurantsListLoadingState){
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
                strokeWidth: 3,
              ),
            );
          } else if (state is RestaurantsListLoadedState){
              final restaurantList = state.data;
              return ListView.builder(
              itemCount: restaurantList.length,
              itemBuilder: (context, index) {
                  final restaurants = restaurantList[index];

                  return RestaurantsCardWidget(
                    restaurants: restaurants, 
                    onTap: () {
                      Navigator.pushNamed(
                        context, 
                        NavRoute.detailRoute.name,
                        arguments: restaurants.id
                        );
                      },
                    );
                  },
                );
          } else if(state is RestaurantsListErrorState){
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      "Oops! Data is unavailable ", 
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Please check your internet connection.",
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
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