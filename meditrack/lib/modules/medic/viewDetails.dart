import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meditrack/src/models/medic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meditrack/src/utils/getFunction.dart';

class MedicEditView extends StatefulWidget {
  final Medic medic;

  const MedicEditView({Key? key, required this.medic}) : super(key: key);

  @override
  _MedicEditViewState createState() => _MedicEditViewState();
}

class _MedicEditViewState extends State<MedicEditView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _dailyCountController;
  late TextEditingController _stockController;
  late TimeOfDay _selectedTime;
  late MedicReminderType _selectedType;
  late List<int> _selectedDaysOfWeek;
  late List<DateTime> _selectedFixedDates;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medic.name);
    _descriptionController =
        TextEditingController(text: widget.medic.description);
    _dailyCountController = TextEditingController(
        text: widget.medic.durationInDays?.toString() ?? '');
    _stockController =
        TextEditingController(text: widget.medic.stock.toString());
    _selectedTime = widget.medic.time;
    _selectedType = widget.medic.reminderType;
    _selectedDaysOfWeek = List<int>.from(widget.medic.daysOfWeek ?? []);
    _selectedFixedDates = List<DateTime>.from(widget.medic.fixedDates ?? []);
  }

  Future<void> _updateMedic(Medic updatedMedic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedMedicList = prefs.getStringList('medicsList') ?? [];

    List<Medic> medicList = savedMedicList.map((medicJson) {
      return Medic.fromJson(jsonDecode(medicJson));
    }).toList();

    // Mettre à jour le médicament
    int index = medicList.indexWhere((m) => m.name == widget.medic.name);
    if (index != -1) {
      medicList[index] = updatedMedic;
      List<String> updatedMedicList =
          medicList.map((m) => jsonEncode(m.toJson())).toList();
      await prefs.setStringList('medicsList', updatedMedicList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Modifier ${widget.medic.name}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor:
            Colors.blue, // Couleur d'arrière-plan de la barre d'application
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
                isNumber: true,
              ),
              const SizedBox(height: 16),
              _buildTimePicker(),
              const SizedBox(height: 16),
              _buildReminderTypeDropdown(),
              const SizedBox(height: 16),
              _buildReminderSpecificFields(),
              const SizedBox(height: 16),
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
              final updatedMedic = Medic(
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

              await _updateMedic(updatedMedic);
              Navigator.pop(context, updatedMedic);
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('Enregistrer les modifications'),
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
          border: const OutlineInputBorder(),
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
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(12.0),
        ),
      ),
    );
  }

  Widget _buildReminderSpecificFields() {
    if (_selectedType == MedicReminderType.daily) {
      return _buildTextField(
        controller: _dailyCountController,
        label: 'Nombre de jours',
        validator: (value) {
          if (value!.isEmpty) return 'Entrez un nombre de jours';
          if (int.tryParse(value) == null || int.parse(value) <= 0)
            return 'Veuillez entrer un nombre valide';
          return null;
        },
      );
    } else if (_selectedType == MedicReminderType.weekly) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Jours de notification :',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8.0,
            children: List<Widget>.generate(7, (index) {
              final isSelected = _selectedDaysOfWeek.contains(index + 1);
              return ChoiceChip(
                label: Text(
                    ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'][index]),
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
      );
    } else if (_selectedType == MedicReminderType.fixedDate) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
      );
    }
    return Container(); // Pour gérer le cas où aucun type n'est sélectionné
  }
}
