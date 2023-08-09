import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../l10n.dart';
import '../../../../../data/enums/types.dart';
import '../../../../../global_widgets/tab_indicator.dart';
import 'controller.dart';

class FilterBottomSheet extends GetWidget<FilterBottomSheetController> {
  final String targetTag;

  const FilterBottomSheet({
    super.key,
    required this.targetTag,
  });

  String _getRatingLocalName(BuildContext context, RatingType ratingType) {
    String result = "";
    switch (ratingType) {
      case RatingType.all:
        result = L10n.of(context).all;
        break;
      case RatingType.general:
        result = L10n.of(context).filter_general;
        break;
      case RatingType.ecchi:
        result = L10n.of(context).filter_ecchi;
        break;
    }
    return result;
  }

  Widget _buildRatingTypeButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: PopupMenuButton(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).cardColor),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => Text(
                  controller.selectedRatingType.value != ""
                      ? _getRatingLocalName(
                          context, controller.selectedRatingType)
                      : L10n.of(context).filter_select_rating,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const FaIcon(
                FontAwesomeIcons.chevronDown,
                size: 15,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        itemBuilder: (context) => [
          PopupMenuItem<RatingType>(
            value: RatingType.all,
            child: Text(
              _getRatingLocalName(context, RatingType.all),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          PopupMenuItem<RatingType>(
            value: RatingType.general,
            child: Text(
              _getRatingLocalName(context, RatingType.general),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          PopupMenuItem<RatingType>(
            value: RatingType.ecchi,
            child: Text(
              _getRatingLocalName(context, RatingType.ecchi),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
        onSelected: (RatingType rating) {
          controller.selectedRatingType = rating;
        },
      ),
    );
  }

  Widget _buildTagAutocomplete(BuildContext context) {
    return RawAutocomplete<String>(
      focusNode: controller.tagFocusNode,
      textEditingController: controller.tagEditingController,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return controller.autoCompleteTags(textEditingValue.text);
      },
      onSelected: (String selection) {
        controller.tagEditingController.text = selection;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return TextField(
          key: controller.tagEditingControllerKey,
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            hintText: L10n.of(context).tag,
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        RenderBox renderBox = controller.tagEditingControllerKey.currentContext!
            .findRenderObject() as RenderBox;

        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
            elevation: 4,
            child: SizedBox(
              width: renderBox.size.width,
              height: options.length < 5
                  ? options.length * 55
                  : MediaQuery.of(context).size.height / 3,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      controller.addTag(option);
                    },
                    child: ListTile(
                      title: Text(option),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagClip(BuildContext context, int index) {
    String tag = controller.selectedTags[index];

    return GestureDetector(
      onTap: () {
        controller.removeTag(tag);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tag,
              style: const TextStyle(height: 1, color: Colors.white),
            ),
            const SizedBox(width: 5),
            const FaIcon(
              FontAwesomeIcons.xmark,
              size: 17.5,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          _buildTagAutocomplete(context),
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Wrap(
                spacing: 5,
                runSpacing: 5,
                children: List.generate(
                  controller.selectedTags.length,
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

    return GestureDetector(
      onTap: () {
        if (controller.selectedYear == year) {
          controller.selectedYear = 0;
        } else {
          controller.selectedYear = year;
        }
      },
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: controller.selectedYear == year
                ? Theme.of(context).primaryColor
                : Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                year.toString(),
                style: const TextStyle(height: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthClip(BuildContext context, int index) {
    int month = index + 1;

    return GestureDetector(
      onTap: () {
        if (controller.selectedMonth == month) {
          controller.selectedMonth = 0;
        } else {
          controller.selectedMonth = month;
        }
      },
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: controller.selectedMonth == month
                ? Theme.of(context).primaryColor
                : Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('MMM', L10n.of(context).localeName)
                    .format(DateTime(2000, month)),
                style: const TextStyle(height: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                L10n.of(context).filter_select_year,
                style: const TextStyle(
                  fontSize: 17.5,
                ),
              ),
            ),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: List.generate(
                DateTime.now().year - 2013 + 1,
                (index) => _buildYearClip(context, index),
              ),
            ),
            if (controller.selectedYear != 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  L10n.of(context).filter_select_month,
                  style: const TextStyle(
                    fontSize: 17.5,
                  ),
                ),
              ),
            if (controller.selectedYear != 0)
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: List.generate(
                  DateTime.now().year == controller.selectedYear
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

  Widget _buildRatingContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                L10n.of(context).filter_select_rating,
                style: const TextStyle(
                  fontSize: 17.5,
                ),
              ),
              _buildRatingTypeButton(context),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            padding: MediaQuery.of(context).padding.copyWith(top: 0, bottom: 0),
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
                Tab(text: L10n.of(context).filter_tags),
                Tab(text: L10n.of(context).filter_date),
                Tab(text: L10n.of(context).filter_rating),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildTagContent(context),
                _buildDateContent(context),
                _buildRatingContent(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.init(targetTag);

    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).orientation == Orientation.portrait
            ? double.infinity
            : MediaQuery.of(context).size.width / 2,
        maxHeight: MediaQuery.of(context).orientation == Orientation.portrait &&
                MediaQuery.of(context).size.height > 600
            ? MediaQuery.of(context).size.height / 1.25
            : MediaQuery.of(context).size.height,
      ),
      builder: (BuildContext context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      L10n.of(context).filter,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildContent(context),
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  borderRadius: BorderRadius.zero,
                  onPressed: () {
                    controller.applyFilter();
                    Get.back();
                  },
                  child: Text(
                    L10n.of(context).apply,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
