import 'package:flutter/material.dart';

class OrderSectionNote extends StatelessWidget {
  const OrderSectionNote({
    super.key,
    required this.note,
    this.readOnly = false,
    this.onChanged,
  });

  final String note;
  final bool readOnly;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      style: const TextStyle(fontSize: 14),
      // controller: TextEditingController(text: _placeOrderWithCartParam.note),
      controller: TextEditingController(text: note),
      decoration: const InputDecoration(
        hintText: 'Ghi chú',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        hintStyle: TextStyle(color: Colors.grey),
      ),
      onChanged: onChanged,
      // onChanged: (value) {
      //   // onLocalNoteOrderRequestChanged(value);
      //   // _placeOrderWithCartParam = _placeOrderWithCartParam.copyWith(note: value);
      // },
    );
  }
}
