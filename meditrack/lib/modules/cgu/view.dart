import 'package:flutter/material.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Conditions Générales d\'Utilisation',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Conditions Générales d\'Utilisation (CGU) de l\'Application "MediTrack"',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Divider(thickness: 2),
            const SizedBox(height: 10),
            _buildSection(
              title: '1. Objet',
              icon: Icons.info_outline,
              content:
                  'Les présentes Conditions Générales d\'Utilisation (CGU) régissent l\'utilisation de l\'application mobile "MediTrack". '
                  'Cette application permet aux utilisateurs de choisir et d’enregistrer des médicaments et de recevoir des notifications pour rappeler '
                  'la prise des médicaments. Les notifications peuvent être partagées avec des tiers autorisés, tels que des infirmiers, des membres '
                  'de la famille ou autres proches désignés.',
            ),
            _buildSection(
              title: '2. Acceptation des CGU',
              icon: Icons.check_circle_outline,
              content:
                  'En installant et en utilisant l’application MediTrack, l’utilisateur accepte expressément les présentes CGU. '
                  'Si l’utilisateur n’accepte pas ces CGU, il doit désinstaller immédiatement l\'application et cesser de l\'utiliser.',
            ),
            _buildSection(
              title: '3. Fonctionnalités de l\'application',
              icon: Icons.apps,
              content:
                  'L\'application MediTrack propose les fonctionnalités suivantes :\n\n'
                  '- **Enregistrement des médicaments** : l\'utilisateur peut sélectionner des médicaments, spécifier les doses, les fréquences et les horaires de prise.\n'
                  '- **Notifications** : l’application envoie des rappels à l\'utilisateur pour la prise des médicaments.\n'
                  '- **Partage des notifications** : les notifications peuvent être partagées avec des utilisateurs tiers autorisés (infirmiers, proches, etc.), à la discrétion de l’utilisateur principal.\n'
                  '- **Historique de prise** : l\'application conserve un historique des médicaments pris.',
            ),
            _buildSection(
              title: '4. Responsabilité de l\'utilisateur',
              icon: Icons.person_outline,
              content:
                  '- L’utilisateur est seul responsable de l’exactitude des informations sur les médicaments et les horaires de prise renseignés dans l\'application.\n'
                  '- MediTrack ne se substitue en aucun cas à un avis médical. L\'application est un outil d’assistance, et il est recommandé de consulter un professionnel de santé pour tout conseil ou changement dans la prescription médicale.\n'
                  '- L’utilisateur doit s\'assurer que les notifications sont partagées avec des personnes dûment autorisées et informées.',
            ),
            _buildSection(
              title: '5. Protection des données personnelles',
              icon: Icons.lock_outline,
              content:
                  'MediTrack s\'engage à respecter la confidentialité des données personnelles des utilisateurs. Les données collectées comprennent, sans s\'y limiter, les informations sur les médicaments et les utilisateurs autorisés à recevoir des notifications.\n\n'
                  '- Les données sont traitées conformément à la réglementation en vigueur (notamment le RGPD).\n'
                  '- Les utilisateurs peuvent demander la suppression de leurs données en contactant le support de l\'application.',
            ),
            // Ajoutez les autres sections de la même manière...
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
