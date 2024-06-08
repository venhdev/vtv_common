import 'package:flutter/material.dart';

class ListDynamic extends StatelessWidget {
  const ListDynamic({super.key, required this.list});

  final Map<String, String> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final entry in list.entries) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(entry.key)),
              Expanded(child: Text(entry.value, textAlign: TextAlign.end)),
            ],
          ),
        ],
      ],
    );
  }
}
