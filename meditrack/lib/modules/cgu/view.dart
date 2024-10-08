import 'package:flutter/material.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conditions Générales d\'Utilisation'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conditions Générales d\'Utilisation (CGU) de l\'Application "MediTrack"',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '1. Objet\n'
              'Les présentes Conditions Générales d\'Utilisation (CGU) régissent l\'utilisation de l\'application mobile "MediTrack". '
              'Cette application permet aux utilisateurs de choisir et d’enregistrer des médicaments et de recevoir des notifications pour rappeler '
              'la prise des médicaments. Les notifications peuvent être partagées avec des tiers autorisés, tels que des infirmiers, des membres '
              'de la famille ou autres proches désignés.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '2. Acceptation des CGU\n'
              'En installant et en utilisant l’application MediTrack, l’utilisateur accepte expressément les présentes CGU. '
              'Si l’utilisateur n’accepte pas ces CGU, il doit désinstaller immédiatement l\'application et cesser de l\'utiliser.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '4. Fonctionnalités de l\'application\n'
              'L\'application MediTrack propose les fonctionnalités suivantes :\n'
              '- **Enregistrement des médicaments** : l\'utilisateur peut sélectionner des médicaments, spécifier les doses, les fréquences et les horaires de prise.\n'
              '- **Notifications** : l’application envoie des rappels à l\'utilisateur pour la prise des médicaments.\n'
              '- **Partage des notifications** : les notifications peuvent être partagées avec des utilisateurs tiers autorisés (infirmiers, proches, etc.), à la discrétion de l’utilisateur principal.\n'
              '- **Historique de prise** : l\'application conserve un historique des médicaments pris.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '5. Responsabilité de l\'utilisateur\n'
              '- L’utilisateur est seul responsable de l’exactitude des informations sur les médicaments et les horaires de prise renseignés dans l\'application.\n'
              '- MediTrack ne se substitue en aucun cas à un avis médical. L\'application est un outil d’assistance, et il est recommandé de consulter un professionnel de santé pour tout conseil ou changement dans la prescription médicale.\n'
              '- L’utilisateur doit s\'assurer que les notifications sont partagées avec des personnes dûment autorisées et informées.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '6. Protection des données personnelles\n'
              'MediTrack s\'engage à respecter la confidentialité des données personnelles des utilisateurs. Les données collectées comprennent, sans s\'y limiter, les informations sur les médicaments et les utilisateurs autorisés à recevoir des notifications.\n'
              '- Les données sont traitées conformément à la réglementation en vigueur (notamment le RGPD).\n'
              '- Les utilisateurs peuvent demander la suppression de leurs données en contactant le support de l\'application.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '7. Sécurité des informations\n'
              'MediTrack met en place des mesures de sécurité pour protéger les informations personnelles des utilisateurs contre tout accès non autorisé. '
              'Cependant, MediTrack ne peut garantir une sécurité absolue et décline toute responsabilité en cas de faille de sécurité résultant de facteurs externes hors de son contrôle.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '8. Propriété intellectuelle\n'
              'Tous les éléments de l’application, incluant mais non limités aux textes, images, graphismes, logo, etc., sont protégés par les lois relatives à la propriété intellectuelle. '
              'Toute reproduction, distribution ou utilisation non autorisée est strictement interdite.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '9. Limitation de responsabilité\n'
              '- L\'application est fournie en l\'état sans aucune garantie d’aucune sorte. MediTrack ne garantit pas l\'exactitude ou la disponibilité continue des services fournis.\n'
              '- MediTrack ne peut être tenue responsable des erreurs liées à l’omission de la prise de médicaments, ou des erreurs dans les notifications partagées.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '10. Modification des CGU\n'
              'MediTrack se réserve le droit de modifier les présentes CGU à tout moment. Les utilisateurs seront informés des modifications par tout moyen jugé adéquat. '
              'L’utilisation continue de l\'application après notification de la modification implique l’acceptation des nouvelles CGU.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '11. Résiliation\n'
              'L’utilisateur peut supprimer son compte et résilier son utilisation de l\'application à tout moment. MediTrack se réserve le droit de suspendre ou de résilier tout compte en cas de violation des présentes CGU.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '12. Droit applicable\n'
              'Les présentes CGU sont soumises au droit français. En cas de litige, les parties s\'efforceront de trouver une solution amiable avant d\'engager toute action devant les tribunaux compétents.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
