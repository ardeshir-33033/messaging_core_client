import 'dart:ui';

import 'package:intl/intl.dart' as intl;
import 'package:messaging_core/core/utils/extensions.dart';

TextDirection directionOf(String text) {
  return intl.Bidi.startsWithRtl(text.firstOrEmpty)
      ? TextDirection.rtl
      : TextDirection.ltr;
}
