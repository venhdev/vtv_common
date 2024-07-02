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
      controller: TextEditingController(text: readOnly ? 'Ghi chú: $note' : note),
      decoration: const InputDecoration(
        hintText: 'Ghi chú cho người bán (nếu có)',
        // enabledBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(color: Colors.grey),
        // ),
        border: InputBorder.none, // no border
        hintStyle: TextStyle(color: Colors.grey),
      ),
      onChanged: onChanged,
    );
  }
}
