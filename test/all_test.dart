// ignore_for_file: avoid_print

// import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

const double x1 = 1234.38456243;
const double x2 = 834576.9877865;
const double x3 = 3945867435.9877865;
const double x4 = 8437563.9877865;
const double x5 = 834675.9877865;
const double x6 = 934756.9877865;
const double x7 = 283458976.9877865;
const double x8 = 433.9877865;

void main0() {
  test('test roundDouble', () async {
    print(roundDouble(x1));
    print('--------------------------------------------');
    print(roundDouble(x2));
    print('--------------------------------------------');
    print(roundDouble(x3));
    print('--------------------------------------------');
    print(roundDouble(x4));
    print('--------------------------------------------');
    print(roundDouble(x5));
    print('--------------------------------------------');
    print(roundDouble(x6));
    print('--------------------------------------------');
    print(roundDouble(x7));
    print('--------------------------------------------');
    print(roundDouble(x8));
  });
}

int? roundDouble(double value) {
  final String valueString = value.toStringAsFixed(0);
  if (valueString.length < 3) return null;

  String first = valueString[0];
  String second = valueString[1];
  // String third = valueString[2];
  print('firstPart: $first');
  print('second: $second');
  // print('third: $third');

  int? firstNum = int.tryParse(first);
  int? secondNum = int.tryParse(second);
  // int? thirdNum = int.tryParse(third);
  if (firstNum == null || secondNum == null) return null; //! review

  if (secondNum >= 5 && secondNum <= 9) {
    firstNum++;
    secondNum = 0;
  } else if (secondNum < 5 && secondNum >= 0) {
    secondNum = 5;
  }

  final roundedValue = firstNum.toString() + secondNum.toString();
  final roundedValueString = roundedValue + '0' * (valueString.length - 2);
  print(formatWithSuffix(roundedValueString));

  return int.tryParse(roundedValueString);
}

String round(double value) {
  final String valueString = value.toStringAsFixed(0);
  String suffix = '';

  if (valueString.length > 12) {
    suffix = 'T';
  } else if (valueString.length > 9) {
    suffix = 'B';
  } else if (valueString.length > 6) {
    suffix = 'M';
  } else if (valueString.length > 3) {
    suffix = 'K';
  }
  return suffix;
}

void main() {
  test('test formatWithSuffix', () async {
    print(formatWithSuffix('1234'));
    print('--------------------------------------------');
    print(formatWithSuffix('123456'));
    print(formatWithSuffix('123456134', 1));
    print(formatWithSuffix('13245643132', 1));
    print(formatWithSuffix('1236356546', 1));
    print('--------------------------------------------');
  });
}

String formatWithSuffix(String value, [int fraction = 0, String separator = '.', bool extra = false]) {
  if (value.length < 4) return value;

  final int length = value.length;
  return mainValue(value, length) + subValue(value, fraction, separator, extra) + suffix(length);
}

int maxDigitsCanTake(int length) {
  if (length < 4) return 0;

  switch (length) {
    case 4 || 7 || 10 || 13:
      return length - 1; // eg: 1234 => 3, 1234567 => 6
    case 5 || 8 || 11 || 14:
      return length - 2; // eg: 12345 => 3, 12345678 => 6
    case 6 || 9 || 12 || 15:
      return length - 3; // eg: 123456 => 3, 123456789 => 6
    default:
      throw const FormatException('Invalid length');
  }
}

String mainValue(String value, int length) {
  if (value.length < 4) return value;

  final int endSub;
  switch (length) {
    case 4 || 7 || 10 || 13:
      endSub = 1;
    case 5 || 8 || 11 || 14:
      endSub = 2;
    case 6 || 9 || 12 || 15:
      endSub = 3;
    default:
      throw const FormatException('Invalid length');
  }
  return value.substring(0, endSub);
}

String subValue(String value, int fraction, String separator, bool extra) {
  if (fraction == 0) return '';

  if (value.length < 4) return '';

  final int startSub;
  switch (value.length) {
    case 4 || 7 || 10 || 13:
      startSub = 1;
    case 5 || 8 || 11 || 14:
      startSub = 2;
    case 6 || 9 || 12 || 15:
      startSub = 3;
    default:
      throw const FormatException('Invalid length');
  }

  final max = maxDigitsCanTake(value.length);
  if (fraction <= max) {
    return separator + value.substring(startSub, startSub + fraction);
  } else {
    if (!extra) return separator + value.substring(startSub, startSub + max);
    return separator + value.substring(startSub, startSub + max) + '0' * (fraction - max);
  }
}

const thousandCurrencyUnit = 'K'; // stands for thousand
const millionCurrencyUnit = 'M'; // stands for million
const billionCurrencyUnit = 'B'; // stands for billion
const trillionCurrencyUnit = 'T'; // stands for trillion

String suffix(int length) {
  if (length < 4) return '';

  if (length > 12) {
    return trillionCurrencyUnit;
  } else if (length > 9) {
    return billionCurrencyUnit;
  } else if (length > 6) {
    return millionCurrencyUnit;
  } else if (length > 3) {
    return thousandCurrencyUnit;
  }
  throw const FormatException('Invalid length');
}
