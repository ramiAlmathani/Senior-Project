import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:senior_project/service_model.dart';
import 'package:senior_project/service_providers_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? '';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FadeTransition(
        opacity: _fadeIn,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // ✅ Greeting message
              if (_userName != null && _userName!.isNotEmpty)
                Text(
                  "Hello, $_userName 👋",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF007EA7),
                  ),
                ),

              const SizedBox(height: 16),

              TextField(
                decoration: InputDecoration(
                  hintText: "What do you need help with?",
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF007EA7)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Available Services",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  itemCount: serviceList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return ServiceTile(service: serviceList[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF007EA7),
        onPressed: () {
          Navigator.pushNamed(context, '/chatbot');
        },
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
    );
  }
}


// --------------------- SERVICE TILE ---------------------
class ServiceTile extends StatelessWidget {
  final Service service;
  const ServiceTile({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceProvidersPage(service: service),
            ),
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(service.icon, size: 36, color: const Color(0xFF007EA7)),
              const SizedBox(height: 8),
              Text(
                service.name,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------- SERVICE MODEL ---------------------

final List<Service> serviceList = [
  Service(name: "Cleaning", icon: Icons.cleaning_services),
  Service(name: "Handyman", icon: Icons.handyman),
  Service(name: "Plumbing", icon: Icons.plumbing),
  Service(name: "Delivery", icon: Icons.local_shipping),
  Service(name: "Assembly", icon: Icons.chair_alt),
  Service(name: "Moving", icon: Icons.move_to_inbox),
  Service(name: "More", icon: Icons.more_horiz),
];
