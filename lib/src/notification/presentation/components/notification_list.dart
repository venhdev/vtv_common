import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../auth.dart';
import '../../../core/presentation/components/lazy_list_builder.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({
    super.key,
    this.actions,
    required this.lazyListController,
    this.separatorBuilder,
  });

  final List<Widget>? actions;

  final LazyListController<NotificationEntity> lazyListController;
  final Widget? Function(BuildContext, int)? separatorBuilder;

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  void initState() {
    super.initState();

    widget.lazyListController.scrollController!.addListener(() {
      if (widget.lazyListController.scrollController!.position.pixels ==
          widget.lazyListController.scrollController?.position.maxScrollExtent) {
        widget.lazyListController.loadNextPage();
      }
    });

    widget.lazyListController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    widget.lazyListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          widget.lazyListController.clear();
        } else if (state.status == AuthStatus.authenticated) {
          widget.lazyListController.init();
        }
      },
      builder: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          return const Center(
            child: Text('Vui lòng đăng nhập để xem thông báo'),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            widget.lazyListController.refresh();
          },
          child: CustomScrollView(
            controller: widget.lazyListController.scrollController,
            slivers: [
              _buildSliverAppBar(context),
              SliverList.separated(
                itemCount: widget.lazyListController.length,
                itemBuilder: widget.lazyListController.build,
                separatorBuilder: widget.separatorBuilder ?? (_, __) => const SizedBox.shrink(),
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
