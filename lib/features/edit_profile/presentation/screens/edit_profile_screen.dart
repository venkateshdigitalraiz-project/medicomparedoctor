import 'package:flutter/material.dart';
import 'package:medicompare/core/widget/app_loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/edit_profile/presentation/bloc/edit_profile_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileBloc(
        initialState: const EditProfileState(
          fullName: 'Dr. Jonathan Doe',
          regNumber: 'MC-12345678',
          clinicName: "St. Mary's General Hospital",
          location: 'New York, NY',
        ),
      ),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatelessWidget {
  const _EditProfileView();

  static const _purple = Color(0xFF601CA3);
  static const _headerBlue = Color(0xFFEFF6FF);

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileBloc, EditProfileState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        } else if (state.status == FormStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _Header(headerColor: _headerBlue),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _LabeledTextField(
                        label: 'Full Name',
                        hint: 'Dr. Jonathan Doe',
                        selector: (s) => s.fullName,
                        onChanged: (context, value) => context
                            .read<EditProfileBloc>()
                            .add(FullNameChanged(value)),
                      ),
                      _LabeledDropdown(
                        label: 'Gender',
                        hint: 'Select gender',
                        items: const ['Male', 'Female', 'Other'],
                        selector: (s) => s.gender,
                        onChanged: (context, value) => context
                            .read<EditProfileBloc>()
                            .add(GenderChanged(value)),
                      ),
                      _LabeledDropdown(
                        label: 'Specialization',
                        hint: 'E.g. Cardiology',
                        items: const [
                          'Cardiology',
                          'Dermatology',
                          'Neurology',
                          'Pediatrics',
                          'Orthopedics',
                        ],
                        selector: (s) => s.specialization,
                        onChanged: (context, value) => context
                            .read<EditProfileBloc>()
                            .add(SpecializationChanged(value)),
                      ),
                      _LabeledTextField(
                        label: 'Medical Registration Number',
                        hint: 'MC-12345678',
                        selector: (s) => s.regNumber,
                        onChanged: (context, value) => context
                            .read<EditProfileBloc>()
                            .add(MedicalRegNumberChanged(value)),
                      ),
                      _LabeledTextField(
                        label: 'Clinic / Hospital Name',
                        hint: "St. Mary's General Hospital",
                        selector: (s) => s.clinicName,
                        onChanged: (context, value) => context
                            .read<EditProfileBloc>()
                            .add(ClinicNameChanged(value)),
                      ),
                      _LabeledTextField(
                        label: 'Location',
                        hint: 'New York, NY',
                        selector: (s) => s.location,
                        onChanged: (context, value) => context
                            .read<EditProfileBloc>()
                            .add(LocationChanged(value)),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                          onPressed: () => context.read<EditProfileBloc>().add(
                            const LocationPinTapped(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: BlocBuilder<EditProfileBloc, EditProfileState>(
                  builder: (context, state) {
                    final isSubmitting = state.status == FormStatus.submitting;
                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        onPressed: isSubmitting
                            ? null
                            : () => context.read<EditProfileBloc>().add(
                                const ApplyPressed(),
                              ),
                        child: isSubmitting
                            ? SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    AppLoader(
                                      color: Colors.white,
                                      size: 22,
                                    ),
                              )
                            : const Text(
                                'Apply',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Color headerColor;
  const _Header({required this.headerColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 16),
          const Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

/// A labeled text field bound to a specific piece of Bloc state.
class _LabeledTextField extends StatefulWidget {
  final String label;
  final String hint;
  final String Function(EditProfileState) selector;
  final void Function(BuildContext, String) onChanged;
  final Widget? trailing;

  const _LabeledTextField({
    required this.label,
    required this.hint,
    required this.selector,
    required this.onChanged,
    this.trailing,
  });

  @override
  State<_LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<_LabeledTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initial = widget.selector(context.read<EditProfileBloc>().state);
    _controller = TextEditingController(text: initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: (value) => widget.onChanged(context, value),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: const TextStyle(
                      color: Colors.black87,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: _EditProfileView._purple),
                    ),
                  ),
                ),
              ),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

/// A labeled dropdown bound to a specific piece of Bloc state.
class _LabeledDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final List<String> items;
  final String Function(EditProfileState) selector;
  final void Function(BuildContext, String) onChanged;

  const _LabeledDropdown({
    required this.label,
    required this.hint,
    required this.items,
    required this.selector,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
      buildWhen: (previous, current) => selector(previous) != selector(current),
      builder: (context, state) {
        final currentValue = selector(state);
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
                  value: currentValue.isEmpty ? null : currentValue,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  hint: Text(
                    hint,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: _EditProfileView._purple),
                    ),
                  ),
                  items: items
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onChanged(context, value);
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
