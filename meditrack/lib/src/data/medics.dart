/* import 'package:flutter/material.dart';
import 'package:meditrack/src/models/medic.dart';

List<Medic> medicList = [
  Medic(
    name: 'Paracétamol',
    description: 'Analgésique pour les douleurs légères',
    stock: 20,
    time: const TimeOfDay(hour: 9, minute: 0),
    reminderType: MedicReminderType.daily,
    durationInDays: 5, // Prendre tous les jours pendant 5 jours
  ),
  Medic(
    name: 'Ibuprofène',
    description: 'Anti-inflammatoire pour les douleurs',
    stock: 20,
    time: const TimeOfDay(hour: 14, minute: 0),
    reminderType: MedicReminderType.weekly,
    daysOfWeek: [1, 3, 5], // Lundi, Mercredi, Vendredi
  ),
  Medic(
    name: 'Antibiotique',
    description: 'Traitement antibiotique',
    stock: 20,
    time: const TimeOfDay(hour: 22, minute: 12),
    reminderType: MedicReminderType.fixedDate,
    fixedDates: [
      DateTime(2024, 10, 7),
      DateTime(2024, 10, 14),
      DateTime(2024, 10, 21),
    ], // Rappels aux dates spécifiques
  ),
  Medic(
    name: 'Vitamines',
    description: 'Complément alimentaire pour renforcer l’immunité',
    stock: 20,
    time: const TimeOfDay(hour: 7, minute: 30),
    reminderType: MedicReminderType.daily,
    durationInDays: 30, // Rappel quotidien pendant 30 jours
  ),
];
 */