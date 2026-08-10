import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/clinic_info/data/models/clinic_model.dart';

part 'clinic_state.dart';

class ClinicCubit extends Cubit<ClinicState> {
  ClinicCubit() : super(const ClinicLoading());

  Future<void> loadClinicInfo() async {
    emit(const ClinicLoading());
    try {
      // Simulate a network / repository call.
      await Future.delayed(const Duration(milliseconds: 400));

      final clinic = ClinicModel(
        name: 'City Heart Care Clinic',
        tagline: 'Comprehensive cardiac \ncare you can trust',
        phone: '+91 1234567890',
        email: 'contact@cityheart.com',
        address:
            '123 Medical Avenue, Central Square, Health District, NY 10001',
        clinicType: 'Specialized Hospital',
        registrationNo: 'REG-8829-001',
        gstNumber: '32AAAAA0000A1Z5',
        workingHours: const [
          WorkingHour(day: 'Monday – Friday', hours: '9:00 AM – 8:00 PM'),
          WorkingHour(day: 'Saturday', hours: '9:00 AM – 4:00 PM'),
          WorkingHour(day: 'Sunday', hours: 'Closed', isClosed: true),
        ],
      );

      emit(ClinicLoaded(clinic));
    } catch (e) {
      emit(ClinicError(e.toString()));
    }
  }
}
