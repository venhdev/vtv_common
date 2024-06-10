import 'package:flutter/material.dart';

class FlexibleList extends StatelessWidget {
  const FlexibleList({super.key, required this.list, this.separatorBuilder, this.topBuilder, this.bottomBuilder});

  final Map<String, String> list;
  final WidgetBuilder? separatorBuilder;
  final WidgetBuilder? topBuilder;
  final WidgetBuilder? bottomBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (topBuilder != null) topBuilder!(context),
        for (int i = 0; i < list.length; i++) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 1, child: Text(list.keys.elementAt(i), textAlign: TextAlign.start)),
              Expanded(flex: 1, child: Text(list.values.elementAt(i), textAlign: TextAlign.end)),
            ],
          ),
          if (separatorBuilder != null && i < list.length - 1) separatorBuilder!(context)
        ],
        if (bottomBuilder != null) bottomBuilder!(context)
      ],
    );
  }
}
