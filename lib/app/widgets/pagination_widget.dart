import 'package:flutter/material.dart';
import 'package:messaging_core/app/widgets/custom_refresher.dart';
import 'package:messaging_core/core/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PaginationWidget<T extends Object> extends StatefulWidget {
  final Widget Function(int index, T item) itemBuilder;
  final Widget Function(int index)? separatorBuilder;
  final Future<void> Function(int limit, int offset) onRefresh;
  final Future<void> Function(int limit, int offset) onLoading;
  final Widget? onEmpty;
  final int? limit;
  final int? offset;
  final List items;
  final bool fetchOnInit;

  const PaginationWidget({
    Key? key,
    required this.itemBuilder,
    required this.items,
    required this.onRefresh,
    required this.onLoading,
    this.separatorBuilder,
    this.limit,
    this.offset,
    this.onEmpty,
    this.fetchOnInit = true,
  }) : super(key: key);

  @override
  State<PaginationWidget> createState() =>
      _PaginationWidgetState<T, PaginationWidget<T>>();
}

class _PaginationWidgetState<T extends Object, W extends PaginationWidget<T>>
    extends State<W> {
  late RefreshController refreshController;
  int offset = 1;
  int limit = 25;

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController();
    limit = widget.limit ?? 25;
    offset = (widget.items.length / limit).round();
    if (offset == 0) {
      offset++;
    }
    // postFrameCallback(() {
    //   if (widget.fetchOnInit) {
    //     onRefresh();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefresher(
      controller: refreshController,
      hasPagination: true,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: Visibility(
        visible: widget.items.isNotEmpty,
        replacement: widget.onEmpty ?? const SizedBox(),
        child: ListView.separated(
          itemBuilder: (context, index) =>
              widget.itemBuilder.call(index, widget.items[index]),
          separatorBuilder: (context, index) =>
              widget.separatorBuilder?.call(index) ?? const SizedBox.shrink(),
          itemCount: widget.items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }

  void _increasePageIndex() {
    offset++;
  }

  Future<void> onRefresh() async {
    await widget.onRefresh.call(limit, 1).then((value) {
      refreshController.refreshCompleted();
      refreshController.resetNoData();
      if (limit * offset > widget.items.length) {
        refreshController.loadNoData();
      }
    });
  }

  Future<void> onLoading() async {
    _increasePageIndex();
    await widget.onLoading.call(limit, offset).then((value) {
      if (limit * offset > widget.items.length) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    });
  }
}
