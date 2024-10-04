// lib/models/room.dart
class Room {
  final String name;
  final int capacity;
  final String imagePath;
  final double pricePerHour;
  bool isAvailable; // Add this field to represent availability

  Room({
    required this.name,
    required this.capacity,
    required this.imagePath,
    required this.pricePerHour,
    this.isAvailable = true, // Default value
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      name: json['name'],
      capacity: json['capacity'],
      imagePath: json['image_path'],
      pricePerHour: (json['price_per_hour'] is String)
          ? double.tryParse(json['price_per_hour']) ?? 0.0
          : (json['price_per_hour'] as num).toDouble(),
      isAvailable: json['is_available'] ?? true, // Initialize availability
    );
  }
}
