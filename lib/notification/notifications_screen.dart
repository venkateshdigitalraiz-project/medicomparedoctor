import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/notification/bloc/notification_bloc.dart';
import 'package:medicompare/notification/bloc/notification_event.dart';
import 'package:medicompare/notification/bloc/notification_state.dart';
import 'package:medicompare/notification/model/notification_model.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationBloc()..add(const LoadNotifications()),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  static const _headerBlue = Color(0xFFEAF2FE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _Header(color: _headerBlue),
            Expanded(
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoading ||
                      state is NotificationInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is NotificationError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  final items = (state as NotificationLoaded).notifications;
                  if (items.isEmpty) {
                    return const Center(child: Text('No notifications'));
                  }
                  return RefreshIndicator(
                    // onRefresh: () async {
                    //   context.read<NotificationBloc>().add(
                    //     const RefreshNotifications(),
                    //   );
                    //   // await Future.delayed(const Duration(milliseconds: 600));
                    // },
                    onRefresh: () {
                      final bloc = context.read<NotificationBloc>();
                      bloc.add(const RefreshNotifications());

                      return bloc.stream.firstWhere(
                        (state) =>
                            state is NotificationLoaded ||
                            state is NotificationError,
                      );
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _NotificationCard(
                          item: item,
                          onDismiss: () => context.read<NotificationBloc>().add(
                            DismissNotification(item.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Color color;
  const _Header({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 28),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
          const SizedBox(width: 4),
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onDismiss;

  const _NotificationCard({required this.item, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child:
          // Row(
          //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     _IconAvatar(item: item),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             item.title,
          //             style: TextStyle(
          //               fontSize: 14,
          //               fontWeight: FontWeight.w600,
          //               fontFamily: "Poppins",
          //               color: Colors.black87,
          //             ),
          //           ),
          //           const SizedBox(height: 4),
          //           Text(
          //             item.subtitle,
          //             style: TextStyle(
          //               fontSize: 12,
          //               fontWeight: FontWeight.w400,
          //               fontFamily: "Poppins",
          //               color: Colors.black87,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     const SizedBox(width: 8),
          //     SizedBox(
          //       width: 60,
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         children: [
          //           Text(
          //             item.timeLabel,
          //             textAlign: TextAlign.end,
          //             style: TextStyle(
          //               fontSize: 12,
          //               fontWeight: FontWeight.w600,
          //               color: item.isRecentLabel
          //                   ? const Color(0xFF1FAA6F)
          //                   : const Color(0xFF9A9A9A),
          //             ),
          //           ),
          //           const SizedBox(height: 4),
          //           Align(
          //             alignment: Alignment.centerRight,
          //             child: PopupMenuButton<String>(
          //               padding: EdgeInsets.zero,
          //               icon: const Icon(
          //                 Icons.more_vert,
          //                 color: Color(0xFFB0B0B0),
          //                 size: 20,
          //               ),
          //               onSelected: (value) {
          //                 if (value == 'remove') onDismiss();
          //               },
          //               itemBuilder: (context) => const [
          //                 PopupMenuItem(value: 'remove', child: Text('Remove')),
          //                 PopupMenuItem(
          //                   value: 'mark_read',
          //                   child: Text('Mark as read'),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconAvatar(item: item),
              const SizedBox(width: 12),

              // Left side
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // Right side
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     Text(
              //       item.timeLabel,
              //       textAlign: TextAlign.right,
              //       style: TextStyle(
              //         fontSize: 12,
              //         fontWeight: FontWeight.w600,
              //         color: item.isRecentLabel
              //             ? const Color(0xFF1FAA6F)
              //             : const Color(0xFF9A9A9A),
              //       ),
              //     ),

              //     const SizedBox(height: 6),

              //     PopupMenuButton<String>(
              //       padding: EdgeInsets.zero,
              //       constraints: const BoxConstraints(),
              //       icon: const Icon(
              //         Icons.more_vert,
              //         size: 20,
              //         color: Color(0xFFB0B0B0),
              //       ),
              //       onSelected: (value) {
              //         if (value == "remove") {
              //           onDismiss();
              //         }
              //       },
              //       itemBuilder: (_) => const [
              //         PopupMenuItem(value: "remove", child: Text("Remove")),
              //         PopupMenuItem(
              //           value: "mark_read",
              //           child: Text("Mark as read"),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.timeLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: item.isRecentLabel
                          ? const Color(0xFF1FAA6F)
                          : const Color(0xFF9A9A9A),
                    ),
                  ),
                  const SizedBox(height: 2),

                  SizedBox(
                    width: 24,
                    height: 24,
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      position: PopupMenuPosition.under,
                      iconSize: 18,
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.more_vert,
                          size: 18,
                          color: Color(0xFFB0B0B0),
                        ),
                      ),
                      onSelected: (value) {
                        if (value == 'remove') onDismiss();
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'remove', child: Text('Remove')),
                        PopupMenuItem(
                          value: 'mark_read',
                          child: Text('Mark as read'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }
}

class _IconAvatar extends StatelessWidget {
  final NotificationItem item;
  const _IconAvatar({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: item.iconBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(item.icon, color: item.iconColor, size: 22),
    );
  }
}
