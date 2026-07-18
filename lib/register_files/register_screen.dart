import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/core/widget/custom_dropdown_field.dart';
import 'package:medicompare/core/widget/custom_textfield.dart';
import 'package:medicompare/register_files/doctor_registration_bloc.dart';

const _purple = Color(0xFF5B2A8C);
const _darkTeal = Color(0xFF17252A);

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorRegistrationBloc(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _fullNameController = TextEditingController();
  final _regNumberController = TextEditingController();
  final _clinicController = TextEditingController();
  final _locationController = TextEditingController();

  static const _genders = ['Select gender', 'Male', 'Female', 'Other'];
  static const _specializations = [
    'Cardiology',
    'Neurology',
    'Dermatology',
    'Pediatrics',
    'Orthopedics',
    'General Medicine',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _regNumberController.dispose();
    _clinicController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<DoctorRegistrationBloc, DoctorRegistrationState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == DoctorRegistrationStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registered successfully!')),
            );
          }
        },
        //   listener: (BuildContext context, DoctorRegistrationState state) {},
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: _buildForm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(1.0, -1.0),
          radius: 1.3,
          colors: [Color(0xFFE9DDF7), Colors.white],
          stops: [0.0, 0.7],
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 24,
        right: 24,
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
              ),
              // const Expanded(child: Center(child: _MediComparesLogo())),
              const SizedBox(width: 24), // balances the back button
            ],
          ),
          _buildLogo(),
          const SizedBox(height: 16),
          Center(
            child: const Text(
              'Register as New Doctor',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: _darkTeal,
                fontFamily: "Poppins",
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: const Text(
              'Please enter your phone number to Log in your account',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: _darkTeal,
                fontFamily: "Poppins",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        "assets/images/applogo.png",
        width: 87,
        height: 36,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final bloc = context.read<DoctorRegistrationBloc>();

    return BlocBuilder<DoctorRegistrationBloc, DoctorRegistrationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container(
            //   padding: EdgeInsets.all(8),
            //   child: Text(
            //     "Full Name",
            //     style: TextStyle(
            //       fontSize: 11,
            //       fontWeight: FontWeight.w500,
            //       color: _darkTeal,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 8),
            CustomTextField(
              label: 'Full Name',
              controller: _fullNameController,
              // errorText: state.errorMessage,
              onChanged: (v) => bloc.add(FullNameChanged(v)),
              hintText: 'Dr. Jonathan Doe',
            ),
            SizedBox(height: 16),
            CustomDropdownField(
              label: 'Gender',
              hintText: 'Select gender',
              value: state.gender.isEmpty ? null : state.gender,
              items: _genders,
              onChanged: (v) {
                if (v != null) bloc.add(GenderChanged(v));
              },
            ),
            SizedBox(height: 16),

            CustomDropdownField(
              label: 'Specialization',
              hintText: 'E.g. Cardiology',
              value: state.specialization.isEmpty ? null : state.specialization,
              items: _specializations,
              onChanged: (v) {
                if (v != null) bloc.add(SpecializationChanged(v));
              },
            ),
            SizedBox(height: 16),
            CustomTextField(
              label: 'Medical Registration Number',
              hintText: 'MC-12345678',
              controller: _regNumberController,
              errorText: state.errorMessage,
              onChanged: (v) => bloc.add(MedicalRegNumberChanged(v)),
            ),
            SizedBox(height: 16),
            CustomTextField(
              label: 'Clinic / Hospital Name',
              hintText: "St. Mary's General Hospital",
              controller: _clinicController,
              errorText: state.errorMessage,
              onChanged: (v) => bloc.add(ClinicNameChanged(v)),
            ),
            SizedBox(height: 16),
            CustomTextField(
              label: 'Location',
              hintText: 'New York, NY',
              controller: _locationController,
              errorText: state.errorMessage,
              trailingIcon: const Icon(
                Icons.location_on,
                color: Colors.redAccent,
              ),
              onChanged: (v) => bloc.add(LocationChanged(v)),
            ),
            const SizedBox(height: 8),
            _buildRegisterButton(context, state, bloc),
            const SizedBox(height: 20),
            _buildLoginRow(context),
          ],
        );
      },
    );
  }

  Widget _buildRegisterButton(
    BuildContext context,
    DoctorRegistrationState state,
    DoctorRegistrationBloc bloc,
  ) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: state.status == DoctorRegistrationStatus.submitting
            ? null
            : () => bloc.add(const RegisterSubmitted()),
        style: ElevatedButton.styleFrom(
          backgroundColor: _purple,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: state.status == DoctorRegistrationStatus.submitting
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  Widget _buildLoginRow(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.of(context).maybePop(),
        child: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 14, color: Colors.black87),
            children: [
              TextSpan(
                text: 'Already have an account? ',
                style: TextStyle(
                  fontSize: 14,
                  color: _darkTeal,
                  height: 1.4,
                  // fontWeight: FontWeight.bold,
                  //  fontFamily: "Inter",
                ),
              ),
              TextSpan(
                text: 'Log in',
                style: TextStyle(
                  fontSize: 14,
                  color: _purple,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Inter",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: unused_element
class _MediComparesLogo extends StatelessWidget {
  const _MediComparesLogo();

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'medi\n',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: _purple,
              height: 1.0,
            ),
          ),
          TextSpan(
            text: 'compares',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _purple,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
