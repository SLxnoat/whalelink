import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class SubmitSightingScreen extends StatefulWidget {
  const SubmitSightingScreen({super.key});

  @override
  State<SubmitSightingScreen> createState() => _SubmitSightingScreenState();
}

class _SubmitSightingScreenState extends State<SubmitSightingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Form Data
  String? _selectedSpecies;
  int _individualCount = 1;
  String? _notes;
  // Placeholder for photos and location
  bool _locationCaptured = false;
  double? _latitude;
  double? _longitude;

  final List<String> _speciesList = [
    'Blue Whale',
    'Sperm Whale',
    'Humpback Whale',
    'Bryde\'s Whale',
    'Killer Whale',
    'Unknown',
  ];

  void _nextStep() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      _submitSighting();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void _submitSighting() {
    // TODO: Implement submission logic
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Sighting Submitted!'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 64),
            SizedBox(height: 16),
            Text('Thank you for your contribution to marine conservation.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to home
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Sighting'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          LinearProgressIndicator(
            value: (_currentStep + 1) / 4,
            backgroundColor: AppColors.gray200,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildSpeciesStep(),
                _buildPhotoStep(),
                _buildLocationStep(),
                _buildDetailsStep(),
              ],
            ),
          ),
          // Bottom Navigation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.gray300),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _selectedSpecies == null && _currentStep == 0
                        ? null
                        : _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      _currentStep == 3 ? 'Submit Report' : 'Next',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeciesStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Species', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text('What kind of whale did you see?', style: AppTextStyles.body),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _speciesList.length,
            itemBuilder: (context, index) {
              final species = _speciesList[index];
              final isSelected = _selectedSpecies == species;
              return InkWell(
                onTap: () => setState(() => _selectedSpecies = species),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.gray200,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.water, // Placeholder icon
                        size: 48,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.gray400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        species,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.gray700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Add Photos', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text('Help us verify your sighting', style: AppTextStyles.body),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPhotoOption(Icons.camera_alt, 'Camera', () {}),
              _buildPhotoOption(Icons.photo_library, 'Gallery', () {}),
            ],
          ),
          const SizedBox(height: 48),
          TextButton(onPressed: _nextStep, child: const Text('Skip this step')),
        ],
      ),
    );
  }

  Widget _buildPhotoOption(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.gray100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 12),
        Text(label, style: AppTextStyles.body),
      ],
    );
  }

  Widget _buildLocationStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Location', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text('Where did you see it?', style: AppTextStyles.body),
          const SizedBox(height: 32),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(Icons.map, size: 64, color: AppColors.gray400),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _locationCaptured = true;
                _latitude = 5.9549; // Example: Mirissa
                _longitude = 80.4550;
              });
            },
            icon: const Icon(Icons.my_location),
            label: const Text('Use Current Location'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          if (_locationCaptured) ...[
            const SizedBox(height: 16),
            Text(
              'Lat: $_latitude, Long: $_longitude',
              style: AppTextStyles.caption.copyWith(color: AppColors.success),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Final Details', style: AppTextStyles.h2),
          const SizedBox(height: 24),
          Text('Number of Individuals', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (_individualCount > 1) setState(() => _individualCount--);
                },
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.gray300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_individualCount',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (_individualCount < 100)
                    setState(() => _individualCount++);
                },
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Notes', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Describe behavior, direction of travel, etc.',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) => _notes = value,
          ),
        ],
      ),
    );
  }
}
