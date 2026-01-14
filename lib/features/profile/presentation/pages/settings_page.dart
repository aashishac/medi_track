import 'package:flutter/material.dart';
import 'package:meditrack/features/auth/presentation/providers/auth_provider.dart';
import 'package:meditrack/features/home/presentation/pages/home_page.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool pushNotifications = false;
  bool darkMode = false;

  _SettingsPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: Icon(Icons.arrow_back),
        ),

        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchBar(),
            const SizedBox(height: 24),

            _sectionTitle("ACCOUNT"),
            _card(
              children: [
                _navTile(
                  icon: Icons.person,
                  iconBg: Colors.blue.shade50,
                  iconColor: Colors.blue,
                  title: "Profile Information",
                  subtitle:
                      "Dr. ${context.watch<AuthProvider>().userName ?? "Guest"}",
                  onTap: () {},
                ),

                _navTile(
                  icon: Icons.business,
                  iconBg: Colors.green.shade50,
                  iconColor: Colors.green,
                  title: "Organization Details",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),
            _sectionTitle("PREFERENCES"),
            _card(
              children: [
                _switchTile(
                  icon: Icons.notifications,
                  iconBg: Colors.red.shade50,
                  iconColor: Colors.red,
                  title: "Push Notifications",
                  value: pushNotifications,
                  onChanged: (v) => setState(() => pushNotifications = v),
                ),

                _switchTile(
                  icon: Icons.dark_mode,
                  iconBg: Colors.grey.shade200,
                  iconColor: Colors.grey.shade700,
                  title: "Dark Mode",
                  value: darkMode,
                  onChanged: (v) => setState(() => darkMode = v),
                ),
              ],
            ),

            const SizedBox(height: 24),
            _sectionTitle("SECURITY"),
            _card(
              children: [
                _navTile(
                  icon: Icons.lock,
                  iconBg: Colors.green.shade50,
                  iconColor: Colors.green,
                  title: "Change Password",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),
            _sectionTitle("LEGAL & ABOUT"),
            _card(
              children: [
                _navTile(
                  icon: Icons.privacy_tip,
                  iconBg: Colors.orange.shade50,
                  iconColor: Colors.orange,
                  title: "Privacy Policy",
                  onTap: () {},
                ),

                _navTile(
                  icon: Icons.description,
                  iconBg: Colors.orange.shade50,
                  iconColor: Colors.orange,
                  title: "Terms of Service",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 32),
            Center(
              child: Text(
                "HealCheck CRM v1.0.2",
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- SEARCH BAR ----------------
  Widget _searchBar() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: const [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search settings",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- SECTION TITLE ----------------
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // ---------------- CARD ----------------
  Widget _card({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),
      child: Column(children: children),
    );
  }

  // ---------------- NAV TILE ----------------
  Widget _navTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: iconBg,
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
    );
  }

  // ---------------- SWITCH TILE ----------------
  Widget _switchTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconBg,
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title),
      trailing: Switch(
        value: value,
        activeColor: Colors.blue,
        onChanged: onChanged,
      ),
    );
  }
}
