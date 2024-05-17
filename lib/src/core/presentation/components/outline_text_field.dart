import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
    this.maxLength,
    this.onSaved,
    this.prefix,
    this.prefixText,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final TextEditingController? controller;
  final String label;
  final String? hintText;
  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? prefix;
  final String? prefixText;

  final bool isRequired;
  final bool obscureText;
  final bool checkEmpty;
  final TextInputType? keyboardType;

  final double borderSideWidth;

  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final void Function(String?)? onSaved;

  // properties for touchable text field
  final bool readOnly;
  final VoidCallback? onTap;
  final String? initialValue;
  final int? maxLines;
  final int? maxLength;

  // style properties
  final EdgeInsetsGeometry? contentPadding;

  // others
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            textCapitalization: textCapitalization,
            inputFormatters: inputFormatters,
            onSaved: onSaved,
            maxLength: maxLength,
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            readOnly: readOnly,
            onTap: onTap,
            maxLines: maxLines,
            initialValue: initialValue,
            autovalidateMode: autovalidateMode,
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: contentPadding,
              label: OutlineTextFieldLabel(label: label, isRequired: isRequired),
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              prefix: prefix,
              prefixText: prefixText,
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
        ),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

class DecimalFormatter extends TextInputFormatter {
  final int decimalDigits;

  DecimalFormatter({this.decimalDigits = 2}) : assert(decimalDigits >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText;

    if (decimalDigits == 0) {
      newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    } else {
      newText = newValue.text.replaceAll(RegExp('[^0-9\.]'), '');
    }

    if (newText.contains('.')) {
      //in case if user's first input is "."
      if (newText.trim() == '.') {
        return newValue.copyWith(
          text: '0.',
          selection: TextSelection.collapsed(offset: 2),
        );
      }
      //in case if user tries to input multiple "."s or tries to input
      //more than the decimal place
      else if ((newText.split(".").length > 2) || (newText.split(".")[1].length > this.decimalDigits)) {
        return oldValue;
      } else
        return newValue;
    }

    //in case if input is empty or zero
    if (newText.trim() == '' || newText.trim() == '0') {
      return newValue.copyWith(text: '');
    } else if (int.parse(newText) < 1) {
      return newValue.copyWith(text: '');
    }

    double newDouble = double.parse(newText);
    var selectionIndexFromTheRight = newValue.text.length - newValue.selection.end;

    String newString = NumberFormat("#,##0.##").format(newDouble);

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(
        offset: newString.length - selectionIndexFromTheRight,
      ),
    );
  }
}
