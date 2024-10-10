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
  final TextEditingController _stockController = TextEditingController();
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
    List<String> savedMedicList = prefs.getStringList('medicsList') ?? [];
    savedMedicList.add(jsonEncode(newMedic.toJson()));
    await prefs.setStringList('medicsList', savedMedicList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Ajouter un Médicament',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue, // Couleur de la barre d'application
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Nom du Médicament',
                validator: (value) => value!.isEmpty ? 'Entrez un nom' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                validator: (value) =>
                    value!.isEmpty ? 'Entrez une description' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _stockController,
                label: 'Stock disponible',
                validator: (value) {
                  if (value!.isEmpty) return 'Entrez un stock';
                  if (int.tryParse(value) == null || int.parse(value) < 0)
                    return 'Veuillez entrer un nombre valide';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTimePicker(),
              const SizedBox(height: 16),
              _buildReminderTypeDropdown(),
              const SizedBox(height: 16),
              if (_selectedType == MedicReminderType.daily) ...[
                _buildTextField(
                  controller: _dailyCountController,
                  label: 'Nombre de jours',
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
                      label: Text(_daysOfWeek[index]),
                      backgroundColor: Colors.white,
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
                stock: int.parse(_stockController.text),
                time: _selectedTime,
                reminderType: _selectedType,
                daysOfWeek: _selectedDaysOfWeek,
                fixedDates: _selectedFixedDates,
                durationInDays: _dailyCountController.text.isNotEmpty
                    ? int.parse(_dailyCountController.text)
                    : null,
              );

              await _saveMedic(newMedic);
              Navigator.pop(context, newMedic);
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('Ajouter le Médicament'),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    bool isNumber = false,
  }) {
    return Card(
      elevation: 4,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          // Ajoutez les bordures personnalisées
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors
                    .transparent), // Couleur de bordure quand le champ est activé
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors
                    .transparent), // Couleur de bordure quand le champ est sélectionné
          ),
          contentPadding: const EdgeInsets.all(12.0),
        ),
        validator: validator,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
    );
  }

  Widget _buildTimePicker() {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text("Heure de prise : ${_selectedTime.format(context)}"),
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
    );
  }

  Widget _buildReminderTypeDropdown() {
    return Card(
      elevation: 4,
      child: DropdownButtonFormField<MedicReminderType>(
        dropdownColor: Colors.white,
        value: _selectedType,
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
          contentPadding: EdgeInsets.all(12.0),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors
                    .transparent), // Couleur de bordure quand le champ est activé
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors
                    .transparent), // Couleur de bordure quand le champ est sélectionné
          ),
        ),
      ),
    );
  }
}
