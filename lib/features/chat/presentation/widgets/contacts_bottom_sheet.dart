import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/loading_widget.dart';
import 'package:messaging_core/core/app_states/result_state.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/presentation/manager/contacts_controller.dart';
import 'package:messaging_core/locator.dart';

class ContactsBottomSheet extends StatefulWidget {
  const ContactsBottomSheet({super.key});

  @override
  State<ContactsBottomSheet> createState() => _ContactsBottomSheetState();
}

class _ContactsBottomSheetState extends State<ContactsBottomSheet> {
  final ContactsController controller = Get.put<ContactsController>(locator());

  @override
  void initState() {
    super.initState();
    controller.getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContactsController>(
        id: "contacts",
        builder: (_) {
          return SizedBox(
            height: context.screenHeight / 3,
            child: controller.getContactsStatus.status == Status.success
                ? ListView.separated(
                    itemCount: controller.contacts?.length ?? 0,
                    itemBuilder: (context, int index) {
                      Contact contact = controller.contacts![index];
                      if (contact.phones!.isEmpty ||
                          contact.phones!.first.value == null) {
                        return const SizedBox();
                      }
                      return Row(
                        children: [
                          _noProfileImage(context, contact.displayName!,
                              contact.phones!.first.value!),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contact.displayName ?? "",
                                style: AppTextStyles.subtitle4,
                              ),
                              Text(
                                contact.phones?.first.value ?? "",
                                style: AppTextStyles.overline2,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, int index) {
                      return Divider(
                        height: 10,
                        color: Colors.grey[100],
                      );
                    },
                  )
                : const LoadingWidget(),
          );
        });
  }

  Widget _noProfileImage(context, String name, String phone) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: int.tryParse(phone)?.colorFromId() ?? const Color(0xFFFFAEAE),
      ),
      child: Center(
        child: Text(
          (name.length) > 0 ? name.substring(0, 1).toUpperCase() ?? "A" : "A",
          style: AppTextStyles.caption2.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
