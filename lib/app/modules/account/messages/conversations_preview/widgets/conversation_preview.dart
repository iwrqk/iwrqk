import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/display_util.dart';
import '../../../../../data/models/account/conversations/conversation.dart';
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
              Flexible(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: conversation.lastMessage.body,
                      ),
                      if (conversation.unread)
                        WidgetSpan(
                          child: Container(
                              width: 15,
                              height: 15,
                              margin: const EdgeInsets.only(left: 5),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: FaIcon(
                                  FontAwesomeIcons.exclamation,
                                  size: 7.5,
                                  color: Colors.white,
                                ),
                              )),
                        ),
                    ],
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  maxLines: 1,
                ),
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
