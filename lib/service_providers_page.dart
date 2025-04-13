import 'package:flutter/material.dart';
import 'package:senior_project/service_model.dart'; // ✅ shared Service model
import 'package:senior_project/service_providers_page.dart';

class ServiceProvidersPage extends StatelessWidget {
  final Service service;

  const ServiceProvidersPage({Key? key, required this.service})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> providerMap = {
      "Cleaning": ["SparkleClean", "Maid in Minutes", "ShinySpaces"],
      "Handyman": ["FixIt All", "HandyPro Services", "DIY Dude"],
      "Plumbing": ["AquaFix", "PipePros", "FlowMaster Plumbing"],
      "Delivery": ["QuickDrop", "LocalRunner", "SwiftShip"],
      "Assembly": ["FurnitureFast", "AssemblyCo", "SetUp Squad"],
      "Moving": ["MoveMate", "Lift & Go", "PackRight Movers"],
      "More": ["General Helper", "Custom Service", "Request a Quote"],
    };

    final providers = providerMap[service.name] ?? ["No providers found"];

    return Scaffold(
      appBar: AppBar(
        title: Text('${service.name} Providers'),
        backgroundColor: const Color(0xFF007EA7),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: providers.length,
        itemBuilder: (context, index) {
          final provider = providers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(provider),
              subtitle: const Text('Tap for more details'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tapped on $provider')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
