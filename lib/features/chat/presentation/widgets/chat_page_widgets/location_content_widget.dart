import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/location_payload_model.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationContentWidget extends StatelessWidget {
  const LocationContentWidget({super.key, required this.locationPayloadModel});

  final LocationPayloadModel locationPayloadModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(context).location,
          style: AppTextStyles.subtitle4,
        ),
        Text(
          "${locationPayloadModel.lat} ,  ${locationPayloadModel.lng}",
          style: AppTextStyles.overline2,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          width: context.screenWidth / 1.7,
          child: ElevatedButton(
            onPressed: () async {
              String googleUrl =
                  'https://www.google.com/maps/search/?api=1&query=${locationPayloadModel.lat},${locationPayloadModel.lng}';
              if (await canLaunch(googleUrl)) {
                await launch(googleUrl);
              } else {
                throw 'Could not open the map.';
              }
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
