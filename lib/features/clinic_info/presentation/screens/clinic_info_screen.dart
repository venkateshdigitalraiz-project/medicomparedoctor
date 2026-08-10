import 'package:flutter/material.dart';
import 'package:medicompare/core/widget/app_loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/clinic_info/presentation/bloc/clinic_cubit.dart';
import 'package:medicompare/features/clinic_info/data/models/clinic_model.dart';
import 'package:medicompare/features/clinic_info/presentation/widgets/info_card.dart';

class ClinicInfoScreen extends StatelessWidget {
  const ClinicInfoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClinicCubit()..loadClinicInfo(),
      child: const _ClinicInfoView(),
    );
  }
}

class _ClinicInfoView extends StatelessWidget {
  const _ClinicInfoView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAppBar(context),
            Expanded(
              child: BlocBuilder<ClinicCubit, ClinicState>(
                builder: (context, state) {
                  if (state is ClinicLoading) {
                    return Center(
                      child: AppLoader(
                        color: const Color(0xFF6D28D9),
                        size: 40,
                      ),
                    );
                  }

                  if (state is ClinicError) {
                    return _ErrorView(
                      message: state.message,
                      onRetry: () =>
                          context.read<ClinicCubit>().loadClinicInfo(),
                    );
                  }

                  final clinic = (state as ClinicLoaded).clinic;
                  return _ClinicBody(clinic: clinic);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE9F1FE),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.maybePop(context),
          ),
          const SizedBox(width: 16),
          const Text(
            'Clinic Information',
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClinicBody extends StatelessWidget {
  final ClinicModel clinic;
  const _ClinicBody({required this.clinic});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: [
        // ---- Clinic overview card ----
        InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE5E7EB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Color(0xFF601CA3),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clinic.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          clinic.tagline,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ContactRow(
                icon: Icons.call,
                text: clinic.phone,
                iconBackground: Colors.green,
                iconColor: Colors.white,
              ),
              ContactRow(
                icon: Icons.email,
                text: clinic.email,
                iconBackground: Colors.white,
                iconColor: Colors.red,
              ),
              ContactRow(
                icon: Icons.location_on,
                text: clinic.address,
                iconBackground: Colors.white,
                iconColor: Colors.red,
              ),
            ],
          ),
        ),

        // ---- Clinic details card ----
        InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                icon: Icons.local_hospital,
                title: 'Clinic Details',
                iconBackground: Color(0xFFEDE7FA),
                iconColor: Color(0xFF601CA3),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, color: Color(0xFFEDEDF2)),
              ),
              DetailRow(label: 'Clinic Type', value: clinic.clinicType),
              const Divider(height: 1, color: Color(0xFFF1F1F5)),
              DetailRow(
                label: 'Registration No.',
                value: clinic.registrationNo,
              ),
              const Divider(height: 1, color: Color(0xFFF1F1F5)),
              DetailRow(
                label: 'GST Number',
                value: clinic.gstNumber,
                valueColor: const Color(0xFF7C4DFF),
              ),
            ],
          ),
        ),

        // ---- Working hours card ----
        InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                icon: Icons.access_time,
                title: 'Working Hours',
                iconBackground: Color(0xFFFCE9EC),
                iconColor: Color(0xFFE0486B),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, color: Color(0xFFEDEDF2)),
              ),
              for (int i = 0; i < clinic.workingHours.length; i++) ...[
                DetailRow(
                  label: clinic.workingHours[i].day,
                  value: clinic.workingHours[i].hours,
                  valueColor: clinic.workingHours[i].isClosed
                      ? const Color(0xFFE0483F)
                      : const Color(0xFF1A1A1A),
                ),
                if (i != clinic.workingHours.length - 1)
                  const Divider(height: 1, color: Color(0xFFF1F1F5)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
