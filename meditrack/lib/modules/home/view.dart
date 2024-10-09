import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meditrack/modules/calendar/view.dart';
import 'package:meditrack/modules/emergency/view.dart';
import 'package:meditrack/modules/medic/viewAddMedic.dart';
import 'package:meditrack/modules/medic/viewDetails.dart';
import 'package:meditrack/services/notifi_service.dart';
import 'package:meditrack/src/models/medic.dart';
import 'package:meditrack/src/utils/getFunction.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Timer _timer;
  List<Medic> medicList = [];

  @override
  void initState() {
    super.initState();
    _loadMedicList(); // Charger la liste des médicaments depuis SharedPreferences
    _scheduleNotifications(); // Lancer les notifications périodiques
  }

  @override
  void dispose() {
    _timer.cancel(); // Arrêter le Timer quand le widget est supprimé
    super.dispose();
  }

  Future<void> _loadMedicList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedMedicList = prefs.getStringList('medicsList') ?? [];

    setState(() {
      medicList = savedMedicList.map((medicJson) {
        return Medic.fromJson(jsonDecode(medicJson));
      }).toList();
    });
  }

  Future<void> _saveMedicList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedMedicList =
        medicList.map((medic) => jsonEncode(medic.toJson())).toList();
    await prefs.setStringList('medicsList', savedMedicList);
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

  void _confirmDeleteMedic(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Confirmation de suppression'),
          content:
              const Text('Êtes-vous sûr de vouloir supprimer ce médicament ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () {
                setState(() {
                  medicList.removeAt(index); // Supprimer le médicament
                });
                _saveMedicList(); // Sauvegarder la liste après la suppression
                Navigator.of(context).pop(); // Fermer le dialogue
              },
            ),
          ],
        );
      },
    );
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
                    builder: (context) => const EmergencyInfoView()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarView()),
              ).then((_) {
                _loadMedicList(); // Recharger la liste des médicaments au retour
              });
            },
          ),
        ],
      ),
      body: medicList.isEmpty
          ? const Center(
              child: Text(
                'Aucun médicament n\'a été ajouté.\nAppuyez sur + pour en ajouter un.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: medicList.length,
                    itemBuilder: (context, index) {
                      final medic = medicList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 4,
                        child: ListTile(
                          leading: const Icon(Icons.medication,
                              color: Colors.blue, size: 40),
                          title: Text(
                            medic.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(medic.description),
                              const SizedBox(height: 5),
                              Text(
                                "Heure de prise : ${medic.time.format(context)}",
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Type de rappel : ${getReminderTypeText(medic.reminderType, medic)}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 5),
                              // Nouvelle ligne pour afficher le stock
                              Text(
                                "Stock disponible : ${medic.stock} unités", // Affiche le stock
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color:
                                  Colors.red, // Couleur rouge pour la poubelle
                            ),
                            onPressed: () => _confirmDeleteMedic(
                                index), // Appel de la fonction de suppression
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MedicEditView(medic: medic)),
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
            await _saveMedicList(); // Sauvegarde après l'ajout
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
