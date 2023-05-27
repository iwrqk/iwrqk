import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import '../../../data/enums/types.dart';
import '../../../global_widgets/tab_indicator.dart';
import 'controller.dart';
import 'widgets/favorite_media_preview_list/widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesController _controller = Get.find();

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: TabBar(
        isScrollable: true,
        physics: const BouncingScrollPhysics(),
        indicator: TabIndicator(context),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Theme.of(context).primaryColor,
        tabs: [
          Tab(text: L10n.of(context).videos),
          Tab(text: L10n.of(context).images),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const FaIcon(FontAwesomeIcons.chevronLeft),
          ),
          centerTitle: true,
          title: Text(
            L10n.of(context).user_favorites,
          )),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  FavoriteMediaPreviewList(
                    mediaType: MediaType.video,
                    tag: _controller.childrenControllerTags[0],
                  ),
                  FavoriteMediaPreviewList(
                    mediaType: MediaType.image,
                    tag: _controller.childrenControllerTags[1],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
