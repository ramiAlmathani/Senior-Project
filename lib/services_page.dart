import 'package:flutter/material.dart';
import 'package:senior_project/service_model.dart';
import 'package:senior_project/service_providers_page.dart';

// --------------------- SERVICE MODEL ---------------------
// --------------------- SERVICE MODEL ---------------------
import 'package:flutter/material.dart';

final List<Service> serviceList = [
  Service(name: "Cleaning", icon: Icons.cleaning_services),
  Service(name: "Handyman", icon: Icons.handyman),
  Service(name: "Plumbing", icon: Icons.plumbing),
  Service(name: "Delivery", icon: Icons.local_shipping),
  Service(name: "Assembly", icon: Icons.chair_alt),
  Service(name: "Moving", icon: Icons.move_to_inbox),
  Service(name: "More", icon: Icons.more_horiz),
];

// --------------------- SERVICES PAGE ---------------------
class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Services"),
        backgroundColor: const Color(0xFF007EA7),
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: serviceList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final service = serviceList[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ServiceProvidersPage(service: service),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(service.icon, size: 36, color: const Color(0xFF007EA7)),
                  const SizedBox(height: 8),
                  Text(
                    service.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
