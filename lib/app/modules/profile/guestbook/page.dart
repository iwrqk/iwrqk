import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../../components/comments_list/widget.dart';
import '../../../components/network_image.dart';
import '../../../components/send_comment_bottom_sheet/widget.dart';
import '../../../data/enums/types.dart';
import '../../../data/models/user.dart';

class GuestbookPage extends StatefulWidget {
  final UserModel user;

  const GuestbookPage({Key? key, required this.user}) : super(key: key);

  @override
  State<GuestbookPage> createState() => _GuestbookPageState();
}

class _GuestbookPageState extends State<GuestbookPage>
    with TickerProviderStateMixin {
  bool _isFabVisible = true;
  final ScrollController scrollController = ScrollController();
  late AnimationController fabAnimationController;

  @override
  void initState() {
    super.initState();

    fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    fabAnimationController.forward();

    scrollController.addListener(() {
      final ScrollDirection direction =
          scrollController.position.userScrollDirection;
      if (direction == ScrollDirection.forward) {
        if (!_isFabVisible) {
          _isFabVisible = true;
          fabAnimationController.forward();
        }
      } else if (direction == ScrollDirection.reverse) {
        if (_isFabVisible) {
          _isFabVisible = false;
          fabAnimationController.reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    fabAnimationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Widget _buildTitle() {
    return ListTile(
      leading: ClipOval(
        child: NetworkImg(
          imageUrl: widget.user.avatarUrl,
          width: 40,
          height: 40,
        ),
      ),
      title: Text(
        widget.user.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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
        scrollController: scrollController,
        uploaderUserName: widget.user.username,
        sourceId: widget.user.id,
        sourceType: CommentsSourceType.profile,
        showBottomPagination: true,
      ),
      floatingActionButton: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 2),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: fabAnimationController,
          curve: Curves.easeInOut,
        )),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 64),
          child: FloatingActionButton(
            onPressed: () {
              Get.bottomSheet(SendCommentBottomSheet(
                sourceId: widget.user.id,
                sourceType: CommentsSourceType.profile,
              ));
            },
            child: const Icon(Icons.reply),
          ),
        ),
      ),
    );
  }
}
