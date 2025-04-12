import 'package:flutter/material.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black54,
        indicator: BoxDecoration(
          color: const Color(0xFF007EA7),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        tabs: [
          Tab(text: "Pending"),
          Tab(text: "History"),
        ],
      ),
    );
  }
}
