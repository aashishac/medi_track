import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditrack/features/auth/presentation/pages/login_page.dart';
import 'package:meditrack/features/auth/presentation/providers/auth_provider.dart';
import 'package:meditrack/core/responsive/responsive_helper.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    if (kIsWeb) {
      final bytes = await image.readAsBytes();
      context.read<AuthProvider>().setProfileImage(bytes: bytes);
    } else {
      context.read<AuthProvider>().setProfileImage(path: image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    //final isMobile = ResponsiveHelper.isMobile(context);

    final maxWidth = ResponsiveHelper.getResponsiveValue<double>(
      context: context,
      mobile: double.infinity,
      tablet: 720,
    );

    final horizontalPadding = ResponsiveHelper.getResponsiveValue<double>(
      context: context,
      mobile: 20,
      tablet: 48,
    );

    final sectionSpacing = ResponsiveHelper.getResponsiveValue<double>(
      context: context,
      mobile: 20,
      tablet: 28,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    _profileHeader(context),
                    SizedBox(height: sectionSpacing),
                    _contactInfoCard(context),
                    SizedBox(height: sectionSpacing),
                    _accountSettingsCard(),
                    SizedBox(height: sectionSpacing),
                    _logoutButton(context),
                    const SizedBox(height: 16),
                    const Text(
                      "Version 2.4.0 (Build 302)",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- PROFILE HEADER ----------------
  Widget _profileHeader(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: kIsWeb
                  ? (auth.profileImageBytes != null
                        ? MemoryImage(auth.profileImageBytes!)
                        : const AssetImage('assets/profileimg.png'))
                  : (auth.profileImagePath != null
                            ? FileImage(File(auth.profileImagePath!))
                            : const AssetImage('assets/profileimg.png'))
                        as ImageProvider,
            ),

            Positioned(
              bottom: 2,
              right: 2,
              child: GestureDetector(
                onTap: () => _pickImage(context),
                child: CircleAvatar(
                  radius: ResponsiveHelper.getResponsiveValue(
                    context: context,
                    mobile: 16,
                    tablet: 18,
                  ),
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          "Dr. ${auth.userName ?? "Guest"}",
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveValue(
              context: context,
              mobile: 20,
              tablet: 22,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _roleChip(
              label: auth.doctor?.department ?? "Not assigned",
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

  // ---------------- CONTACT INFO ----------------
  Widget _contactInfoCard(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return _sectionCard(
      title: "CONTACT INFORMATION",
      icon: Icons.badge,
      children: [
        _InfoTile(
          icon: Icons.email,
          iconColor: Colors.blue,
          label: "Email Address",
          value: auth.userEmail ?? "Not available",
        ),
        _InfoTile(
          icon: Icons.phone,
          iconColor: Colors.green,
          label: "Phone Number",
          value: auth.doctor?.phone ?? "Not available",
        ),
        _InfoTile(
          icon: Icons.perm_identity,
          iconColor: Colors.purple,
          label: "Employee ID",
          value: auth.doctor?.doctorId ?? "Not available",
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

  // ---------------- LOGOUT ----------------
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
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
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
