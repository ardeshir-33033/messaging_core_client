import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/core/utils/text_utils.dart';

class SendMessageWidget extends StatefulWidget {
  const SendMessageWidget({super.key, required this.textController});

  final TextEditingController textController;

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 35,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const IconWidget(
            icon: Assets.addSticker,
            size: 30,
          ),
          const SizedBox(width: 5),
          const IconWidget(
            icon: Assets.attach,
            size: 30,
          ),
          Expanded(
              child: SizedBox(
                height:200,
                child: TextField(
                    // style: TextStyle(color: widget.textColor),
                    key: const Key("messageField"),
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 7,
                    minLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    controller: widget.textController,
                    textDirection: directionOf(widget.textController.text),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        // contentPadding:
                        //     const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        // suffixIcon: widget.inputSuffixWidget,
                        hintText: tr(context).hintMessage,
                        hintStyle: AppTextStyles.overline1
                            .copyWith(color: const Color(0xFFBEBEBE)),
                        border: InputBorder.none)),
              )),
          const IconWidget(
            icon: Assets.microphone,
            size: 30,
          ),
        ],
      ),
    );
  }
}
