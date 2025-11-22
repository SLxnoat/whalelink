import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_colors.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Placeholder for Google Map Controller
  // GoogleMapController? _controller;

  static const CameraPosition _kSriLanka = CameraPosition(
    target: LatLng(6.9271, 79.8612), // Colombo
    zoom: 8.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Placeholder (Since we don't have an API key configured yet)
          Container(
            color: AppColors.gray100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 80, color: AppColors.gray300),
                  const SizedBox(height: 16),
                  Text(
                    'Interactive Map',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Map integration requires API Key',
                    style: TextStyle(color: AppColors.gray400),
                  ),
                ],
              ),
            ),
          ),

          // Floating Action Buttons
          Positioned(
            right: 16,
            bottom: 100,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'layers',
                  onPressed: () {},
                  mini: true,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.layers, color: AppColors.secondary),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'location',
                  onPressed: () {},
                  mini: true,
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.my_location,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.gray500),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search location...',
                      style: TextStyle(color: AppColors.gray400),
                    ),
                  ),
                  const Icon(Icons.filter_list, color: AppColors.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
