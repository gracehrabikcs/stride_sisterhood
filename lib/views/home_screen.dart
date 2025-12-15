import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:stride_sisterhood/viewmodels/user_viewmodel.dart';
import 'package:stride_sisterhood/views/edit_profile_screen.dart';
import 'package:stride_sisterhood/views/login_screen.dart';
import 'package:stride_sisterhood/views/log_run_screen.dart';
import 'package:stride_sisterhood/views/run_history_screen.dart';
import 'package:stride_sisterhood/views/community_routes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stride Sisterhood')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ProfileCard(),
            SizedBox(height: 24),
            FeatureSection(),
          ],
        ),
      ),
    );
  }
}

/* ============================
   PROFILE CARD
   ============================ */

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserViewModel>().user;

    if (user == null) return const SizedBox();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text("Pace: ${user.paceRange}"),
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                  },
                  child: const Text("Edit Profile"),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    context.read<UserViewModel>().signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                          (_) => false,
                    );
                  },
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================
   FEATURE SECTION
   ============================ */

class FeatureSection extends StatelessWidget {
  const FeatureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FeatureCard(
          icon: Icons.add_circle_outline,
          title: "Log a New Run",
          subtitle: "Keep track of your progress.",
          color: Colors.pink[100]!,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LogRunScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        FeatureCard(
          icon: Icons.history,
          title: "View Your History",
          subtitle: "See how far you've come.",
          color: Colors.blue[100]!,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const RunHistoryScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        FeatureCard(
          icon: Icons.map,
          title: "Explore Routes",
          subtitle: "Find new paths shared by the community.",
          color: Colors.green[100]!,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CommunityRoutesScreen(), // ✅ no const
              ),
            );
          },
        ),
      ],
    );
  }
}


/* ============================
   FEATURE CARD WIDGET
   ============================ */

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 24,
                child: Icon(icon, color: Colors.black54, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
