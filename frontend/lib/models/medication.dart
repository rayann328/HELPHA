class Medication {
  String id;
  String name;

  // Backend medication fields
  String? genericName;
  String? brandName;
  String? dosage;
  String? strength;
  String? type;
  String? color;
  String? shape;
  String? notes;
  String? photoUrl;

  // Schedule/UI fields
  String frequency;
  List<String> times;
  DateTime startDate;
  DateTime? endDate;

  String status;

  Medication({
    required this.id,
    required this.name,
    this.genericName,
    this.brandName,
    this.dosage,
    this.strength,
    this.type,
    this.color,
    this.shape,
    this.notes,
    this.photoUrl,
    this.frequency = 'Daily',
    this.times = const [],
    DateTime? startDate,
    this.endDate,
    this.status = 'Active',
  }) : startDate = startDate ?? DateTime.now();

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      genericName: json['genericName']?.toString(),
      brandName: json['brandName']?.toString(),
      dosage: json['dosage']?.toString(),
      strength: json['strength']?.toString(),
      type: json['type']?.toString(),
      color: json['color']?.toString(),
      shape: json['shape']?.toString(),
      notes: json['notes']?.toString(),
      photoUrl: json['photoUrl']?.toString(),
      frequency: json['frequency']?.toString() ?? 'Daily',
      times: json['times'] is List
          ? List<String>.from(
              (json['times'] as List).map(
                (e) => e.toString(),
              ),
            )
          : <String>[],
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'].toString())
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'].toString())
          : null,
      status: json['status']?.toString() ?? 'Active',
    );
  }
  factory Medication.fromMap(Map<String, dynamic> map) {
  return Medication.fromJson(map);
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'genericName': genericName,
      'brandName': brandName,
      'dosage': dosage,
      'strength': strength,
      'type': type,
      'color': color,
      'shape': shape,
      'notes': notes,
      'photoUrl': photoUrl,
      'frequency': frequency,
      'times': times,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status,
    };
  }
}