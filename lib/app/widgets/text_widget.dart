import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool? softWrap;
  final TextAlign? textAlign;
  final TextDirection? direction;
  final StrutStyle? strutStyle;
  final double? maxFontSize;
  final double? minFontSize;

  const TextWidget(
    this.text, {
    Key? key,
    this.overflow,
    this.maxLines,
    this.textAlign,
    this.softWrap,
    this.strutStyle,
    this.direction,
    this.maxFontSize,
    this.minFontSize,
    this.style,
  }) : super(key: key);

  TextWidget.bold(
    this.text, {
    Key? key,
    required BuildContext context,
    this.overflow,
    this.maxLines,
    this.textAlign,
    this.softWrap,
    this.strutStyle,
    this.direction,
    this.maxFontSize,
    this.minFontSize,
    TextStyle? additionalStyle,
  })  : style =
            const TextStyle(fontWeight: FontWeight.w700).merge(additionalStyle),
        super(key: key);

  TextWidget.semiBold(
    this.text, {
    Key? key,
    required BuildContext context,
    this.overflow,
    this.maxLines,
    this.textAlign,
    this.softWrap,
    this.strutStyle,
    this.direction,
    this.maxFontSize,
    this.minFontSize,
    TextStyle? additionalStyle,
  })  : style =
            const TextStyle(fontWeight: FontWeight.w600).merge(additionalStyle),
        super(key: key);

  TextWidget.medium(
    this.text, {
    Key? key,
    required BuildContext context,
    this.overflow,
    this.maxLines,
    this.textAlign,
    this.softWrap,
    this.strutStyle,
    this.direction,
    this.maxFontSize,
    this.minFontSize,
    TextStyle? additionalStyle,
  })  : style =
            const TextStyle(fontWeight: FontWeight.w500).merge(additionalStyle),
        super(key: key);

  TextWidget.regular(
    this.text, {
    Key? key,
    required BuildContext context,
    this.overflow,
    this.maxLines,
    this.textAlign,
    this.softWrap,
    this.strutStyle,
    this.direction,
    this.maxFontSize,
    this.minFontSize,
    TextStyle? additionalStyle,
  })  : style =
            const TextStyle(fontWeight: FontWeight.w400).merge(additionalStyle),
        super(key: key);

  TextWidget.light(
    this.text, {
    Key? key,
    required BuildContext context,
    this.overflow,
    this.maxLines,
    this.textAlign,
    this.softWrap,
    this.strutStyle,
    this.direction,
    this.maxFontSize,
    this.minFontSize,
    TextStyle? additionalStyle,
  })  : style =
            const TextStyle(fontWeight: FontWeight.w300).merge(additionalStyle),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: style,
      overflow: overflow,
      strutStyle: strutStyle,
      maxLines: maxLines,
      stepGranularity: 1,
      maxFontSize: maxFontSize ?? double.infinity,
      minFontSize: minFontSize ?? 8,
      softWrap: softWrap,
      textAlign: textAlign,
      textDirection: direction,
    );
  }
}
