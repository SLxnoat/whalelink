import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/sighting_model.dart';

class MySightingsScreen extends StatelessWidget {
  const MySightingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<SightingModel> sightings = [
      SightingModel(
        id: '1',
        species: 'Blue Whale',
        count: 2,
        latitude: 5.9,
        longitude: 80.5,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        status: 'verified',
      ),
      SightingModel(
        id: '2',
        species: 'Sperm Whale',
        count: 1,
        latitude: 6.0,
        longitude: 80.2,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        status: 'pending',
      ),
      SightingModel(
        id: '3',
        species: 'Unknown',
        count: 1,
        latitude: 5.8,
        longitude: 80.6,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        status: 'rejected',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sightings'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sightings.length,
        itemBuilder: (context, index) {
          final sighting = sightings[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.gray200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        sighting.species,
                        style: AppTextStyles.h3.copyWith(fontSize: 18),
                      ),
                      _buildStatusBadge(sighting.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppColors.gray500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${sighting.timestamp.day}/${sighting.timestamp.month}/${sighting.timestamp.year}',
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.gray500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${sighting.latitude.toStringAsFixed(2)}, ${sighting.longitude.toStringAsFixed(2)}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${sighting.count} Individual(s)',
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'verified':
        color = AppColors.success;
        label = 'Verified';
        break;
      case 'rejected':
        color = AppColors.error;
        label = 'Rejected';
        break;
      default:
        color = AppColors.warning;
        label = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
