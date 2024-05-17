import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../auth.dart';
import '../../../core/constants/typedef.dart';
import '../../../core/presentation/components/lazy_list_builder.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/entities/notification_page_resp.dart';
import 'notification_item.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({
    super.key,
    required this.dataCallback,
    required this.markAsRead,
    required this.deleteNotification,
    this.actions,
  });

  final FRespData<NotificationPageResp> Function(int page) dataCallback;
  final void Function(String) markAsRead;
  final Future<bool> Function(String, int) deleteNotification;

  final List<Widget>? actions;

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  late LazyListController<NotificationEntity> _lazyListController;

  @override
  void initState() {
    super.initState();
    _lazyListController = LazyListController<NotificationEntity>(
        paginatedData: widget.dataCallback,
        items: [],
        scrollController: ScrollController(),
        itemBuilder: (context, index, data) => NotificationItem(
              notification: data,
              markAsRead: widget.markAsRead,
              onDismiss: (id) async {
                final result = await widget.deleteNotification(id, index);
                return result;
              },
            )
        // auto: true,
        )
      ..init();

    _lazyListController.scrollController!.addListener(() {
      if (_lazyListController.scrollController!.position.pixels ==
          _lazyListController.scrollController?.position.maxScrollExtent) {
        _lazyListController.loadNextPage();
      }
    });

    // listen to the controller to update the UI when load more or refresh
    _lazyListController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _lazyListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          return const Center(
            child: Text('Vui lòng đăng nhập để xem thông báo'),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            _lazyListController.refresh();
          },
          child: CustomScrollView(
            controller: _lazyListController.scrollController,
            slivers: [
              _buildSliverAppBar(context),
              SliverList.separated(
                itemCount: _lazyListController.items.length,
                itemBuilder: _lazyListController.build,
                separatorBuilder: (context, index) => const Divider(),
              ),
            ],
          ),
        );
      },
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      title: const Text('Thông báo'),
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
      actions: widget.actions,
    );
  }
}
