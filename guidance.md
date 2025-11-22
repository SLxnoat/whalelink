# WhaleLink Mobile Application Development Guidance

## Overview

This document provides comprehensive guidance for developing the WhaleLink mobile application using Flutter. The mobile app is a critical component of the research platform, enabling community-driven whale sighting reports with GPS verification and camera integration.

---

## Project Context

**Research Focus:** AI-Driven Whale Detection and Ship-Strike Risk Mapping for Sri Lankan Waters

**Mobile App Purpose:**
- Enable whale-watching operators and fishing communities to submit GPS-tagged sighting reports
- Provide camera verification for submitted sightings
- Achieve 89% user satisfaction rate (research target)
- Contribute to 34% improvement in whale-watching tour success

---

## Technology Stack

### Core Framework
- **Flutter** (Latest Stable Version)
- **Dart** programming language
- Cross-platform (iOS & Android)

### Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.0
  riverpod: ^2.4.0
  
  # Networking
  http: ^1.1.0
  dio: ^5.4.0
  
  # Location Services
  geolocator: ^10.1.0
  location: ^5.0.0
  google_maps_flutter: ^2.5.0
  
  # Camera & Media
  camera: ^0.10.5
  image_picker: ^1.0.5
  image: ^4.1.3
  
  # Storage
  shared_preferences: ^2.2.2
  sqflite: ^2.3.0
  
  # UI Components
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.0
  
  # Authentication
  firebase_auth: ^4.15.0
  
  # Push Notifications
  firebase_messaging: ^14.7.0
```

---

## Design System

### Color Palette

```dart
class AppColors {
  // Primary Colors (from web app)
  static const Color primary = Color(0xFF1CBDC2);      // Cyan
  static const Color secondary = Color(0xFF151644);    // Navy
  static const Color background = Color(0xFFFFFFFF);   // White
  
  // Accent Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Neutral Colors
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);
}
```

### Typography

```dart
class AppTextStyles {
  static const String fontFamily = 'Inter';
  
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.secondary,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.secondary,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.secondary,
  );
  
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.gray700,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.gray500,
  );
}
```

---

## App Architecture

### Folder Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── api_endpoints.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── formatters.dart
│   │   └── helpers.dart
│   └── services/
│       ├── api_service.dart
│       ├── location_service.dart
│       ├── camera_service.dart
│       └── storage_service.dart
├── features/
│   ├── auth/
│   │   ├── models/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   ├── sightings/
│   │   ├── models/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   ├── map/
│   │   ├── models/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   └── profile/
│       ├── models/
│       ├── providers/
│       ├── screens/
│       └── widgets/
└── shared/
    ├── widgets/
    │   ├── buttons/
    │   ├── cards/
    │   ├── inputs/
    │   └── loading/
    └── models/
```

---

## Core Features

### 1. GPS-Tagged Sighting Submission

**Requirements:**
- Real-time GPS location capture
- Location accuracy validation (minimum 10m accuracy)
- Offline location caching
- Background location tracking (optional)

**Implementation Example:**

```dart
class LocationService {
  final Geolocator _geolocator = Geolocator();
  
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceDisabledException();
    }
    
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationPermissionDeniedException();
      }
    }
    
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
  
  Future<bool> isLocationAccurate(Position position) async {
    return position.accuracy <= 10.0; // 10 meters
  }
}
```

### 2. Camera Verification

**Requirements:**
- High-resolution photo capture
- Image compression (max 2MB)
- EXIF data preservation
- Multiple image support (up to 5 per sighting)

**Implementation Example:**

```dart
class CameraService {
  final ImagePicker _picker = ImagePicker();
  
  Future<File?> capturePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
    
    if (photo == null) return null;
    
    return File(photo.path);
  }
  
  Future<File> compressImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);
    
    if (image == null) throw ImageProcessingException();
    
    final compressed = img.encodeJpg(image, quality: 85);
    
    final compressedFile = File('${imageFile.path}_compressed.jpg');
    await compressedFile.writeAsBytes(compressed);
    
    return compressedFile;
  }
}
```

### 3. Sighting Report Form

**Fields:**
- Species selection (dropdown)
- Number of individuals (numeric input)
- Behavior observations (multi-select)
- Additional notes (text area)
- Photos (camera/gallery)
- GPS coordinates (auto-captured)
- Timestamp (auto-captured)

**Validation Rules:**
- Species: Required
- Number of individuals: Required, min 1, max 100
- GPS accuracy: Must be ≤ 10m
- Photos: At least 1 required
- Timestamp: Must be within last 24 hours

### 4. Offline Support

**Requirements:**
- Cache submitted reports locally
- Sync when connection is restored
- Queue management for pending uploads
- Conflict resolution

**Implementation Example:**

```dart
class OfflineService {
  final Database _db;
  
  Future<void> saveSightingLocally(Sighting sighting) async {
    await _db.insert(
      'pending_sightings',
      sighting.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<void> syncPendingSightings() async {
    final pendingSightings = await _db.query('pending_sightings');
    
    for (var sighting in pendingSightings) {
      try {
        await _apiService.submitSighting(Sighting.fromJson(sighting));
        await _db.delete(
          'pending_sightings',
          where: 'id = ?',
          whereArgs: [sighting['id']],
        );
      } catch (e) {
        // Keep in queue for next sync
        print('Failed to sync sighting: $e');
      }
    }
  }
}
```

