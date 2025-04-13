import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Widget _buildDrawerItem(BuildContext context, IconData icon, String text,
      {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      child: Material(
        color: Colors.transparent,
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        shadowColor: Colors.black12,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap ?? () => Navigator.of(context).pop(),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              child: Row(
                children: [
                  Icon(icon, color: const Color(0xFF007EA7)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ---------- Drawer Header ----------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB2DFDB), Color(0xFF007EA7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(topRight: Radius.circular(25)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child:
                        Icon(Icons.person, size: 30, color: Color(0xFF007EA7)),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      "Mafi Mushkil",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- Drawer Items ----------
            _buildDrawerItem(context, Icons.person_outline, "My Profile"),
            const SizedBox(height: 8),
            _buildDrawerItem(context, Icons.mail_outline, "Contact us"),
            const SizedBox(height: 8),
            _buildDrawerItem(context, Icons.engineering, "Become a worker"),
            const SizedBox(height: 8),
            _buildDrawerItem(context, Icons.apartment, "Register a company"),
            const SizedBox(height: 8),
            const Divider(thickness: 1, indent: 16, endIndent: 16),
            const SizedBox(height: 8),
            _buildDrawerItem(context, Icons.share_outlined, "Share"),
            const SizedBox(height: 8),
            _buildDrawerItem(context, Icons.star_border, "Rate"),
            const SizedBox(height: 8),
            _buildDrawerItem(context, Icons.logout, "Logout"),

            const Spacer(),

            // ---------- Footer ----------
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
