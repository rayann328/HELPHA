class Medication {
  String id;
  String name;
  String dosage;
  String type;
  String frequency;
  List<String> times;
  String notes;
  DateTime startDate;
  DateTime? endDate;
  String status;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.type,
    required this.frequency,
    required this.times,
    this.notes = '',
    required this.startDate,
    this.endDate,
    this.status = 'Active',
  });
}