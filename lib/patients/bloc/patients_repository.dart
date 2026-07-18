import '../models/patient.dart';

/// Mocks a data source. In a real app this would call a REST/GraphQL API
/// or a local database and return the same shape of data.
class PatientsRepository {
  Future<List<Patient>> fetchPatients() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const [
      Patient(
        id: '1',
        name: 'Sarah Johnson',
        pid: 'PT-2024-001',
        age: 28,
        gender: 'Female',
        phone: '9876543210',
        lastVisit: '20 May 2025',
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
        status: PatientStatus.completed,
      ),
      Patient(
        id: '2',
        name: 'Michael Chen',
        pid: 'PT-2024-045',
        age: 42,
        gender: 'Male',
        phone: '9821334455',
        lastVisit: '18 May 2025',
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
        status: PatientStatus.waiting,
      ),
      Patient(
        id: '3',
        name: 'Elena Rodriguez',
        pid: 'PT-2024-089',
        age: 35,
        gender: 'Female',
        phone: '9122334455',
        lastVisit: '15 May 2025',
        avatarUrl:
            'https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?w=200',
        status: PatientStatus.cancelled,
      ),
    ];
  }
}
