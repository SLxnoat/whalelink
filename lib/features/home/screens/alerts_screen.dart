import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Risk Alerts')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          final isHighRisk = index == 0;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: isHighRisk
                ? AppColors.warning.withOpacity(0.05)
                : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isHighRisk ? AppColors.warning : AppColors.gray200,
              ),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isHighRisk
                      ? AppColors.warning.withOpacity(0.1)
                      : AppColors.gray100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isHighRisk ? Icons.warning_amber_rounded : Icons.info_outline,
                  color: isHighRisk ? AppColors.warning : AppColors.gray600,
                ),
              ),
              title: Text(
                isHighRisk ? 'High Collision Risk' : 'General Advisory',
                style: AppTextStyles.h3.copyWith(fontSize: 16),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    isHighRisk
                        ? 'High probability of ship strikes in Zone A.'
                        : 'Increased whale activity reported near Mirissa.',
                    style: AppTextStyles.body.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text('20 mins ago', style: AppTextStyles.caption),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
