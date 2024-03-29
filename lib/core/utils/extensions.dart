import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:messaging_core/app/widgets/snack_bar_widget.dart';
import 'package:messaging_core/core/utils/date_time_utils.dart';
import 'package:messaging_core/l10n/app_localizations.dart';
import 'package:messaging_core/main.dart';

import 'package:path/path.dart';

extension GetItEx on GetIt {
  T getOrRegisterSingleton<T extends Object>(
    T Function() constructor, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<T>? dispose,
  }) {
    if (isRegistered<T>()) {
      return call<T>();
    } else {
      return registerSingleton<T>(
        constructor(),
        instanceName: instanceName,
        signalsReady: signalsReady,
        dispose: dispose,
      );
    }
  }

  void getOrRegisterFactory<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    String? instanceName,
  }) {
    if (!isRegistered<T>()) {
      registerFactory<T>(factoryFunc, instanceName: instanceName);
    }
  }
}

extension DateTimeEx on DateTime {
  String messageFormat() {
    return DateFormat('MM/dd hh:mm').format(this);
  }

  String callFormat() {
    return DateFormat('yyyy/MM/dd hh:mm').format(this);
  }

  bool isToday() {
    DateTime today = DateTime.now();
    return year == today.year && month == today.month && day == today.day;
  }

  bool isYesterday() {
    DateTime yesterday = DateTime.now().copyWith(day: DateTime.now().day - 1);
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  String clockFormat() {
    return DateFormat('HH:mm').format(this);
  }

  bool isNotSameDateAs(DateTime dateTime) {
    return year != dateTime.year ||
        month != dateTime.month ||
        day != dateTime.day;
  }

  String getContentDateFromNow() {
    DateTime now = DateTime.now();
    Duration differenceDuration = DateTime.now().difference(this);
    if (year != now.year) {
      if (differenceDuration.inDays > 365) {
        return "${DateTimeUtils.getMonthList()[month - 1]} $day, $year";
      }
      return "${DateTimeUtils.getMonthList()[month - 1]} $day";
    }
    if (now.month == month && year == now.year) {
      if (now.day == day) {
        return "Today";
      }
      if (differenceDuration < const Duration(days: 7)) {
        if (differenceDuration < const Duration(days: 1)) {
          return "Yesterday";
        } else {
          return DateFormat('EEEE').format(this);
        }
      }
    }

    return "${DateTimeUtils.getMonthList()[month - 1]} $day";
  }
}

extension IntegerExtensions on int {
  String get twoDigitConvert {
    if (this < 10) {
      return "0$this";
    }
    return toString();
  }

  String timeFormat() {
    int minutes = this ~/ 60;
    int seconds = this - minutes * 60;
    return "${minutes.convertToTwoDigits()}:${seconds.convertToTwoDigits()}";
  }

  String convertToTwoDigits() {
    return this > 9 ? "$this" : "0$this";
  }

  String formatDuration() {
    final duration = Duration(seconds: this);
    final minutes = duration.inMinutes;
    final seconds = this % 60;
    final minutesString = '$minutes';
    final secondsString = '$seconds';
    if (minutes < 1) {
      if (seconds < 2) {
        return '$secondsString ${"Second"}';
      } else {
        return '$secondsString ${"Seconds"}';
      }
    } else {
      if (minutes < 2) {
        return '$minutesString ${"Minute"}';
      } else {
        return '$minutesString ${"Minutes"}';
      }
    }
  }

  Color colorFromId() {
    int lastDigit = this % 10;
    List<Color> colors = [
      const Color(0xFFA5A6F6),
      const Color(0xFFFFAEAE),
      const Color(0xFF4DB1AE),
      const Color(0xFF6F5EAE),
      const Color(0xFF8FAEAE),
      const Color(0xFFAE6741),
      const Color(0xFFAE517B),
      const Color(0xFFA7AEA2),
      const Color(0xFF8C7F38),
      const Color(0xFF2E461A),
    ];

    return colors[lastDigit];
  }
}

extension StringEx on String {
  String midEllipsis({int head = 8, int tail = 8}) {
    if (length > head + tail) {
      return '${substring(0, head)}...${substring(length - tail, length)}';
    }
    return this;
  }

  String ellipsis({int head = 20}) {
    if (length > head) {
      return substring(0, head);
    }
    return this;
  }

  String toHex() {
    return '0x$this';
  }

  String toHexIfNeeded() {
    if (startsWith('0x')) return this;
    return '0x$this';
  }

  bool isContain(String query) {
    return toLowerCase().contains(query.toLowerCase());
  }

  String toDatetime() {
    return DateFormat('MMMM dd yyyy – hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(this)));
  }

  String hourAmFromDate() {
    return DateFormat('hh:mm a').format(DateTime.parse(this).toLocal());
  }

  String get firstLetterUpperCase {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String get firstOrEmpty {
    if (length >= 1) {
      return this[0];
    } else {
      return '';
    }
  }

  String concat(String? str) {
    return this + (str ?? "");
  }
}

extension NullableStringEx on String? {
  bool isNullOrEmpty() {
    if (this == null || (this?.isEmpty ?? true)) {
      return true;
    }
    return false;
  }
}

extension ListEx<T> on Iterable<T> {
  T? firstOrNull() {
    if (isEmpty) {
      return null;
    } else {
      return first;
    }
  }

  T? randomItem() {
    if (isEmpty) {
      return null;
    } else {
      return elementAt(Random().nextInt(length));
    }
  }

  T? lastOrNull() {
    if (isEmpty) {
      return null;
    } else {
      return last;
    }
  }

  T? firstWhereOrNull(bool Function(T element) test) {
    try {
      return firstWhere((element) => test(element));
    } catch (e) {
      return null;
    }
  }

  T? maxBy(int Function(T element) selector) {
    int? maxValue;
    T? maxElement;
    forEach((element) {
      if (maxValue == null || selector(element) > maxValue!) {
        maxValue = selector(element);
        maxElement = element;
      }
    });

    return maxElement;
  }
}

extension TranslationHelperStateless on StatelessWidget {
  AppLocalizations tr(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
}

extension TranslationHelperStateful<T extends StatefulWidget> on State<T> {
  AppLocalizations tr(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
}

extension BuildContextHelper on BuildContext {
  AppLocalizations get l {
    // if no locale was found, returns a default
    return AppLocalizations.of(this)!;
  }

  double get screenWidth {
    return MediaQuery.sizeOf(this).width;
  }

  double get screenHeight {
    return MediaQuery.sizeOf(this).height;
  }

  double heightPercentage(double percentage) {
    return MediaQuery.sizeOf(this).height * (percentage / 100);
  }

  double widthPercentage(double percentage) {
    return MediaQuery.sizeOf(this).width * (percentage / 100);
  }

  void showSuccessSnackBar(String title) {
    SnackBarWidget.showSuccessSnackBar(this, title);
  }

  void showFailedSnackBar(String? title) {
    SnackBarWidget.showFailedSnackBar(this, title);
  }
}

extension NumExtension on num {
  EdgeInsets get top {
    return EdgeInsets.only(top: toDouble());
  }

  EdgeInsets get bottom {
    return EdgeInsets.only(bottom: toDouble());
  }

  EdgeInsets get left {
    return EdgeInsets.only(left: toDouble());
  }

  EdgeInsets get right {
    return EdgeInsets.only(right: toDouble());
  }

  EdgeInsets get horizontal {
    return EdgeInsets.symmetric(horizontal: toDouble());
  }

  EdgeInsets get vertical {
    return EdgeInsets.symmetric(vertical: toDouble());
  }
}
