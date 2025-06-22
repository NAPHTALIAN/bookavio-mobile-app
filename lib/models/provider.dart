class Provider {
  final String id;
  final String name;
  final String service;
  final String subService;
  final String image;
  final double rating;
  final int reviewCount;
  final String location;
  final double hourlyRate;
  final List<String> availability;
  final String description;
  final List<String> specializations;
  final bool isAvailable;

  Provider({
    required this.id,
    required this.name,
    required this.service,
    required this.subService,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.hourlyRate,
    required this.availability,
    required this.description,
    required this.specializations,
    required this.isAvailable,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'],
      name: json['name'],
      service: json['service'],
      subService: json['subService'],
      image: json['image'],
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      location: json['location'],
      hourlyRate: json['hourlyRate'].toDouble(),
      availability: List<String>.from(json['availability']),
      description: json['description'],
      specializations: List<String>.from(json['specializations']),
      isAvailable: json['isAvailable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'service': service,
      'subService': subService,
      'image': image,
      'rating': rating,
      'reviewCount': reviewCount,
      'location': location,
      'hourlyRate': hourlyRate,
      'availability': availability,
      'description': description,
      'specializations': specializations,
      'isAvailable': isAvailable,
    };
  }
} 