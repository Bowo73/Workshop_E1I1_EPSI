import 'package:flutter/material.dart';
import 'package:meditrack/modules/cgu/view.dart';

class EmergencyInfoView extends StatelessWidget {
  const EmergencyInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Infos d\'Urgence',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor:
            Colors.blue, // Couleur d'arrière-plan de la barre d'application
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Numéros d\'urgence :'),
              const SizedBox(height: 12),
              _buildEmergencyNumberCard(
                context,
                '• Le 18 : sapeurs-pompiers pour tout problème de secours, notamment accident, incendie.',
                Icons.local_fire_department,
              ),
              _buildEmergencyNumberCard(
                context,
                '• Le 15 : Samu pour tout problème urgent de santé, c\'est un secours médicalisé.',
                Icons.healing,
              ),
              _buildEmergencyNumberCard(
                context,
                '• Le 17 : police ou gendarmerie pour tout problème de sécurité ou d\'ordre public.',
                Icons.security,
              ),
              _buildEmergencyNumberCard(
                context,
                '• Le 112 : numéro d\'appel unique des urgences sur le territoire européen.',
                Icons.phone_in_talk,
              ),
              _buildEmergencyNumberCard(
                context,
                '• Le 115 : Samu social pour toute personne en détresse sociale.',
                Icons.people,
              ),
              const SizedBox(height: 18),
              _buildSectionTitle('Gestes de premiers secours :'),
              const SizedBox(height: 12),
              _buildEmergencyActionCard(
                context,
                '• Position latérale de sécurité (PLS) : Assurez-vous de dégager les voies respiratoires.',
                Icons.person,
              ),
              _buildEmergencyActionCard(
                context,
                '• Appeler les services d\'urgence en cas de besoin.',
                Icons.call,
              ),
              const SizedBox(height: 12),
              const Text(
                'Formations de premiers secours (PSC1) disponibles.',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TermsAndConditionsView(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.blue), // Couleur du bouton
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24)), // Espacement du bouton
                  ),
                  child: const Text('Voir les CGU',
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.blue, // Couleur du titre
      ),
    );
  }

  Widget _buildEmergencyNumberCard(
      BuildContext context, String text, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildEmergencyActionCard(
      BuildContext context, String text, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
