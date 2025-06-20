import 'package:flutter/material.dart';

enum EventCategory {
  petTrainersAndSitters,
  tutors,
  coaches
}

enum CoachSubCategory {
  wellness,
  mentalHealth,
  life,
  psychologist
}

enum City {
  schweinfurt,
  wurzburg
}

class Event {
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final EventCategory category;
  final CoachSubCategory? coachSubCategory;
  final bool hasReminder;
  final DateTime? reminderTime;
  final City city;

  Event({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.category,
    required this.city,
    this.coachSubCategory,
    this.hasReminder = false,
    this.reminderTime,
  });

  Color get categoryColor {
    switch (category) {
      case EventCategory.petTrainersAndSitters:
        return Colors.blue;
      case EventCategory.tutors:
        return Colors.green;
      case EventCategory.coaches:
        return Colors.purple;
    }
  }

  String get categoryName {
    if (category == EventCategory.coaches && coachSubCategory != null) {
      switch (coachSubCategory) {
        case CoachSubCategory.wellness:
          return 'Wellness Coaches';
        case CoachSubCategory.mentalHealth:
          return 'Mental Health Coaches';
        case CoachSubCategory.life:
          return 'Life Coaches';
        case CoachSubCategory.psychologist:
          return 'Psychologists (Licensed)';
        case null:
          return 'Coaches';
      }
    }
    
    switch (category) {
      case EventCategory.petTrainersAndSitters:
        return 'Pet Trainers & Sitters';
      case EventCategory.tutors:
        return 'Tutors';
      case EventCategory.coaches:
        return 'Coaches';
    }
  }

  String get cityName {
    switch (city) {
      case City.schweinfurt:
        return 'Schweinfurt';
      case City.wurzburg:
        return 'Würzburg';
    }
  }

  IconData get categoryIcon {
    if (category == EventCategory.coaches && coachSubCategory != null) {
      switch (coachSubCategory) {
        case CoachSubCategory.wellness:
          return Icons.spa;
        case CoachSubCategory.mentalHealth:
          return Icons.psychology;
        case CoachSubCategory.life:
          return Icons.self_improvement;
        case CoachSubCategory.psychologist:
          return Icons.medical_services;
        case null:
          return Icons.sports;
      }
    }
    
    switch (category) {
      case EventCategory.petTrainersAndSitters:
        return Icons.pets;
      case EventCategory.tutors:
        return Icons.school;
      case EventCategory.coaches:
        return Icons.sports;
    }
  }
} 