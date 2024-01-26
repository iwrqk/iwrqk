import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/comments_list/widget.dart';
import '../../../components/network_image.dart';
import '../../../components/send_comment_bottom_sheet/widget.dart';
import '../../../data/enums/types.dart';
import '../../../data/models/user.dart';

class GuestbookPage extends StatelessWidget {
  final UserModel user;
  const GuestbookPage({Key? key, required this.user}) : super(key: key);

  Widget _buildTitle() {
    return ListTile(
      leading: ClipOval(
        child: NetworkImg(
          imageUrl: user.avatarUrl,
          width: 40,
          height: 40,
        ),
      ),
      title: Text(
        user.name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: _buildTitle(),
        titleSpacing: 0,
      ),
      body: CommentsList(
        uploaderUserName: user.username,
        sourceId: user.id,
        sourceType: CommentsSourceType.profile,
        showBottomPagination: true,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 64),
        child: FloatingActionButton(
          onPressed: () {
            Get.bottomSheet(SendCommentBottomSheet(
              sourceId: user.id,
              sourceType: CommentsSourceType.profile,
            ));
          },
          child: const Icon(Icons.reply),
        ),
      ),
    );
  }
}
