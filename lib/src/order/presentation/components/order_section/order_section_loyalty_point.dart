import 'package:flutter/material.dart';

import '../wrapper.dart';

class OrderSectionLoyaltyPoint extends StatelessWidget {
  const OrderSectionLoyaltyPoint({
    super.key,
    required this.totalPoint,
    required this.isUsingLoyaltyPoint,
    required this.onChanged,
  });

  final int totalPoint;
  final bool isUsingLoyaltyPoint;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      useBoxShadow: false,
      border: Border.all(color: Colors.grey.shade300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sử dụng điểm tích lũy', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                'Điểm hiện có: $totalPoint',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          Switch(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: isUsingLoyaltyPoint,
            onChanged: totalPoint == 0
                ? null
                : (value) {
                    onChanged(value);
                  },
          ),
        ],
      ),
    );
  }
}
