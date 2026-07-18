import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool enabled;
  final int maxLines;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final String? errorText;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.suffixIcon,
    this.onChanged,
    this.onTap,
    this.errorText,
    this.leadingIcon,
    this.trailingIcon,
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
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 10),

        /// TextField
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          enabled: enabled,
          maxLines: maxLines,
          onTap: onTap,
          onChanged: onChanged,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF17252A),
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF17252A),
            ),
            errorText: errorText,
            prefixIcon: leadingIcon,
            suffixIcon: trailingIcon,
            contentPadding: const EdgeInsets.only(bottom: 12),

            border: InputBorder.none,

            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE5E5E5), width: 1),
            ),

            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF6527A8), width: 2),
            ),

            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.5),
            ),

            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
