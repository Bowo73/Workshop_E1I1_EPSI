import '../models/medic.dart';

String getReminderTypeText(MedicReminderType type, Medic? medic) {
  switch (type) {
    case MedicReminderType.daily:
      return "Quotidien, pendant ${medic?.durationInDays ?? 'indéfini'} jours";
    case MedicReminderType.weekly:
      return "Hebdomadaire (${medic?.daysOfWeek?.map(getDayName).join(', ') ?? 'indéfini'})";
    case MedicReminderType.fixedDate:
      return "Dates fixes (${medic?.fixedDates?.map((date) => '${date.day}/${date.month}/${date.year}').join(', ') ?? 'indéfini'})";
    default:
      return "Indéfini";
  }
}

String getDayName(int day) {
  switch (day) {
    case 1:
      return 'Lun';
    case 2:
      return 'Mar';
    case 3:
      return 'Mer';
    case 4:
      return 'Jeu';
    case 5:
      return 'Ven';
    case 6:
      return 'Sam';
    case 7:
      return 'Dim';
    default:
      return '';
  }
}
