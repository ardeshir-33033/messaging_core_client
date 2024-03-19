import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/no_profile_image.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/locator.dart';

class NoCallWidget extends StatelessWidget {
  NoCallWidget({super.key});

  final CallController controller = locator<CallController>();
  final ChatController chatController = locator<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(10),
            height: context.screenHeight / 1.4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF212121),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  tr(context).callingTo,
                  style: AppTextStyles.body1.copyWith(color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: context.screenWidth / 1.5,
                  height: context.screenHeight / 2.5,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D2D2D),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15.0),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle),
                            child: const IconWidget(
                              icon: Assets.muteMicroPhone,
                              iconColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 15,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle),
                          child: const IconWidget(
                            icon: Assets.disableVideo,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: NoProfileImage(
                              name: chatController.currentChat!.username,
                              id: chatController.currentChat!.id,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            chatController.currentChat!.username ?? "",
                            style: AppTextStyles.body3
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: context.screenWidth / 1.5,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.setCallMode(CallMode.video);
                            controller.setCallStatus(CallStatus.inCall);
                          },
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: AppColors.primary1,
                            ),
                            child: Center(
                                child: Text(
                              tr(context).videoCall,
                              style: AppTextStyles.body3
                                  .copyWith(color: Colors.white),
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.setCallMode(CallMode.voice);
                            controller.setCallStatus(CallStatus.inCall);
                          },
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: AppColors.primary1,
                            ),
                            child: Center(
                                child: Text(
                              tr(context).voiceCall,
                              style: AppTextStyles.body3
                                  .copyWith(color: Colors.white),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: context.screenWidth / 1.5,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                        child: Text(
                      tr(context).cancel,
                      style: AppTextStyles.body3.copyWith(color: Colors.white),
                    )),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
