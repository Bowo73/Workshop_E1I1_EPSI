import 'package:flutter/material.dart';
import 'package:meditrack/modules/medic/viewAddMedic.dart';
import 'package:meditrack/modules/medic/viewDetails.dart';
import 'package:meditrack/src/models/medic.dart';
import 'package:meditrack/src/utils/getFunction.dart';

import '../../src/data/medics.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Médicaments'),
      ),
      body: ListView.builder(
        itemCount: medicList.length,
        itemBuilder: (context, index) {
          final medic = medicList[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
            child: ListTile(
              leading: Icon(
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
