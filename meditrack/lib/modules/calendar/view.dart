import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meditrack/src/models/medic.dart';
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
  bool isLoading = true;
  List<Medic> medicList = [];
  Map<String, List<DateTime>> checkedMedicDates = {};

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    focusedDay = DateTime.now();
    _loadMedicList();
    _loadCheckedMedics().then((_) {
      print("Dates de prise de médicaments au chargement : $checkedMedicDates");
    });
  }

  Future<void> _loadMedicList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedMedicList = prefs.getStringList('medicsList') ?? [];

    setState(() {
      medicList = savedMedicList.map((medicJson) {
        return Medic.fromJson(jsonDecode(medicJson));
      }).toList();

      events = transformMedicListToEvents(medicList);
      isLoading = false;
    });
  }

  Map<DateTime, List<String>> transformMedicListToEvents(
      List<Medic> medicList) {
    Map<DateTime, List<String>> events = {};
    DateTime now = DateTime.now();

    for (var medic in medicList) {
      if (medic.reminderType == MedicReminderType.fixedDate) {
        for (var date in medic.fixedDates!) {
          events[date] = events[date] ?? [];
          events[date]!.add(
              '${medic.name} à ${medic.time.hour.toString().padLeft(2, '0')}h${medic.time.minute.toString().padLeft(2, '0')}');
        }
      } else if (medic.reminderType == MedicReminderType.daily) {
        int duration = medic.durationInDays ?? 1;

        for (int i = 0; i < duration; i++) {
          DateTime reminderDate = now.add(Duration(days: i));
          events[reminderDate] = events[reminderDate] ?? [];
          events[reminderDate]!.add(
              '${medic.name} à ${medic.time.hour.toString().padLeft(2, '0')}h${medic.time.minute.toString().padLeft(2, '0')}');
        }
      } else if (medic.reminderType == MedicReminderType.weekly) {
        if (medic.daysOfWeek != null && medic.daysOfWeek!.isNotEmpty) {
          for (var day in medic.daysOfWeek!) {
            for (int i = 0; i < 10; i++) {
              DateTime reminderDate =
                  now.add(Duration(days: (day - now.weekday) + (i * 7)));
              if (reminderDate.isAfter(now)) {
                events[reminderDate] = events[reminderDate] ?? [];
                events[reminderDate]!.add(
                    '${medic.name} à ${medic.time.hour.toString().padLeft(2, '0')}h${medic.time.minute.toString().padLeft(2, '0')}');
              }
            }
          }
        }
      }
    }

    events.removeWhere((key, value) => key.isBefore(now));

    Map<DateTime, List<String>> eventsUtc = {};
    events.forEach((key, value) {
      eventsUtc[DateTime.utc(key.year, key.month, key.day)] = value;
    });

    return eventsUtc;
  }

  List<String> getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  Future<void> _loadCheckedMedics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? checkedDatesJson = prefs.getString('checkedMedicDates');

    if (checkedDatesJson != null) {
      Map<String, dynamic> savedCheckedDates = jsonDecode(checkedDatesJson);
      setState(() {
        checkedMedicDates = savedCheckedDates.map((medicName, datesList) {
          List<DateTime> dates = (datesList as List)
              .map((dateStr) => DateTime.parse(dateStr))
              .toList();
          return MapEntry(medicName, dates);
        });
      });
    }
  }

  Future<void> _toggleMedicCheck(String medicName, DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (checkedMedicDates.containsKey(medicName)) {
      if (checkedMedicDates[medicName]!.contains(date)) {
        checkedMedicDates[medicName]!.remove(date);
      } else {
        checkedMedicDates[medicName]!.add(date);
      }
    } else {
      checkedMedicDates[medicName] = [date];
    }

    String checkedDatesJson = jsonEncode(checkedMedicDates.map((key, dates) {
      return MapEntry(
          key, dates.map((date) => date.toIso8601String()).toList());
    }));

    await prefs.setString('checkedMedicDates', checkedDatesJson);

    setState(() {});
  }

  bool isMedicChecked(String medicName, DateTime date) {
    return checkedMedicDates[medicName]?.contains(date) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Calendrier',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TableCalendar<String>(
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
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      weekendTextStyle: const TextStyle(color: Colors.red),
                      todayTextStyle: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      defaultTextStyle: const TextStyle(color: Colors.black),
                    ),
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      leftChevronIcon:
                          Icon(Icons.chevron_left, color: Colors.blue),
                      rightChevronIcon:
                          Icon(Icons.chevron_right, color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    children: getEventsForDay(selectedDay)
                        .map(
                          (event) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      event,
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Checkbox(
                                    value: isMedicChecked(event, selectedDay),
                                    onChanged: (bool? isChecked) async {
                                      await _toggleMedicCheck(
                                          event, selectedDay);
                                    },
                                    activeColor: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
