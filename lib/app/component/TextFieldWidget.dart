import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final String? labelText;
  final bool? enabled;
  final TextInputType? textInputType;
  final double borderRadius;
  final InputBorder? disableBorder;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final double verticalPadding;
  final InputDecoration? customDecoration;
  final bool autoFocus;
  final Function(String value)? onSubmit;

  const TextFieldWidget({
    super.key,
    required this.controller,
    this.validator,
    this.hintText,
    this.prefixIcon,
    this.labelText,
    this.enabled,
    this.textInputType,
    this.disableBorder,
    this.focusNode,
    this.onChanged,
    this.borderRadius = 10,
    this.suffixIcon,
    this.verticalPadding = 0,
    this.customDecoration,
    this.autoFocus = false,
    this.onSubmit
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled ?? true,
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      onChanged: onChanged,
      autofocus: autoFocus,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: textInputType ?? TextInputType.text,
      style: AppTextStyles.overline2.copyWith(
        color: const Color(0xff272B38),
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
      onFieldSubmitted: onSubmit,
      decoration: customDecoration ??
          InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: verticalPadding),
            filled: true,
            isDense: true,
            fillColor: const Color(0xffF8F8FA),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            hintText: hintText,
            hintStyle: AppTextStyles.overline2.copyWith(
              color: const Color(0xff4E5670),
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelStyle: AppTextStyles.overline2.copyWith(
              color: const Color(0xff4E5670),
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
            errorStyle: AppTextStyles.overline2.copyWith(
              fontSize: 10,
              color: Colors.red,
            ),
            border: _getEnabledBorder(context),
            enabledBorder: _getEnabledBorder(context),
            disabledBorder: _getDisabledBorder(context),
            focusedBorder: _getFocusedBorder(context),
            errorBorder: _getErrorBorder(context),
            focusedErrorBorder: _getErrorBorder(context),
          ),
    );
  }

  InputBorder _getErrorBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(
        color: Colors.red,
      ),
    );
  }

  InputBorder _getEnabledBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(borderRadius),
      ),
      borderSide: BorderSide.none,
    );
  }

  InputBorder _getDisabledBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(borderRadius),
      ),
      borderSide: BorderSide.none,
    );
  }

  InputBorder _getFocusedBorder(BuildContext context) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
        borderSide: const BorderSide(color: Color(0xff5999F1)));
  }
}
