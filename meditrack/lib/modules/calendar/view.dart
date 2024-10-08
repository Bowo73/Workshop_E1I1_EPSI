import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meditrack/src/data/medics.dart';
import 'package:meditrack/src/models/medic.dart';
import 'package:meditrack/src/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late Map<DateTime, List<String>> events;
  late DateTime selectedDay;
  late DateTime focusedDay;
  bool isLoading = true; // Ajoutez une variable pour indiquer le chargement
  List<Medic> medicList = [];

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    focusedDay = DateTime.now();

    // Appel à la méthode asynchrone pour récupérer la liste des médicaments
    _loadMedicList();
  }

  Future<void> _loadMedicList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedMedicList = prefs.getStringList('medicsList') ?? [];

    print(savedMedicList);

    setState(() {
      medicList = savedMedicList.map((medicJson) {
        return Medic.fromJson(jsonDecode(medicJson));
      }).toList();

      // Transformez la liste de médicaments en événements
      events = transformMedicListToEvents(medicList);
      print(events); // Afficher les événements générés
      isLoading =
          false; // Arrêter le chargement une fois que les événements sont prêts
    });
  }

  Map<DateTime, List<String>> transformMedicListToEvents(
      List<Medic> medicList) {
    Map<DateTime, List<String>> events = {};
    DateTime now = DateTime.now();

    for (var medic in medicList) {
      if (medic.reminderType == MedicReminderType.fixedDate) {
        // Ajouter des événements pour les dates fixes
        for (var date in medic.fixedDates!) {
          events[date] = events[date] ?? [];
          events[date]!.add(
              '${medic.name} à ${medic.time.hour.toString().padLeft(2, '0')}h${medic.time.minute.toString().padLeft(2, '0')}');
        }
      } else if (medic.reminderType == MedicReminderType.daily) {
        // Vérifiez si durationInDays est valide ou définissez une valeur par défaut
        int duration = medic.durationInDays ?? 1; // Par défaut à 1 jour

        // Ajoutez l'événement pour chaque jour pendant la durée spécifiée
        for (int i = 0; i < duration; i++) {
          DateTime reminderDate = now.add(Duration(days: i));

          events[reminderDate] = events[reminderDate] ?? [];
          events[reminderDate]!.add(
              '${medic.name} à ${medic.time.hour.toString().padLeft(2, '0')}h${medic.time.minute.toString().padLeft(2, '0')}');
        }
      } else if (medic.reminderType == MedicReminderType.weekly) {
        // Vérifiez si daysOfWeek n'est pas vide
        if (medic.daysOfWeek != null && medic.daysOfWeek!.isNotEmpty) {
          for (var day in medic.daysOfWeek!) {
            for (int i = 0; i < 10; i++) {
              DateTime reminderDate =
                  now.add(Duration(days: (day - now.weekday) + (i * 7)));
              if (reminderDate.isAfter(now)) {
                // Filtrer les événements futurs uniquement
                events[reminderDate] = events[reminderDate] ?? [];
                events[reminderDate]!.add(
                    '${medic.name} à ${medic.time.hour.toString().padLeft(2, '0')}h${medic.time.minute.toString().padLeft(2, '0')}');
              }
            }
          }
        } else {
          print(
              'Avertissement : daysOfWeek est nul ou vide pour ${medic.name}');
        }
      }
    }

    // Filtrage pour ne garder que les événements dans le futur
    events.removeWhere((key, value) => key.isBefore(now));

    // Convertir les clés en UTC
    Map<DateTime, List<String>> eventsUtc = {};
    events.forEach((key, value) {
      eventsUtc[DateTime.utc(key.year, key.month, key.day)] = value;
    });

    print(eventsUtc); // Pour voir les événements finaux
    return eventsUtc;
  }

  List<String> getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendrier'),
      ),
      body: isLoading // Vérifier si nous sommes en train de charger
          ? const Center(
              child: CircularProgressIndicator(), // Afficher le loader
            )
          : Column(
              children: [
                TableCalendar<String>(
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2024, 12, 31),
                  focusedDay: focusedDay,
                  selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      this.selectedDay = selectedDay;
                      this.focusedDay = focusedDay;
                    });
                  },
                  eventLoader: getEventsForDay,
                  calendarStyle: CalendarStyle(
                    selectedDecoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.blue.withOpacity(
                          0.3), // Couleur bleue avec opacité pour le jour actuel
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ListView(
                    children: getEventsForDay(selectedDay)
                        .map((event) => Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1.0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ListTile(
                                title: Text(event),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
