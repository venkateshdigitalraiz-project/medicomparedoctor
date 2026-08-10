import 'package:flutter/material.dart';
import 'package:medicompare/features/add_available/data/models/consultation_mode.dart';

class ConsultationModeCard extends StatelessWidget {
  final ConsultationMode selectedMode;
  final ValueChanged<ConsultationMode> onChanged;

  const ConsultationModeCard({
    super.key,
    required this.selectedMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Consultation Mode",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              fontFamily: "Poppins",
            ),
          ),

          const SizedBox(height: 18),

          _modeTile(
            mode: ConsultationMode.clinic,
            icon: Icons.local_hospital_outlined,
          ),

          const Divider(height: 24),

          _modeTile(
            mode: ConsultationMode.video,
            icon: Icons.videocam_outlined,
          ),

          const Divider(height: 24),

          _modeTile(mode: ConsultationMode.both, icon: Icons.sync_alt_outlined),
        ],
      ),
    );
  }

  Widget _modeTile({required ConsultationMode mode, required IconData icon}) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () => onChanged(mode),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xffF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xff6D28D9)),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  mode.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Radio<ConsultationMode>(
              //   value: mode,
              //   groupValue: selectedMode,
              //   activeColor: const Color(0xff6D28D9),
              //   onChanged: (value) {
              //     if (value != null) {
              //       onChanged(value);
              //     }
              //   },
              // ),
              Switch(
                value: selectedMode == mode,
                onChanged: (value) {
                  if (value) {
                    onChanged(mode);
                  }
                },
                thumbColor: WidgetStateProperty.all(Colors.white),
                activeTrackColor: const Color(0xFF601CA3),
                inactiveTrackColor: Colors.grey.shade300,
              ),
            ],
          ),
        );
      },
    );
  }
}
