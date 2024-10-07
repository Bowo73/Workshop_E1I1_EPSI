import 'package:flutter/material.dart';
import 'package:meditrack/modules/calendar/view.dart';
import 'package:meditrack/modules/emergency/view.dart';
import 'package:meditrack/modules/medic/viewAddMedic.dart'; // Importation de la vue pour ajouter un médicament
import 'package:meditrack/modules/medic/viewDetails.dart'; // Importation de la vue pour afficher les détails d'un médicament
import 'package:meditrack/src/models/medic.dart'; // Importation du modèle Medic
import 'package:meditrack/src/utils/getFunction.dart'; // Importation des fonctions utilitaires pour gérer les rappels
import '../../src/data/medics.dart'; // Importation de la liste des médicaments

// Classe principale de la vue d'accueil
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

// État de la vue d'accueil
class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Médicaments'), // Titre de l'application
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline), // Icône d'information
            onPressed: () {
              // Action lors du tap sur l'icône
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const EmergencyInfoView(), // Navigation vers la vue d'informations
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today), // Icône de calendrier
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CalendarView(), // Navigation vers la vue calendrier
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: medicList.length, // Nombre total d'éléments dans la liste
        itemBuilder: (context, index) {
          final medic =
              medicList[index]; // Récupération du médicament à l'index actuel

          return Card(
            margin: const EdgeInsets.symmetric(
                vertical: 8, horizontal: 16), // Marges autour de la carte
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10), // Bord arrondi pour la carte
            ),
            elevation: 4, // Ombre pour la carte
            child: ListTile(
              leading: const Icon(
                Icons.medication, // Icône de médicament
                color: Colors.blueAccent,
                size: 40,
              ),
              title: Text(
                medic.name, // Nom du médicament
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold, // Style du texte en gras
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Alignement à gauche pour le sous-titre
                children: [
                  const SizedBox(height: 5), // Espace entre les éléments
                  Text(medic.description), // Description du médicament
                  const SizedBox(height: 5),
                  Text(
                    "Heure de prise : ${medic.time.format(context)}", // Affiche l'heure de prise
                    style: const TextStyle(
                        fontStyle: FontStyle.italic), // Style en italique
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Type de rappel : ${getReminderTypeText(medic.reminderType, medic)}", // Affiche le type de rappel
                    style: const TextStyle(
                        color: Colors.grey), // Style gris pour le texte
                  ),
                ],
              ),
              onTap: () {
                // Action lors du tap sur la carte
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicDetailView(
                        medic:
                            medic), // Navigation vers la vue de détail du médicament
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Action lors du tap sur le bouton flottant
          final newMedic = await Navigator.push<Medic>(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const AddMedicView()), // Navigation vers la vue pour ajouter un médicament
          );
          if (newMedic != null) {
            // Si un nouveau médicament a été ajouté
            setState(() {
              medicList.add(newMedic); // Ajout du nouveau médicament à la liste
            });
          }
        },
        child: const Icon(Icons.add), // Icône pour ajouter un médicament
      ),
    );
  }
}
