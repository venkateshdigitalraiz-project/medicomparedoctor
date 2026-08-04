import '../../data/models/patient.dart';

abstract class PatientsRepository {
  Future<PatientListResponse> fetchPatients({
    required int page,
    required int limit,
  });
}
