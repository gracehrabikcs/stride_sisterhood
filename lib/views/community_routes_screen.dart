import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stride_sisterhood/models/route_model.dart';
import 'package:stride_sisterhood/viewmodels/route_viewmodel.dart';

class CommunityRoutesScreen extends StatelessWidget {
  const CommunityRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RouteViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Routes'),
      ),
      body: StreamBuilder<List<CommunityRoute>>(
        stream: viewModel.routesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No community routes available yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final routes = snapshot.data!;
          return ListView.builder(
            itemCount: routes.length,
            itemBuilder: (context, index) {
              final route = routes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        route.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        route.description,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chip(
                            label: Text('${route.distance.toStringAsFixed(1)} km'),
                            backgroundColor: Colors.blue[100],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.favorite, color: Colors.pink[300]),
                                onPressed: () {
                                  viewModel.likeRoute(route.routeId!, route.likes);
                                },
                              ),
                              Text(route.likes.toString()),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
