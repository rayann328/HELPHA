import '../models/medication.dart';
import 'api_service.dart';

class MedicationService {
  final ApiService _api = ApiService();

  Future<List<Medication>> getMedications() async {
    final response = await _api.get('/medications');

    if (response is! List) {
      return [];
    }

    return response
        .map(
          (item) => Medication.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<Medication> getMedication(String id) async {
    final response = await _api.get('/medications/$id');

    return Medication.fromJson(
      Map<String, dynamic>.from(response),
    );
  }

  Future<Medication> createMedication({
    required String name,
    String? genericName,
    String? brandName,
    String? dosage,
    String? strength,
    String? type,
    String? color,
    String? shape,
    String? notes,
    String? photoUrl,
  }) async {
    final body = <String, dynamic>{
      'name': name.trim(),
    };

    if (genericName != null &&
        genericName.trim().isNotEmpty) {
      body['genericName'] = genericName.trim();
    }

    if (brandName != null &&
        brandName.trim().isNotEmpty) {
      body['brandName'] = brandName.trim();
    }

    if (dosage != null &&
        dosage.trim().isNotEmpty) {
      body['dosage'] = dosage.trim();
    }

    if (strength != null &&
        strength.trim().isNotEmpty) {
      body['strength'] = strength.trim();
    }

    if (type != null &&
        type.trim().isNotEmpty) {
      body['type'] = type.trim();
    }

    if (color != null &&
        color.trim().isNotEmpty) {
      body['color'] = color.trim();
    }

    if (shape != null &&
        shape.trim().isNotEmpty) {
      body['shape'] = shape.trim();
    }

    if (notes != null &&
        notes.trim().isNotEmpty) {
      body['notes'] = notes.trim();
    }

    if (photoUrl != null &&
        photoUrl.trim().isNotEmpty) {
      body['photoUrl'] = photoUrl.trim();
    }

    final response = await _api.post(
      '/medications',
      body: body,
    );

    return Medication.fromJson(
      Map<String, dynamic>.from(response),
    );
  }

  Future<Medication> updateMedication(
    String id, {
    String? name,
    String? genericName,
    String? brandName,
    String? dosage,
    String? strength,
    String? type,
    String? color,
    String? shape,
    String? notes,
    String? photoUrl,
    String? status,
  }) async {
    final body = <String, dynamic>{};

    if (name != null) {
      body['name'] = name.trim();
    }

    if (genericName != null) {
      body['genericName'] = genericName.trim();
    }

    if (brandName != null) {
      body['brandName'] = brandName.trim();
    }

    if (dosage != null) {
      body['dosage'] = dosage.trim();
    }

    if (strength != null) {
      body['strength'] = strength.trim();
    }

    if (type != null) {
      body['type'] = type.trim();
    }

    if (color != null) {
      body['color'] = color.trim();
    }

    if (shape != null) {
      body['shape'] = shape.trim();
    }

    if (notes != null) {
      body['notes'] = notes.trim();
    }

    if (photoUrl != null) {
      body['photoUrl'] = photoUrl.trim();
    }

    if (status != null) {
      body['status'] = status;
    }

    final response = await _api.patch(
      '/medications/$id',
      body: body,
    );

    return Medication.fromJson(
      Map<String, dynamic>.from(response),
    );
  }

  Future<Medication> archiveMedication(
    String id,
  ) async {
    final response = await _api.patch(
      '/medications/$id/archive',
    );

    return Medication.fromJson(
      Map<String, dynamic>.from(response),
    );
  }

  Future<void> deleteMedication(
    String id,
  ) async {
    await _api.delete('/medications/$id');
  }
}