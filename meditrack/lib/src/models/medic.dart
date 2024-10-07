import 'package:flutter/material.dart';

enum MedicReminderType {
  daily, // Rappel quotidien
  weekly, // Rappel hebdomadaire
  fixedDate, // Rappel sur des dates fixes
}

class Medic {
  String name; // Nom du médicament
  String description; // Description du médicament
  TimeOfDay time; // Heure du rappel
  MedicReminderType
      reminderType; // Type de rappel (quotidien, hebdomadaire, ou à date fixe)
  List<int>?
      daysOfWeek; // Jours de la semaine (ex : [1, 3, 5] pour Lundi, Mercredi, Vendredi)
  List<DateTime>? fixedDates; // Dates fixes (ex: [DateTime(2024, 10, 7)])
  int? durationInDays; // Durée du rappel (en jours) pour les rappels récurrents

  Medic({
    required this.name,
    required this.description,
    required this.time,
    required this.reminderType,
    this.daysOfWeek,
    this.fixedDates,
    this.durationInDays,
  });

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