---

## API Integration

### Base Configuration

```dart
class ApiService {
  static const String baseUrl = 'https://api.whalelink.lk';
  final Dio _dio;
  
  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));
  
  Future<Response> submitSighting(Sighting sighting) async {
    final formData = FormData.fromMap({
      'species': sighting.species,
      'count': sighting.count,
      'latitude': sighting.latitude,
      'longitude': sighting.longitude,
      'timestamp': sighting.timestamp.toIso8601String(),
      'notes': sighting.notes,
      'photos': await _preparePhotos(sighting.photos),
    });
    
    return await _dio.post('/api/sightings', data: formData);
  }
  
  Future<List<MultipartFile>> _preparePhotos(List<File> photos) async {
    return Future.wait(
      photos.map((photo) => MultipartFile.fromFile(photo.path))
    );
  }
}
```

### Endpoints

```dart
class ApiEndpoints {
  // Authentication
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String logout = '/api/auth/logout';
  
  // Sightings
  static const String submitSighting = '/api/sightings';
  static const String getMySightings = '/api/sightings/my';
  static const String getSightingById = '/api/sightings/{id}';
  
  // Species
  static const String getSpeciesList = '/api/species';
  
  // User Profile
  static const String getProfile = '/api/user/profile';
  static const String updateProfile = '/api/user/profile';
}
```

---

## UI/UX Guidelines

### Navigation Structure

```
Bottom Navigation:
├── Home (Dashboard)
├── Submit Sighting
├── My Sightings
└── Profile
```

### Screen Specifications

#### 1. Home Screen
- Welcome message
- Quick stats (total sightings, recent activity)
- Recent sightings feed
- Quick action button: "Report Sighting"

#### 2. Submit Sighting Screen
- Step-by-step wizard:
  1. Capture Location
  2. Take Photos
  3. Enter Details
  4. Review & Submit
- Progress indicator
- Save as draft option

#### 3. My Sightings Screen
- List view with filters
- Status badges (Pending, Verified, Rejected)
- Pull to refresh
- Infinite scroll

#### 4. Profile Screen
- User information
- Statistics
- Settings
- Logout

---

## Performance Optimization

### Image Optimization
- Compress images before upload
- Use cached_network_image for remote images
- Implement lazy loading for image lists

### Network Optimization
- Implement request caching
- Use pagination for lists
- Batch API requests where possible

### Battery Optimization
- Use location updates only when needed
- Implement background task limits
- Optimize camera usage

---

## Testing Strategy

### Unit Tests
```dart
test('Location accuracy validation', () {
  final position = Position(
    latitude: 6.9271,
    longitude: 79.8612,
    accuracy: 8.5,
    // ... other fields
  );
  
  expect(LocationService().isLocationAccurate(position), true);
});
```

### Widget Tests
```dart
testWidgets('Submit button is disabled when form is invalid', (tester) async {
  await tester.pumpWidget(MyApp());
  
  final submitButton = find.byKey(Key('submit_button'));
  expect(tester.widget<ElevatedButton>(submitButton).enabled, false);
});
```

### Integration Tests
- End-to-end sighting submission flow
- Offline sync functionality
- Camera capture and upload

---

## Deployment

### Android
1. Update `android/app/build.gradle`:
   - Set `minSdkVersion` to 21
   - Set `targetSdkVersion` to 34
   - Configure signing keys

2. Build release APK:
   ```bash
   flutter build apk --release
   ```

3. Build App Bundle:
   ```bash
   flutter build appbundle --release
   ```

### iOS
1. Update `ios/Runner/Info.plist`:
   - Add location permissions
   - Add camera permissions
   - Add photo library permissions

2. Build release:
   ```bash
   flutter build ios --release
   ```

---

## Security Considerations

1. **API Keys**: Store in environment variables, never commit to repository
2. **User Data**: Encrypt sensitive data in local storage
3. **Authentication**: Implement JWT token refresh mechanism
4. **SSL Pinning**: Implement for production API calls
5. **Photo Privacy**: Strip sensitive EXIF data before upload

---

## Monitoring & Analytics

### Firebase Analytics Events
```dart
class AnalyticsEvents {
  static const String sightingSubmitted = 'sighting_submitted';
  static const String photoCapture = 'photo_captured';
  static const String locationCaptured = 'location_captured';
  static const String offlineSync = 'offline_sync_completed';
}
```

### Crashlytics Integration
```dart
void main() async {
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  
  runApp(MyApp());
}
```

---

## Resources

### Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design Guidelines](https://material.io/design)

### Community
- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)

---

## Support & Maintenance

**Contact:**
- K.K.K. Ekanayake
- H.M.C.M. Bandara
- Horizon Campus

**Version:** 1.0.0  
**Last Updated:** November 2025
