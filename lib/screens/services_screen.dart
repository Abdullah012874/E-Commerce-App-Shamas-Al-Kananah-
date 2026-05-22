import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Services'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          _ServiceCard(
            title: 'Solar Installation',
            icon: Icons.solar_power,
            description: 'Professional solar panel installation for homes and businesses.',
          ),
          SizedBox(height: 16),
          _ServiceCard(
            title: 'Electricity Services',
            icon: Icons.electrical_services,
            description: 'Full range of electrical wiring and maintenance.',
          ),
          SizedBox(height: 16),
          _ServiceCard(
            title: 'Plumbing Services',
            icon: Icons.plumbing,
            description: 'Expert plumbing repairs, pipe fitting, and more.',
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;

  const _ServiceCard({required this.title, required this.icon, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: AppColors.card,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 48, color: AppColors.accent),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 8),
                  Text(description, style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
