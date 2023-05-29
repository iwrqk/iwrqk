import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../../l10n.dart';
import '../../../../core/utils/display_util.dart';
import '../../../../data/models/forum/post.dart';
import '../../../../data/providers/translate_provider.dart';
import '../../../../global_widgets/iwr_markdown.dart';
import '../../../../global_widgets/reloadable_image.dart';
import '../../../../global_widgets/translated_content.dart';
import '../../../../routes/pages.dart';

class Post extends StatefulWidget {
  final PostModel post;
  final int index;
  final String starterUserName;

  const Post({
    Key? key,
    required this.post,
    required this.index,
    required this.starterUserName,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PostState();
}

class _PostState extends State<Post> with AutomaticKeepAliveClientMixin {
  String? translatedContent;

  Widget _buildStarterBadge(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        "OP",
        style: TextStyle(color: Colors.white, fontSize: 12.5),
      ),
    );
  }

  Widget _buildUserWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.profile,
          arguments: widget.post.user.username,
          preventDuplicates: false,
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: ReloadableImage(
              imageUrl: widget.post.user.avatarUrl,
              width: 30,
              height: 30,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                widget.post.user.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
          ),
          if (widget.starterUserName == widget.post.user.username)
            _buildStarterBadge(context)
        ],
      ),
    );
  }

  void _getTranslatedContent() async {
    TranslateProvider.google(
      text: widget.post.body,
    ).then((value) {
      if (value.success) {
        setState(() {
          translatedContent = value.data;
        });
      } else {
        showToast(value.message!);
      }
    });
  }

  Widget _buildBottomWidget(BuildContext context) {
    String text =
        DisplayUtil.getDisplayTime(DateTime.parse(widget.post.createAt));
    if (widget.post.createAt != widget.post.updateAt) {
      text +=
          "\n${L10n.of(context).updated_at(DisplayUtil.getDisplayTime(DateTime.parse(widget.post.updateAt)))}";
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "#${widget.index} ",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: text,
                  style: const TextStyle(color: Colors.grey, fontSize: 12.5),
                ),
              ],
            ),
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: "translate",
                  child: Text(
                    L10n.of(context).translate,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ];
            },
            onSelected: (String value) {
              if (value == "translate") {
                _getTranslatedContent();
              }
            },
            child: FaIcon(
              FontAwesomeIcons.ellipsis,
              size: 12.5,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IwrMarkdown(
            padding: const EdgeInsets.only(top: 5),
            selectable: true,
            data: widget.post.body,
          ),
          if (translatedContent != null)
            TranslatedContent(
              padding: const EdgeInsets.only(top: 10),
              translatedContent: translatedContent!,
            ),
          _buildBottomWidget(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Card(
      color: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserWidget(context),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
