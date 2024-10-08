import 'package:flutter/material.dart';
import 'package:meditrack/modules/cgu/view.dart';

class EmergencyInfoView extends StatelessWidget {
  const EmergencyInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Infos d\'Urgence'), // Titre de la page d'informations
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 18, right: 18, bottom: 18), // Espacement autour du contenu
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Numéros d\'urgence :',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold), // Taille de police augmentée
              ),
              const SizedBox(height: 18),
              const Text(
                '• Le 18 : sapeurs-pompiers pour tout problème de secours, notamment accident, incendie.',
                style: TextStyle(
                    fontSize:
                        18), // Taille de police pour les éléments de liste
              ),
              const Text(
                '• Le 15 : Samu pour tout problème urgent de santé, c\'est un secours médicalisé.',
                style: TextStyle(fontSize: 18),
              ),
              const Text(
                '• Le 17 : police ou gendarmerie pour tout problème de sécurité ou d\'ordre public.',
                style: TextStyle(fontSize: 18),
              ),
              const Text(
                '• Le 112 : numéro d\'appel unique des urgences sur le territoire européen.',
                style: TextStyle(fontSize: 18),
              ),
              const Text(
                '• Le 115 : Samu social pour toute personne en détresse sociale.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 18),
              const Text(
                'Gestes de premiers secours :',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold), // Taille de police augmentée
              ),
              const SizedBox(height: 18),
              const Text(
                '• Position latérale de sécurité (PLS) : Assurez-vous de dégager les voies respiratoires.',
                style: TextStyle(fontSize: 18),
              ),
              const Text(
                '• Appeler les services d\'urgence en cas de besoin.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 18),
              const Text(
                'Formations de premiers secours (PSC1) disponibles.',
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle
                        .italic), // Taille de police pour le texte en italique
              ),
              const SizedBox(height: 18),
              FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TermsAndConditionsView()),
                    );
                  },
                  child: const Text('Voir les CGU'))
            ],
          ),
        ),
      ),
    );
  }
}
