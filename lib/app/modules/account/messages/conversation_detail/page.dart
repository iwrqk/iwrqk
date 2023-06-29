import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../l10n.dart';
import '../../../../core/utils/display_util.dart';
import '../../../../data/enums/state.dart';
import '../../../../data/models/account/conversations/message.dart';
import '../../../../global_widgets/reloadable_image.dart';
import '../../../../global_widgets/sliver_refresh/widgets/iwr_footer_indicator.dart';
import 'controller.dart';
import 'widgets/send_message_bottom_sheet/widget.dart';

class ConversationDetailPage extends GetView<ConversationDetailController> {
  const ConversationDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const FaIcon(
            FontAwesomeIcons.chevronLeft,
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0,
          ),
        ),
        centerTitle: true,
        title: Text(L10n.of(context).conversation),
      ),
      body: controller.obx(
        (state) {
          return Column(
            children: [
              Expanded(
                child: SafeArea(
                  child: CustomScrollView(
                    reverse: true,
                    clipBehavior: Clip.none,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == controller.messages.length - 1 &&
                                state != IwrState.loading &&
                                state != IwrState.fail) {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((Duration callback) {
                                controller.reachTop();
                              });
                            }

                            final message = controller.messages[
                                controller.messages.length - 1 - index];
                            return MessageWidget(
                              message: message,
                              isSender: message.user.id == controller.userId,
                            );
                          },
                          childCount: controller.messages.length,
                        ),
                      ),
                      IwrFooterIndicator(
                        indicatorState: state,
                        loadMore: controller.loadData,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.bottomSheet(SendMessageBottomSheet(
                    conversationId: controller.conversationId,
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      child: AutoSizeText(
                        L10n.of(context).send,
                        maxLines: 1,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final MessageModel message;
  final bool isSender;

  const MessageWidget({
    Key? key,
    required this.message,
    required this.isSender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget avatar = ClipOval(
      child: ReloadableImage(
        imageUrl: message.user.avatarUrl,
        width: 35,
        height: 35,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender) avatar,
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 10, left: 10),
                child: Text(
                  message.user.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CustomPaint(
                painter: MessageBubble(
                  color: isSender
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).canvasColor,
                  isSender: isSender,
                ),
                child: Container(
                  margin: isSender
                      ? const EdgeInsets.only(top: 10, right: 10)
                      : const EdgeInsets.only(top: 10, left: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                    minWidth: 15,
                  ),
                  child: Text(
                    message.body,
                    style: TextStyle(
                      color: isSender ? Colors.white : null,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 10, left: 10),
                child: Text(
                  DisplayUtil.getDetailedTime(
                    DateTime.parse(message.createdAt),
                  ),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
          if (isSender) avatar,
        ],
      ),
    );
  }
}

class MessageBubble extends CustomPainter {
  final Color color;
  final bool isSender;

  MessageBubble({required this.color, required this.isSender});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (isSender) {
      path.moveTo(10, 10);
      path.lineTo(size.width - 25, 10);
      path.quadraticBezierTo(
        size.width - 12.5,
        5,
        size.width - 5,
        5,
      );
      path.quadraticBezierTo(
        size.width - 10,
        10,
        size.width - 10,
        25,
      );
      path.lineTo(size.width - 10, size.height - 10);
      path.quadraticBezierTo(
        size.width - 10,
        size.height,
        size.width - 20,
        size.height,
      );
      path.lineTo(10, size.height);
      path.quadraticBezierTo(
        0,
        size.height,
        0,
        size.height - 10,
      );
      path.lineTo(0, 20);
      path.quadraticBezierTo(
        0,
        10,
        10,
        10,
      );
    } else {
      path.moveTo(5, 5);
      path.quadraticBezierTo(
        12.5,
        5,
        25,
        10,
      );
      path.lineTo(size.width - 10, 10);
      path.quadraticBezierTo(
        size.width,
        10,
        size.width,
        20,
      );
      path.lineTo(size.width, size.height - 10);
      path.quadraticBezierTo(
        size.width,
        size.height,
        size.width - 10,
        size.height,
      );
      path.lineTo(20, size.height);
      path.quadraticBezierTo(
        10,
        size.height,
        10,
        size.height - 10,
      );
      path.lineTo(10, 25);
      path.quadraticBezierTo(
        10,
        12.5,
        5,
        5,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
