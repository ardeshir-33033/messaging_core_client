import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/core/utils/content_phone_linkifier.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/core/utils/text_utils.dart';
import 'package:messaging_core/core/utils/utils.dart';

class TextContentWidget extends StatelessWidget {
  final String content;
  final Key keyId;
  final TextOverflow? overflow;
  final Color? textColor;

  const TextContentWidget(
      {Key? key,
      required this.content,
      required this.keyId,
      this.overflow = TextOverflow.clip,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Linkify(
      onOpen: (link) {
        launchExternalUrl(
          link.url,
          onError: (error) {
            context.showFailedSnackBar(tr(context).couldNotLaunchUrl);
          },
        );
      },
      options: const LinkifyOptions(
        removeWww: false,
        humanize: true,
        looseUrl: true,
        excludeLastPeriod: true,
      ),
      linkifiers: const [
        UrlLinkifier(),
        EmailLinkifier(),
        PhoneNumberLinkifier(),
      ],
      linkStyle: AppTextStyles.overline2.copyWith(color: AppColors.primary1),
      text: content,
      overflow: overflow,
      textDirection: directionOf(content),
      key: keyId,
      style: AppTextStyles.overline2
          .copyWith(color: textColor ?? Color.fromARGB(255, 62, 62, 85)),
    );
  }
}
