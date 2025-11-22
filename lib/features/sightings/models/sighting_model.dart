class SightingModel {
  final String? id;
  final String species;
  final int count;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final String? notes;
  final List<String> photoPaths;
  final String status; // 'pending', 'verified', 'rejected'

  SightingModel({
    this.id,
    required this.species,
    required this.count,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.notes,
    this.photoPaths = const [],
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'species': species,
      'count': count,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
      'photoPaths': photoPaths,
      'status': status,
    };
  }

  factory SightingModel.fromJson(Map<String, dynamic> json) {
    return SightingModel(
      id: json['id'],
      species: json['species'],
      count: json['count'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      timestamp: DateTime.parse(json['timestamp']),
      notes: json['notes'],
      photoPaths: List<String>.from(json['photoPaths'] ?? []),
      status: json['status'] ?? 'pending',
    );
  }
}
