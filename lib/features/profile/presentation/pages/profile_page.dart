import 'package:flutter/material.dart';
import 'package:meditrack/features/auth/presentation/pages/login_page.dart';
import 'package:meditrack/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      context.read<AuthProvider>().setProfileImage(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _profileHeader(context),
            const SizedBox(height: 24),
            _contactInfoCard(context),
            const SizedBox(height: 24),
            _accountSettingsCard(),
            const SizedBox(height: 24),
            _logoutButton(context),
            const SizedBox(height: 16),
            const Text(
              "Version 2.4.0 (Build 302)",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- PROFILE HEADER ----------------
  Widget _profileHeader(BuildContext context) {
    final imagePath = context.watch<AuthProvider>().profileImagePath;
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: imagePath != null
                  ? FileImage(File(imagePath))
                  : const AssetImage("assets/profileimg.png"),
            ),
            Positioned(
              bottom: 0,
              right: 4,
              child: GestureDetector(
                onTap: () => _pickImage(context),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.camera_alt, size: 18, color: Colors.blue),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        Text(
          "Dr. ${context.watch<AuthProvider>().userName ?? "Guest"}",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _roleChip(
              label:
                  context.watch<AuthProvider>().doctor?.department ??
                  "Not assigned",
              color: Colors.blue.shade50,
              textColor: Colors.blue,
            ),
            const SizedBox(width: 8),
            _roleChip(
              label: "Administrator",
              color: Colors.green.shade50,
              textColor: Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _roleChip({
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Chip(
      label: Text(label, style: TextStyle(color: textColor)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 12),
    );
  }

  // ---------------- CONTACT INFO CARD ----------------
  Widget _contactInfoCard(BuildContext context) {
    return _sectionCard(
      title: "CONTACT INFORMATION",
      icon: Icons.badge,
      children: [
        _InfoTile(
          icon: Icons.email,
          iconColor: Colors.blue,
          label: "Email Address",
          value: context.watch<AuthProvider>().userEmail ?? "Not available",
        ),

        _InfoTile(
          icon: Icons.phone,
          iconColor: Colors.green,
          label: "Phone Number",
          value: context.watch<AuthProvider>().doctor?.phone ?? "Not available",
        ),

        _InfoTile(
          icon: Icons.perm_identity,
          iconColor: Colors.purple,
          label: "Employee ID",
          value:
              context.watch<AuthProvider>().doctor?.doctorId ?? "Not available",
        ),
      ],
    );
  }

  // ---------------- ACCOUNT SETTINGS ----------------
  Widget _accountSettingsCard() {
    return _sectionCard(
      title: "ACCOUNT SETTINGS",
      icon: Icons.settings,
      children: [
        _SettingsTile(
          icon: Icons.edit,
          title: "Edit Profile Details",
          onTap: () {},
        ),

        _SettingsTile(
          icon: Icons.lock_outline,
          title: "Change Password",
          onTap: () {},
        ),
      ],
    );
  }

  // ---------------- LOGOUT BUTTON ----------------
  Widget _logoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Log Out"),
              content: const Text("Are you sure you want to log out?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthProvider>().logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    ); // close dialog
                  },
                  child: const Text(
                    "Log Out",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
        child: const Text(
          "Log Out",
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ---------------- SECTION CARD ----------------
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

// ---------------- INFO TILE ----------------
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.15),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(label, style: const TextStyle(color: Colors.grey)),
      subtitle: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      trailing: const Icon(Icons.copy, size: 18, color: Colors.grey),
    );
  }
}

// ---------------- SETTINGS TILE ----------------
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey.shade700),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
