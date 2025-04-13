import 'package:flutter/material.dart';

class Service {
  final String name;
  final IconData icon;

  Service({required this.name, required this.icon});
}

final List<Service> serviceList = [
  Service(name: "Cleaning", icon: Icons.cleaning_services),
  Service(name: "Handyman", icon: Icons.handyman),
  Service(name: "Plumbing", icon: Icons.plumbing),
  Service(name: "Delivery", icon: Icons.local_shipping),
  Service(name: "Assembly", icon: Icons.chair_alt),
  Service(name: "Moving", icon: Icons.move_to_inbox),
  Service(name: "More", icon: Icons.more_horiz),
];
