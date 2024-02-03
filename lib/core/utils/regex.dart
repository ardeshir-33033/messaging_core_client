class CustomRegex {
  CustomRegex._();

  static RegExp phoneNumberRegex = RegExp(
    r'''^(.*?)([\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6})''',
    caseSensitive: false,
    dotAll: true,
  );
}
