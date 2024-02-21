import 'package:flutter/material.dart';
import 'package:messaging_core/app/component/base_bottom_sheets.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/no_profile_image.dart';
import 'package:messaging_core/app/widgets/round_button.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/utils/extensions.dart';

class WaitingCallPage extends StatefulWidget {
  const WaitingCallPage({super.key});

  @override
  State<WaitingCallPage> createState() => _WaitingCallPageState();
}

class _WaitingCallPageState extends State<WaitingCallPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextWidget(
              tr(context).callingFrom,
              style: AppTextStyles.body1.copyWith(color: Colors.white),
            ),
            SizedBox(height: 300, child: _buildBody()),
            TextWidget(
              "Mehdi",
              style: AppTextStyles.body1
                  .copyWith(color: Colors.white, fontSize: 25),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RoundButton(
                  color: Colors.red,
                  asset: Assets.callRemove,
                  iconColor: Colors.white,
                  size: 60,
                  onTap: () {},
                ),
                RoundButton(
                  color: Colors.green,
                  asset: Assets.callOutlined,
                  iconColor: Colors.white,
                  size: 60,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                CustomBottomSheet.showSimpleSheet(
                    context,
                    (context) => Column(
                          children: [
                            TextWidget(
                              tr(context).rejectWithMessage,
                              style: AppTextStyles.body3,
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10)),
                              child:
                                  Center(child: Text(tr(context).iCantTalkNow)),
                            )
                          ],
                        ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    tr(context).rejectWithMessage,
                    style: AppTextStyles.body3.copyWith(color: Colors.white),
                  ),
                  const IconWidget(
                    icon: Icons.keyboard_arrow_up,
                    iconColor: Colors.white,
                    size: 20,
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return AnimatedBuilder(
      animation:
          CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(150 * _controller.value),
            _buildContainer(200 * _controller.value),
            _buildContainer(250 * _controller.value),
            _buildContainer(300 * _controller.value),
            const Align(
                child: NoProfileImage(
              size: 100,
            )),
          ],
        );
      },
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.withOpacity(1 - _controller.value),
      ),
    );
  }
}
