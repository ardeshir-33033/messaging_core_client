import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:messaging_core/core/utils/date_time_utils.dart';
import 'package:messaging_core/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    if (now.month == month && year == now.year && day == now.day) {
      return "Today";
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
}
