import 'package:flutter/material.dart';

import '../../../core/constants/typedef.dart';
import '../../../core/presentation/components/custom_widgets.dart';
import '../../../core/utils.dart';

class AddressByWardCode extends StatelessWidget {
  const AddressByWardCode({
    super.key,
    required this.futureData,
    this.style,
    this.prefix = '',
    this.showDirection = false,
  });

  final FRespData<String> futureData;
  final String prefix;
  final TextStyle? style;
  final bool showDirection;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final respEither = snapshot.data!;
          return respEither.fold(
            (error) => MessageScreen.error(error.message),
            (ok) => Row(
              children: [
                Expanded(child: Text('$prefix${ok.data!}', style: style)),
                if (showDirection)
                  IconButton(
                      onPressed: () {
                        LaunchUtils.openMapWithQuery(ok.data!);
                      },
                      icon: const Icon(Icons.directions, color: Colors.blue)),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return MessageScreen.error(snapshot.error.toString());
        }
        return const Text(
          'Đang tải địa chỉ...',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        );
      },
    );
  }
}
