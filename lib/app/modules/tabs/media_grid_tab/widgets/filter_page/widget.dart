import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../../../data/enums/types.dart';
import '../../../../../utils/display_util.dart';
import 'controller.dart';

class FilterPage extends StatefulWidget {
  final String targetTag;

  const FilterPage({
    super.key,
    required this.targetTag,
  });
  @override
  State<StatefulWidget> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late FilterController _controller;

  @override
  void initState() {
    super.initState();
    Get.create(() => FilterController(), tag: widget.targetTag);
    _controller = Get.find<FilterController>(tag: widget.targetTag);
    _controller.init(widget.targetTag);
  }

  String _getRatingLocalName(BuildContext context, RatingType ratingType) {
    String result = "";
    switch (ratingType) {
      case RatingType.all:
        result = t.filter.all;
        break;
      case RatingType.general:
        result = t.filter.general;
        break;
      case RatingType.ecchi:
        result = t.filter.ecchi;
        break;
    }
    return result;
  }

  Widget _buildTagAutocomplete(BuildContext context) {
    return RawAutocomplete<String>(
      focusNode: _controller.tagFocusNode,
      textEditingController: _controller.tagEditingController,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return _controller.autoCompleteTags(textEditingValue.text);
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return Container(
          key: _controller.tagEditingControllerKey,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.fromLTRB(4, 6, 16, 6),
          child: Theme(
            data: Theme.of(context).brightness == Brightness.light
                ? ThemeData.light()
                : ThemeData.dark(),
            child: TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return t.message.please_type_host;
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: t.filter.tag,
                border: InputBorder.none,
              ),
            ),
          ),
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        RenderBox inputRenderBox = _controller
            .tagEditingControllerKey.currentContext!
            .findRenderObject() as RenderBox;
        RenderBox tagsRenderBox = _controller.tagsBoxKey.currentContext!
            .findRenderObject() as RenderBox;

        return Transform.translate(
          offset: const Offset(0, -12),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: inputRenderBox.size.width,
              height: options.length * 56 + 10,
              constraints: BoxConstraints(
                  maxHeight: tagsRenderBox.size.height -
                      inputRenderBox.size.height -
                      32),
              child: Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                ),
                color: Theme.of(context).colorScheme.secondaryContainer,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return InkWell(
                        onTap: () {
                          onSelected.call(option);
                          _controller.addTag(option);
                        },
                        child: ListTile(
                          title: Text(option),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagClip(BuildContext context, int index) {
    String tag = _controller.selectedTags[index];

    return InputChip(
      label: Text(
        tag,
      ),
      onDeleted: () {
        _controller.removeTag(tag);
      },
    );
  }

  Widget _buildTagsContent(BuildContext context) {
    return SingleChildScrollView(
      key: _controller.tagsBoxKey,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildTagAutocomplete(context),
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  _controller.selectedTags.length,
                  (index) => _buildTagClip(context, index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearClip(BuildContext context, int index) {
    int year = 2013 + index;

    return Obx(
      () => FilterChip(
        selected: _controller.selectedYear == year,
        label: Text(
          year.toString(),
        ),
        onSelected: (bool value) {
          if (_controller.selectedYear == year) {
            _controller.selectedYear = 0;
          } else {
            _controller.selectedYear = year;
          }
        },
      ),
    );
  }

  Widget _buildMonthClip(BuildContext context, int index) {
    int month = index + 1;

    return Obx(
      () => FilterChip(
        selected: _controller.selectedMonth == month,
        label: Text(
          DateFormat('MMM', DisplayUtil.getLocalecode())
              .format(DateTime(2000, month)),
        ),
        onSelected: (bool value) {
          if (_controller.selectedMonth == month) {
            _controller.selectedMonth = 0;
          } else {
            _controller.selectedMonth = month;
          }
        },
      ),
    );
  }

  Widget _buildRatingClip(BuildContext context, int index) {
    RatingType ratingType = RatingType.fromInt(index);

    return Obx(
      () => FilterChip(
        selected: _controller.selectedRatingType == ratingType,
        label: Text(
          _getRatingLocalName(context, ratingType),
        ),
        onSelected: (bool value) {
          _controller.selectedRatingType = ratingType;
        },
      ),
    );
  }

  Widget _buildRatingDateContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                t.filter.select_rating,
                style: const TextStyle(
                  fontSize: 17.5,
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                3,
                (index) => _buildRatingClip(context, index),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                t.filter.select_year,
                style: const TextStyle(
                  fontSize: 17.5,
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                DateTime.now().year - 2013 + 1,
                (index) => _buildYearClip(context, index),
              ),
            ),
            if (_controller.selectedYear != 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  t.filter.select_month,
                  style: const TextStyle(
                    fontSize: 17.5,
                  ),
                ),
              ),
            if (_controller.selectedYear != 0)
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: List.generate(
                  DateTime.now().year == _controller.selectedYear
                      ? DateTime.now().month
                      : 12,
                  (index) => _buildMonthClip(context, index),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.filter.filter,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _controller.applyFilter();
              Get.back();
            },
            child: Text(
              t.notifications.apply,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                padding:
                    MediaQuery.of(context).padding.copyWith(top: 0, bottom: 0),
                alignment: Alignment.centerLeft,
                child: TabBar(
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                  tabAlignment: TabAlignment.center,
                  splashBorderRadius: BorderRadius.circular(8),
                  tabs: [
                    Tab(text: t.filter.tags),
                    Tab(
                      text: "${t.filter.rating}&${t.filter.date}",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildTagsContent(context),
                    _buildRatingDateContent(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      openElevation: 0,
      openColor: Theme.of(context).colorScheme.background,
      middleColor: Theme.of(context).colorScheme.background,
      closedColor: Theme.of(context).colorScheme.background,
      closedShape: const CircleBorder(),
      closedBuilder: (context, action) {
        return IconButton(
          onPressed: action,
          icon: const Icon(
            Icons.filter_list,
          ),
        );
      },
      openShape: Border.all(color: Colors.transparent),
      openBuilder: (context, action) {
        return _buildContent(context);
      },
    );
  }
}
