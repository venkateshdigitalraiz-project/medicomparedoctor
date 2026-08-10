import 'package:flutter/material.dart';

class ConsultationFeeCard extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const ConsultationFeeCard({
    super.key,
    required this.controller,
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
            "Consultation Fee",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              fontFamily: "Poppins",
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            decoration: InputDecoration(
              //  prefixText: "₹ ",
              hintText: "₹  120.00",
              hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
              ),
              filled: true,
              fillColor: const Color(0xffF3F6FC),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
