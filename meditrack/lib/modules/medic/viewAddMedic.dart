import 'package:flutter/material.dart';
import 'package:meditrack/src/models/medic.dart';
import 'package:meditrack/src/utils/getFunction.dart';

class AddMedicView extends StatefulWidget {
  const AddMedicView({Key? key}) : super(key: key);

  @override
  _AddMedicViewState createState() => _AddMedicViewState();
}

class _AddMedicViewState extends State<AddMedicView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dailyCountController =
      TextEditingController(); // Pour le nombre de jours
  TimeOfDay _selectedTime = TimeOfDay.now();
  MedicReminderType _selectedType = MedicReminderType.daily;

  // Liste pour stocker les jours de la semaine sélectionnés
  final List<int> _selectedDaysOfWeek = [];
  // Liste pour stocker les dates fixes sélectionnées
  final List<DateTime> _selectedFixedDates = [];

  // Jours de la semaine pour affichage
  final List<String> _daysOfWeek = [
    'Lun',
    'Mar',
    'Mer',
    'Jeu',
    'Ven',
    'Sam',
    'Dim'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Médicament'),
      ),
      body: SingleChildScrollView(
        // Ajout du ScrollView
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
              // Dropdown pour le type de rappel
              DropdownButtonFormField<MedicReminderType>(
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
                    // Réinitialiser les jours et dates lorsque le type change
                    if (value == MedicReminderType.daily) {
                      _selectedDaysOfWeek.clear();
                      _selectedFixedDates.clear();
                      _dailyCountController
                          .clear(); // Réinitialiser le champ de nombre de jours
                    } else if (value == MedicReminderType.weekly) {
                      _selectedFixedDates.clear();
                      _dailyCountController
                          .clear(); // Réinitialiser le champ de nombre de jours
                    } else if (value == MedicReminderType.fixedDate) {
                      _selectedDaysOfWeek.clear();
                      _dailyCountController
                          .clear(); // Réinitialiser le champ de nombre de jours
                    }
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Type de Rappel',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Affichage d'un champ pour le nombre de jours si le type est quotidien
              if (_selectedType == MedicReminderType.daily) ...[
                TextFormField(
                  controller: _dailyCountController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de jours',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Entrez un nombre de jours';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Veuillez entrer un nombre valide';
                    }
                    return null;
                  },
                ),
              ],

              // Affichage des jours de la semaine uniquement si le type est hebdomadaire
              if (_selectedType == MedicReminderType.weekly) ...[
                const Text('Jours de notification :',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8.0,
                  children: List<Widget>.generate(7, (index) {
                    final isSelected = _selectedDaysOfWeek.contains(index + 1);
                    return ChoiceChip(
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

              // Affichage des dates fixes uniquement si le type est fixe
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
        // Ajouter le bouton dans le BottomNavigationBar
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom +
              16.0, // Ajout de padding bas
          left: 16.0, // Ajout de padding gauche
          right: 16.0, // Ajout de padding droit
          top: 12.0, // Ajout de padding supérieur
        ),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newMedic = Medic(
                name: _nameController.text,
                description: _descriptionController.text,
                time: _selectedTime,
                reminderType: _selectedType,
                daysOfWeek: _selectedDaysOfWeek, // Ajout des jours sélectionnés
                fixedDates: _selectedFixedDates, // Ajout des dates fixes
              );
              Navigator.pop(context, newMedic);
            }
          },
          child: const Text('Ajouter le Médicament'),
        ),
      ),
    );
  }
}
