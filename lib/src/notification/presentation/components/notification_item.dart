import 'package:flutter/material.dart';

import '../../../core/utils.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationItem extends StatefulWidget {
  const NotificationItem({
    super.key,
    required this.notification,
    required this.onExpandPressed,
    required this.onConfirmDismiss,
    required this.onPressed,
  });

  final NotificationEntity notification;
  final VoidCallback onExpandPressed;
  final Future<bool> Function(String id) onConfirmDismiss;
  final void Function(String notificationId) onPressed;

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool showDetail = false;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.notification.notificationId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return widget.onConfirmDismiss(widget.notification.notificationId);
      },
      child: Badge(
        offset: const Offset(-24, 8),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
        isLabelVisible: !widget.notification.seen, //_REVIEW: notification.seen default = false
        alignment: Alignment.topRight,
        label: const Text(
          'Mới',
          style: TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
        child: InkWell(
          onTap: () => widget.onPressed(widget.notification.notificationId),
          child: Ink(
            // decoration: BoxDecoration(
            //   //! will got some issue when user expand the item
            //   // color: !widget.notification.seen
            //   //     ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1)
            //   //     : Colors.white,
            //   border: Border.all(color: Colors.grey.shade200),
            //   borderRadius: BorderRadius.circular(4.0),
            // ),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.symmetric(horizontal: 4.0),

              //* image
              // SizedBox(
              //   width: 50,
              //   height: 50,
              //   child: const ImageCacheable(
              //     widget.notification.image,
              //   ),
              // ),

              child: Row(
                children: [
                  //# title & body
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.notification.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
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
                              ConversionUtils.convertDateTimeToString(
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

                  //# icon expand
                  IconButton(
                    style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    onPressed: () {
                      setState(() {
                        showDetail = !showDetail;
                        if (!widget.notification.seen) {
                          widget.onExpandPressed();
                        }
                      });
                    },
                    icon: Icon(showDetail ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
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
