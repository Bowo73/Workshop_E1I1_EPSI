import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:meditrack/src/models/medic.dart';

class SharedPrefsHelper {
  static const String _medicsKey = 'medics_key';

  // Méthode pour initialiser SharedPreferences
  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // Sauvegarder la liste de médicaments
  static Future<void> saveMedics(List<Medic> medicList) async {
    final prefs = await _getPrefs();

    // Convertir la liste d'objets Medic en JSON pour l'enregistrement
    List<String> medicJsonList =
        medicList.map((medic) => jsonEncode(medic.toJson())).toList();
    await prefs.setStringList(_medicsKey, medicJsonList);
  }

  // Récupérer la liste de médicaments
  static Future<List<Medic>> getMedics() async {
    final prefs = await _getPrefs();

    // Lire la liste JSON enregistrée et la convertir en objets Medic
    List<String>? medicJsonList = prefs.getStringList(_medicsKey);
    if (medicJsonList == null) return [];

    return medicJsonList
        .map((medicJson) => Medic.fromJson(jsonDecode(medicJson)))
        .toList();
  }

  // Supprimer la liste de médicaments
  static Future<void> clearMedics() async {
    final prefs = await _getPrefs();
    await prefs.remove(_medicsKey);
  }
}
