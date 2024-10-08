import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meditrack/src/models/medic.dart';
import 'package:meditrack/src/utils/getFunction.dart';
import 'dart:convert'; // Pour les opérations JSON

class AddMedicView extends StatefulWidget {
  const AddMedicView({Key? key}) : super(key: key);

  @override
  _AddMedicViewState createState() => _AddMedicViewState();
}

class _AddMedicViewState extends State<AddMedicView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dailyCountController = TextEditingController();
  final TextEditingController _stockController =
      TextEditingController(); // Nouveau contrôleur pour le stock
  TimeOfDay _selectedTime = TimeOfDay.now();
  MedicReminderType _selectedType = MedicReminderType.daily;

  final List<int> _selectedDaysOfWeek = [];
  final List<DateTime> _selectedFixedDates = [];
  final List<String> _daysOfWeek = [
    'Lun',
    'Mar',
    'Mer',
    'Jeu',
    'Ven',
    'Sam',
    'Dim'
  ];

  Future<void> _saveMedic(Medic newMedic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Récupérer la liste actuelle des médicaments depuis SharedPreferences
    List<String> savedMedicList = prefs.getStringList('medicsList') ?? [];

    // Convertir le nouveau médicament en JSON et ajouter à la liste
    savedMedicList.add(jsonEncode(newMedic.toJson()));

    // Sauvegarder la liste mise à jour
    await prefs.setStringList('medicsList', savedMedicList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Médicament'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration:
                    const InputDecoration(labelText: 'Nom du Médicament'),
                validator: (value) => value!.isEmpty ? 'Entrez un nom' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Entrez une description' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockController, // Champ pour le stock
                decoration: const InputDecoration(
                  labelText: 'Stock disponible',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Entrez un stock';
                  if (int.tryParse(value) == null || int.parse(value) < 0)
                    return 'Veuillez entrer un nombre valide';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title:
                    Text("Heure de prise : ${_selectedTime.format(context)}"),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (time != null) {
                    setState(() {
                      _selectedTime = time;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<MedicReminderType>(
                value: _selectedType,
                dropdownColor: Colors.white,
                items: MedicReminderType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(getSimpleReminderTypeText(type, null)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                    if (value == MedicReminderType.daily) {
                      _selectedDaysOfWeek.clear();
                      _selectedFixedDates.clear();
                      _dailyCountController.clear();
                    } else if (value == MedicReminderType.weekly) {
                      _selectedFixedDates.clear();
                      _dailyCountController.clear();
                    } else if (value == MedicReminderType.fixedDate) {
                      _selectedDaysOfWeek.clear();
                      _dailyCountController.clear();
                    }
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Type de Rappel',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedType == MedicReminderType.daily) ...[
                TextFormField(
                  controller: _dailyCountController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de jours',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Entrez un nombre de jours';
                    if (int.tryParse(value) == null || int.parse(value) <= 0)
                      return 'Veuillez entrer un nombre valide';
                    return null;
                  },
                ),
              ],
              if (_selectedType == MedicReminderType.weekly) ...[
                const Text('Jours de notification :',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8.0,
                  children: List<Widget>.generate(7, (index) {
                    final isSelected = _selectedDaysOfWeek.contains(index + 1);
                    return ChoiceChip(
                      backgroundColor: Colors.white,
                      label: Text(_daysOfWeek[index]),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedDaysOfWeek.add(index + 1);
                          } else {
                            _selectedDaysOfWeek.remove(index + 1);
                          }
                        });
                      },
                    );
                  }),
                ),
              ],
              if (_selectedType == MedicReminderType.fixedDate) ...[
                const SizedBox(height: 16),
                const Text('Dates fixes :',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8.0,
                  children: _selectedFixedDates.map((date) {
                    return Chip(
                      label: Text('${date.day}/${date.month}/${date.year}'),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () {
                        setState(() {
                          _selectedFixedDates.remove(date);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _selectedFixedDates.add(selectedDate);
                      });
                    }
                  },
                  child: const Text('Ajouter une Date Fixe'),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          left: 16.0,
          right: 16.0,
          top: 12.0,
        ),
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final newMedic = Medic(
                name: _nameController.text,
                description: _descriptionController.text,
                stock: int.parse(_stockController.text), // Ajout du stock
                time: _selectedTime,
                reminderType: _selectedType,
                daysOfWeek: _selectedDaysOfWeek,
                fixedDates: _selectedFixedDates,
                durationInDays: _dailyCountController.text.isNotEmpty
                    ? int.parse(_dailyCountController.text)
                    : null,
              );

              // Enregistrer le médicament dans SharedPreferences
              await _saveMedic(newMedic);

              Navigator.pop(context, newMedic);
            }
          },
          child: const Text('Ajouter le Médicament'),
        ),
      ),
    );
  }
}
