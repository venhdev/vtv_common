import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../core/utils.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationItem extends StatefulWidget {
  const NotificationItem({
    super.key,
    required this.notification,
    required this.markAsRead,
    required this.onDismiss,
  });

  final NotificationEntity notification;
  final void Function(String id) markAsRead;
  final Future<bool> Function(String id) onDismiss;

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool showDetail = false;
  bool isLongContent = false;

  @override
  void initState() {
    super.initState();
    isLongContent = widget.notification.body.length > 100;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.notification.notificationId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // log('Dismissed: ${widget.notification.notificationId}');
        // widget.markAsRead(widget.notification.notificationId);
        log('Dismissed: ${widget.notification.notificationId}');
      },
      confirmDismiss: (direction) async {
        return widget.onDismiss(widget.notification.notificationId);
      },
      child: Badge(
        offset: const Offset(8, 8),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
        isLabelVisible: !widget.notification.seen, //_REVIEW: notification.seen default = false
        alignment: Alignment.topLeft,
        label: const Text(
          'Mới',
          style: TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              showDetail = !showDetail;
              if (!widget.notification.seen) {
                widget.markAsRead(widget.notification.notificationId);
              }
            });
          },
          child: Ink(
            decoration: BoxDecoration(
              color: !widget.notification.seen
                  ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1)
                  : Colors.white,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //# image
                  // SizedBox(
                  //   width: 50,
                  //   height: 50,
                  //   child: const ImageCacheable(
                  //     widget.notification.image,
                  //   ),
                  // ),

                  // SizedBox(width: 8),

                  // # title & body
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (!widget.notification.seen) const SizedBox(width: 32),
                            Text(
                              // notification.title,
                              widget.notification.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const Spacer(),

                            // # expand button
                            // if (widget.notification.body.length > 200)
                            Icon(showDetail ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                          ],
                        ),
                        Text(
                          // notification.body,
                          // just show 100 characters
                          // widget.notification.body,
                          // show only 100 characters

                          widget.notification.body,
                          maxLines: showDetail ? null : 2,
                          overflow: showDetail ? null : TextOverflow.ellipsis,
                        ),
                        // # time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              // notification.createAt.toString(),
                              StringUtils.convertDateTimeToString(
                                widget.notification.createAt,
                                pattern: 'dd/MM/yyyy HH:mm',
                              ),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            //# mark as read
                            // if (!widget.notification.seen) _buildMarkAsReadBtn(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
