import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meditrack/modules/calendar/view.dart';
import 'package:meditrack/modules/emergency/view.dart';
import 'package:meditrack/modules/medic/viewAddMedic.dart';
import 'package:meditrack/modules/medic/viewDetails.dart';
import 'package:meditrack/services/notifi_service.dart';
import 'package:meditrack/src/models/medic.dart';
import 'package:meditrack/src/utils/getFunction.dart';

import '../../src/data/medics.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _scheduleNotifications(); // Lancer les notifications périodiques
  }

  @override
  void dispose() {
    _timer.cancel(); // Arrêter le Timer quand le widget est supprimé
    super.dispose();
  }

  void _scheduleNotifications() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkAndSendNotifications();
    });
  }

  void _checkAndSendNotifications() {
    final now = DateTime.now();
    final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

    print(
        "Vérification des notifications à l'heure actuelle : ${now.hour}:${now.minute}");

    for (var medic in medicList) {
      if (medic.time.hour == currentTime.hour &&
          medic.time.minute == currentTime.minute) {
        bool shouldNotify = false;

        switch (medic.reminderType) {
          case MedicReminderType.daily:
            shouldNotify = true;
            break;
          case MedicReminderType.weekly:
            if (medic.daysOfWeek != null &&
                medic.daysOfWeek!.contains(now.weekday)) {
              shouldNotify = true;
            }
            break;
          case MedicReminderType.fixedDate:
            if (medic.fixedDates != null &&
                medic.fixedDates!.any((date) =>
                    date.year == now.year &&
                    date.month == now.month &&
                    date.day == now.day)) {
              shouldNotify = true;
            }
            break;
        }

        if (shouldNotify) {
          print(
              "Notification programmée pour ${medic.name} à ${medic.time.format(context)}");
          NotificationService().showNotification(
            title: "Prise de ${medic.name}",
            body: "Il est l'heure de prendre votre ${medic.name}.",
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Médicaments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmergencyInfoView(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalendarView(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: medicList.length,
              itemBuilder: (context, index) {
                final medic = medicList[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(
                      Icons.medication,
                      color: Colors.blueAccent,
                      size: 40,
                    ),
                    title: Text(
                      medic.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(medic.description),
                        const SizedBox(height: 5),
                        Text(
                          "Heure de prise : ${medic.time.format(context)}",
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Type de rappel : ${getReminderTypeText(medic.reminderType, medic)}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicDetailView(medic: medic),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newMedic = await Navigator.push<Medic>(
            context,
            MaterialPageRoute(builder: (context) => const AddMedicView()),
          );
          if (newMedic != null) {
            setState(() {
              medicList.add(newMedic);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
