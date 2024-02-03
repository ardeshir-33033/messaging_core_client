import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:messaging_core/core/utils/regex.dart';

class PhoneNumberLinkifier extends Linkifier {
  const PhoneNumberLinkifier();

  @override
  List<LinkifyElement> parse(
      List<LinkifyElement> elements, LinkifyOptions options) {
    final list = <LinkifyElement>[];

    for (var element in elements) {
      if (element is TextElement) {
        final match = CustomRegex.phoneNumberRegex.firstMatch(element.text);

        if (match == null) {
          list.add(element);
        } else {
          final text = element.text.replaceFirst(match.group(0)!, '');

          if (match.group(1)?.isNotEmpty == true) {
            list.add(TextElement(match.group(1)!));
          }
          if (match.group(2)?.isNotEmpty == true) {
            list.add(PhoneNumberElement(match.group(2)!));
          }
          if (text.isNotEmpty) {
            list.addAll(parse([TextElement(text)], options));
          }
        }
      } else {
        list.add(element);
      }
    }

    return list;
  }
}

class PhoneNumberElement extends LinkableElement {
  final String phoneNumber;

  PhoneNumberElement(this.phoneNumber) : super(phoneNumber, 'tel:$phoneNumber');

  @override
  String toString() {
    return "PhoneNumberElement: '$phoneNumber' ($text)";
  }

  @override
  bool operator ==(other) => equals(other);

  @override
  int get hashCode => Object.hash(text, originText, url, phoneNumber);

  @override
  bool equals(other) =>
      other is PhoneNumberElement &&
      super.equals(other) &&
      other.phoneNumber == phoneNumber;
}
