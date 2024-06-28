import 'package:flutter_test/flutter_test.dart';
import 'package:vtv_common/src/core/utils.dart';
// ignore_for_file: avoid_print

void main() {

  test('uri test', () {
    print('path connect: ${Creator.uriPath(
      path: '/room/:roomChatId/chat',
      pathVariables: {'roomChatId': 'b01c7503-31a2-4f9b-a0fd-165620103740'},
    )}');
  });
  test('test formatWithSuffix', () async {
    print(formatCurrencyWithAbbreviation('12', fraction: 10));
    print(formatCurrencyWithAbbreviation('1', fraction: 10, extra: true));
    print(formatCurrencyWithAbbreviation('12', fraction: 10, extra: true));
    print(formatCurrencyWithAbbreviation('123', fraction: 10, extra: true));
    print(formatCurrencyWithAbbreviation('1234', fraction: 4, extra: true));
    // print(formatCurrencyWithAbbreviation('1234'));
    // print('--------------------------------------------');
    // print(formatCurrencyWithAbbreviation('123456', fraction: 1));
    // print(formatCurrencyWithAbbreviation('123456134', fraction: 2));
    // print(formatCurrencyWithAbbreviation('13245643132', fraction: 3));
    // print(formatCurrencyWithAbbreviation('1236356546', fraction: 4));
    // print('--------------------------------------------');
    // print(ceilTo5FirstTwoDigits(1234));
    // print(ceilTo5FirstTwoDigits(123456));
    // print(ceilTo5FirstTwoDigits(123456134));
    // print(ceilTo5FirstTwoDigits(13245643132));
    // print(ceilTo5FirstTwoDigits(1236356546));
    // print('--------------------------------------------');
  });
}

const _defaultSeparator = '.';
const _defaultHundredAbbreviation = ''; // hundred
const _defaultThousandAbbreviation = 'K'; // thousand
const _defaultMillionAbbreviation = 'M'; // million
const _defaultBillionAbbreviation = 'B'; // billion
const _defaultTrillionAbbreviation = 'T'; // trillion

int ceilTo5FirstTwoDigits(double value) {
  //# 0 value
  if (value == 0) return 0;

  //# 1 digit value: 1-9
  if (value < 10) {
    if (value >= 5) return 10;
    return 5;
  }

  //# 2+ digits value: >= 10
  final String valueString = value.toStringAsFixed(0);
  final String first = valueString[0];
  final String second = valueString[1];

  int firstNum = int.parse(first);
  int secondNum = int.parse(second);

  if (secondNum >= 5 && secondNum <= 9) {
    firstNum++;
    secondNum = 0;
  } else if (secondNum < 5 && secondNum >= 0) {
    secondNum = 5;
  }

  final roundedValue = firstNum.toString() + secondNum.toString();
  final roundedValueString = roundedValue + '0' * (valueString.length - 2);
  print('roundedValueString: ${formatCurrencyWithAbbreviation(roundedValueString, fraction: 1)}');

  return int.parse(roundedValueString);
}

String formatCurrencyWithAbbreviation(
  String value, {
  int fraction = 0,
  String separator = _defaultSeparator,
  bool extra = false,
  String hundredAbbreviation = _defaultHundredAbbreviation,
  String thousandAbbreviation = _defaultThousandAbbreviation,
  String millionAbbreviation = _defaultMillionAbbreviation,
  String billionAbbreviation = _defaultBillionAbbreviation,
  String trillionAbbreviation = _defaultTrillionAbbreviation,
}) {
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

  /// this [showExtra] is used to show extra zeros if the fraction is greater than the maxDigitsCanTake
  String subValue(String value, int fraction, String separator, bool showExtra) {
    if (fraction == 0 || value.length < 4) return '';

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
      if (!showExtra) return separator + value.substring(startSub, startSub + max);
      return separator + value.substring(startSub, startSub + max) + '0' * (fraction - max);
    }
  }

  String suffix(int length) {
    if (length > 12) {
      return trillionAbbreviation;
    } else if (length > 9) {
      return billionAbbreviation;
    } else if (length > 6) {
      return millionAbbreviation;
    } else if (length > 3) {
      return thousandAbbreviation;
    } else if (length > 0) {
      return hundredAbbreviation;
    }
    throw const FormatException('Invalid length');
  }

  assert(value.isNotEmpty, 'value must not be empty');
  if (value.length < 4) return value;

  final int length = value.length;
  return mainValue(value, length) + subValue(value, fraction, separator, extra) + suffix(length);
}
