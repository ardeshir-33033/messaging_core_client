import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/loading_widget.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomRefresher extends StatelessWidget {
  final RefreshController? controller;
  final Function()? onRefresh;
  final Function()? onLoading;
  final ScrollController? scrollController;
  final bool hasPagination;
  final bool reverse;
  final Widget child;

  const CustomRefresher({
    Key? key,
    required this.onRefresh,
    this.controller,
    this.onLoading,
    required this.child,
    this.hasPagination = false,
    this.reverse = false,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () => ClassicHeader(
        completeIcon: Icon(
          Icons.check,
          size: 16,
          color: AppColors.neutral.shade400,
        ),
        idleIcon: Icon(
          Icons.arrow_downward,
          size: 16,
          color: AppColors.neutral.shade400,
        ),
        releaseIcon: Icon(
          Icons.refresh,
          size: 16,
          color: AppColors.neutral.shade400,
        ),
        textStyle: AppTextStyles.overline2.copyWith(
          color: AppColors.neutral.shade400,
        ),
        refreshingText: tr(context).loading,
        failedText: tr(context).failed,
        completeText: tr(context).refreshCompleted,
        releaseText: tr(context).releaseToRefresh,
        refreshingIcon: LoadingWidget(
          height: 12,
          width: 12,
          strokeWidth: 2,
          color: AppColors.neutral.shade400,
        ),
        iconPos: IconPosition.left,
      ),
      child: SmartRefresher(
        controller: controller ?? RefreshController(),
        scrollController: scrollController,
        reverse: reverse,
        primary: scrollController != null ? false : true,
        dragStartBehavior: DragStartBehavior.down,
        footer: ClassicFooter(
          loadingIcon: LoadingWidget(
            height: 12,
            width: 12,
            strokeWidth: 2,
            color: AppColors.neutral.shade400,
          ),
          loadingText: tr(context).loading,
          failedText: tr(context).failed,
          noDataText: "",
          canLoadingText: tr(context).releaseToRefresh,
          completeDuration: const Duration(seconds: 1),
          iconPos: IconPosition.left,
        ),
        enableTwoLevel: false,
        enablePullUp: hasPagination,
        enablePullDown: onRefresh != null,
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: child,
      ),
    );
  }
}
