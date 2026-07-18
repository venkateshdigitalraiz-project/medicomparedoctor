import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String hintText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label
        Text(
          label,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          icon: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          ),
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF17252A),
          ),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.only(bottom: 12),

            border: InputBorder.none,

            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE5E5E5), width: 1),
            ),

            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF6527A8), width: 2),
            ),
          ),
          hint: Text(
            hintText,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF17252A),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
