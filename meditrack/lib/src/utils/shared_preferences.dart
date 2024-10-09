import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:meditrack/src/models/medic.dart';

class SharedPrefsHelper {
  static const String _medicsKey = 'medics_key';
  static const String _medicsCheckKey =
      'medics_check_key'; // Nouvelle clé pour la liste de check

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

    // Initialiser la liste de check avec des valeurs par défaut "non cochées" (false)
    List<bool> medicCheckList = List.filled(medicList.length, false);
    await prefs.setStringList(_medicsCheckKey,
        medicCheckList.map((check) => check.toString()).toList());
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

  // Sauvegarder la liste de check des médicaments
  static Future<void> saveMedicCheck(List<bool> medicCheckList) async {
    final prefs = await _getPrefs();

    // Enregistrer la liste de check en tant que liste de chaînes de caractères ("true" ou "false")
    await prefs.setStringList(_medicsCheckKey,
        medicCheckList.map((check) => check.toString()).toList());
  }

  // Récupérer la liste de check des médicaments
  static Future<List<bool>> getMedicCheck() async {
    final prefs = await _getPrefs();

    // Lire la liste de check sauvegardée
    List<String>? medicCheckListString = prefs.getStringList(_medicsCheckKey);
    if (medicCheckListString == null) return [];

    // Convertir les valeurs en booléens
    return medicCheckListString.map((check) => check == 'true').toList();
  }

  // Supprimer la liste de médicaments et la liste de check
  static Future<void> clearMedics() async {
    final prefs = await _getPrefs();
    await prefs.remove(_medicsKey);
    await prefs.remove(_medicsCheckKey);
  }

  // Ajout d'un médicament à la liste de check
  static Future<void> addMedicToCheck(String medicName) async {
    final prefs = await _getPrefs();
    List<String> checkedMedics = prefs.getStringList(_medicsCheckKey) ?? [];
    if (!checkedMedics.contains(medicName)) {
      checkedMedics.add(medicName);
      await prefs.setStringList(_medicsCheckKey, checkedMedics);
    }
  }

  // Suppression d'un médicament de la liste de check
  static Future<void> removeMedicFromCheck(String medicName) async {
    final prefs = await _getPrefs();
    List<String> checkedMedics = prefs.getStringList(_medicsCheckKey) ?? [];
    checkedMedics.remove(medicName);
    await prefs.setStringList(_medicsCheckKey, checkedMedics);
  }

  // Récupérer la liste de médicaments cochés
  static Future<List<String>> getCheckedMedics() async {
    final prefs = await _getPrefs();
    return prefs.getStringList(_medicsCheckKey) ?? [];
  }

  // Supprimer la liste complète de médicaments cochés
  static Future<void> clearCheckedMedics() async {
    final prefs = await _getPrefs();
    await prefs.remove(_medicsCheckKey);
  }
}
