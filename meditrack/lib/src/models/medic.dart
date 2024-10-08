import 'package:flutter/material.dart';

enum MedicReminderType {
  daily, // Rappel quotidien
  weekly, // Rappel hebdomadaire
  fixedDate, // Rappel sur des dates fixes
}

class Medic {
  String name; // Nom du médicament
  String description; // Description du médicament
  int stock;
  TimeOfDay time; // Heure du rappel
  MedicReminderType
      reminderType; // Type de rappel (quotidien, hebdomadaire, ou à date fixe)
  List<int>? daysOfWeek; // Jours de la semaine
  List<DateTime>? fixedDates; // Dates fixes
  int? durationInDays; // Durée du rappel pour les rappels récurrents

  Medic({
    required this.name,
    required this.description,
    required this.stock,
    required this.time,
    required this.reminderType,
    this.daysOfWeek,
    this.fixedDates,
    this.durationInDays,
  });

  // Convertir un Medic en JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'stock': stock,
        'time': '${time.hour}:${time.minute}', // Convertir TimeOfDay en String
        'reminderType':
            reminderType.index, // Utiliser l'index pour l'énumération
        'daysOfWeek': daysOfWeek, // Conserver la liste d'entiers
        'fixedDates': fixedDates
            ?.map((date) => date.toIso8601String())
            .toList(), // Convertir DateTime en String
        'durationInDays': durationInDays,
      };

  // Convertir JSON en Medic
  factory Medic.fromJson(Map<String, dynamic> json) {
    return Medic(
      name: json['name'],
      description: json['description'],
      stock: json['stock'],
      time: _timeOfDayFromString(json['time']), // Convertir String en TimeOfDay
      reminderType: MedicReminderType
          .values[json['reminderType']], // Convertir index en MedicReminderType
      daysOfWeek: json['daysOfWeek'] != null
          ? List<int>.from(json['daysOfWeek'])
          : null,
      fixedDates: json['fixedDates'] != null
          ? (json['fixedDates'] as List)
              .map((date) => DateTime.parse(date))
              .toList()
          : null,
      durationInDays: json['durationInDays'],
    );
  }

  // Fonction utilitaire pour convertir une heure (String) en TimeOfDay
  static TimeOfDay _timeOfDayFromString(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  bool isReminderToday() {
    final now = DateTime.now();

    switch (reminderType) {
      case MedicReminderType.daily:
        return durationInDays == null ||
            now.difference(now).inDays < durationInDays!;
      case MedicReminderType.weekly:
        return daysOfWeek?.contains(now.weekday) ?? false;
      case MedicReminderType.fixedDate:
        return fixedDates?.any((date) =>
                date.year == now.year &&
                date.month == now.month &&
                date.day == now.day) ??
            false;
      default:
        return false;
    }
  }
}
