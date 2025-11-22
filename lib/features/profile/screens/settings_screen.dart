import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('General'),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive alerts about nearby whales'),
            value: _notificationsEnabled,
            activeColor: AppColors.primary,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
          ),
          SwitchListTile(
            title: const Text('Location Services'),
            subtitle: const Text('Allow app to access your location'),
            value: _locationEnabled,
            activeColor: AppColors.primary,
            onChanged: (value) => setState(() => _locationEnabled = value),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            activeColor: AppColors.primary,
            onChanged: (value) => setState(() => _darkMode = value),
          ),

          const Divider(height: 32),
          _buildSectionHeader('Map'),
          ListTile(
            title: const Text('Map Style'),
            subtitle: const Text('Satellite'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Offline Maps'),
            subtitle: const Text('Download maps for offline use'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          const Divider(height: 32),
          _buildSectionHeader('About'),
          ListTile(title: const Text('Version'), trailing: const Text('1.0.0')),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title,
        style: AppTextStyles.h3.copyWith(color: AppColors.primary),
      ),
    );
  }
}
