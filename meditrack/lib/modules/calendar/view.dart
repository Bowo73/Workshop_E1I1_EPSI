import 'package:flutter/material.dart';
import 'package:meditrack/src/data/medics.dart';
import 'package:meditrack/src/models/medic.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late Map<DateTime, List<String>> events;
  late DateTime selectedDay;
  late DateTime focusedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    focusedDay = DateTime.now();

    // Initialisation des événements à partir de medicList
    events = transformMedicListToEvents(medicList);
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
              '${medic.name} - ${medic.description} à ${medic.time.hour.toString().padLeft(2, '0')}h${medic.time.minute.toString().padLeft(2, '0')}');
        }
      } else if (medic.reminderType == MedicReminderType.daily) {
        // Ajouter des événements pour les rappels quotidiens
        for (int i = 0; i < medic.durationInDays!; i++) {
          DateTime reminderDate = now.add(Duration(days: i));
          events[reminderDate] = events[reminderDate] ?? [];
          events[reminderDate]!.add(
              '${medic.name} - ${medic.description} à ${medic.time.hour.toString().padLeft(2, '0')}h${medic.time.minute.toString().padLeft(2, '0')}');
        }
      } else if (medic.reminderType == MedicReminderType.weekly) {
        // Ajouter des événements pour les rappels hebdomadaires
        for (var day in medic.daysOfWeek!) {
          for (int i = 0; i < 10; i++) {
            // Limite à 10 semaines à l'avance pour éviter trop d'événements
            DateTime reminderDate =
                now.add(Duration(days: (day - now.weekday) + (i * 7)));
            events[reminderDate] = events[reminderDate] ?? [];
            events[reminderDate]!.add(
                '${medic.name} - ${medic.description} à ${medic.time.hour.toString().padLeft(2, '0')}h${medic.time.minute.toString().padLeft(2, '0')}');
          }
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

    return eventsUtc;
  }

  List<String> getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendrier'),
      ),
      body: Column(
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
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView(
              children: getEventsForDay(selectedDay)
                  .map((event) => ListTile(
                        title: Text(event),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
