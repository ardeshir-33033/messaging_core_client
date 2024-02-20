import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/contact_payload_model.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactContentWidget extends StatelessWidget {
  const ContactContentWidget({super.key, required this.contactPayloadModel});

  final ContactPayloadModel contactPayloadModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          contactPayloadModel.contactName!,
          style: AppTextStyles.subtitle4,
        ),
        Text(
          contactPayloadModel.contactNumber!,
          style: AppTextStyles.overline2,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          width: context.screenWidth / 1.7,
          child: ElevatedButton(
            onPressed: () {
              launchUrl(
                  Uri.parse("tel://${contactPayloadModel.contactNumber}"));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.7),
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text(
              tr(context).viewContact,
              style: AppTextStyles.subtitle4.copyWith(color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}
