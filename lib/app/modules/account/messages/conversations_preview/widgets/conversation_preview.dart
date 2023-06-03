import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/display_util.dart';
import '../../../../../data/models/conversations/conversation.dart';
import '../../../../../data/models/user.dart';
import '../../../../../global_widgets/reloadable_image.dart';
import '../../../../../routes/pages.dart';

class ConversationPreview extends StatelessWidget {
  final String userId;
  final ConversationModel conversation;

  const ConversationPreview(
      {super.key, required this.conversation, required this.userId});

  @override
  Widget build(BuildContext context) {
    UserModel interlocutor =
        conversation.participants.firstWhere((element) => element.id != userId);

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.conversationDetail,
          arguments: {
            'conversationId': conversation.id,
            'userId': userId,
          },
        );
      },
      child: Container(
        color: conversation.unread
            ? Theme.of(context).canvasColor
            : Theme.of(context).cardColor,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: ClipOval(
            child: ReloadableImage(
              imageUrl: interlocutor.avatarUrl,
              width: 50,
              height: 50,
            ),
          ),
          title: Row(
            children: [
              Flexible(
                child: Text(
                  interlocutor.name,
                  maxLines: 1,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Text(
                ' (${conversation.title})',
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                conversation.lastMessage.body,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
              Text(
                DisplayUtil.getDisplayTime(
                    DateTime.parse(conversation.updatedAt)),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
