import 'package:flutter/material.dart';

class OutlineTextFieldLabel extends StatelessWidget {
  const OutlineTextFieldLabel({super.key, required this.label, required this.isRequired});

  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isRequired)
          const Text(
            '* ',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        Text(
          '$label ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
    // return Text.rich(
    //   TextSpan(
    //     text: '$label ',
    //     style: const TextStyle(
    //       fontSize: 14,
    //       fontWeight: FontWeight.w500,
    //     ),
    //     children: isRequired
    //         ? [
    //             const TextSpan(
    //               text: '*',
    //               style: TextStyle(
    //                 color: Colors.red,
    //               ),
    //             ),
    //           ]
    //         : null,
    //   ),
    // );
  }
}

class OutlineTextField extends StatelessWidget {
  const OutlineTextField({
    super.key,
    this.controller,
    required this.label,
    this.hintText,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.suffixIcon,
    this.prefixIcon,
    this.isRequired = true,
    this.obscureText = false,
    this.checkEmpty = true,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.initialValue,
    this.borderSideWidth = 2.0,
    this.onChanged,
    this.onFieldSubmitted,
    this.contentPadding,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final String label;
  final String? hintText;
  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  final bool isRequired;
  final bool obscureText;
  final bool checkEmpty;
  final TextInputType? keyboardType;

  final double borderSideWidth;

  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  // properties for touchable text field
  final bool readOnly;
  final VoidCallback? onTap;
  final String? initialValue;
  final int? maxLines;
  

  // style properties
 final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          initialValue: initialValue,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: contentPadding,
            label: OutlineTextFieldLabel(label: label, isRequired: isRequired),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: focusedBorderColor ?? Theme.of(context).colorScheme.primaryContainer,
                width: borderSideWidth,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: enabledBorderColor ?? const Color(0xFF000000),
                width: borderSideWidth,
              ),
            ),
          ),
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty && checkEmpty) {
                  return 'Chưa nhập ${label.toLowerCase()}';
                }
                return null;
              },
        ),
      ],
    );
  }
}
