import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../l10n.dart';
import '../../../../../data/enums/types.dart';
import 'controller.dart';

class FilterDialog extends GetWidget<FilterDialogController> {
  final String targetTag;

  const FilterDialog({
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
      padding: EdgeInsets.symmetric(vertical: 10),
      child: PopupMenuButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).cardColor),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => Text(
                  controller.selectedRatingType != ""
                      ? _getRatingLocalName(
                          context, controller.selectedRatingType)
                      : L10n.of(context).filter_select_rating,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(width: 10),
              FaIcon(
                FontAwesomeIcons.chevronDown,
                size: 20,
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
              style: TextStyle(color: Colors.grey),
            ),
          ),
          PopupMenuItem<RatingType>(
            value: RatingType.general,
            child: Text(
              _getRatingLocalName(context, RatingType.general),
              style: TextStyle(color: Colors.grey),
            ),
          ),
          PopupMenuItem<RatingType>(
            value: RatingType.ecchi,
            child: Text(
              _getRatingLocalName(context, RatingType.ecchi),
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
        onSelected: (RatingType rating) {
          controller.selectedRatingType = rating;
        },
      ),
    );
  }

  Widget _buildYearButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: PopupMenuButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).cardColor),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => Text(
                  controller.selectedYear != 0
                      ? controller.selectedYear.toString()
                      : L10n.of(context).filter_select_year,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(width: 10),
              FaIcon(
                FontAwesomeIcons.chevronDown,
                size: 20,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        itemBuilder: (context) => List.generate(
          DateTime.now().year - 2013 + 1,
          (index) {
            if (index == 0) {
              return PopupMenuItem<int>(
                value: 0,
                child: Text(
                  L10n.of(context).filter_select_year,
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            final year = 2013 + index;
            return PopupMenuItem<int>(
              value: year,
              child: Text(
                year.toString(),
                style: TextStyle(color: Colors.grey),
              ),
            );
          },
        ),
        onSelected: (int year) {
          controller.selectedYear = year;
        },
      ),
    );
  }

  Widget _buildMonthButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
      child: PopupMenuButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).cardColor),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => Text(
                  controller.selectedMonth != 0
                      ? DateFormat('MMM', L10n.of(context).localeName)
                          .format(DateTime(2000, controller.selectedMonth))
                      : L10n.of(context).filter_select_month,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(width: 10),
              FaIcon(
                FontAwesomeIcons.chevronDown,
                size: 20,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        itemBuilder: (context) => List.generate(
          DateTime.now().year == controller.selectedYear
              ? DateTime.now().month
              : 12 + 1,
          (index) {
            if (index == 0) {
              return PopupMenuItem<int>(
                value: 0,
                child: Text(
                  L10n.of(context).filter_select_month,
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            return PopupMenuItem<int>(
              value: index,
              child: Text(
                DateFormat('MMM', L10n.of(context).localeName)
                    .format(DateTime(2000, index)),
                style: TextStyle(color: Colors.grey),
              ),
            );
          },
        ),
        onSelected: (int month) {
          controller.selectedMonth = month;
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(L10n.of(context).filter_by_rating),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _buildRatingTypeButton(context),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(L10n.of(context).filter_by_date),
          ),
          ButtonBar(
            buttonPadding: EdgeInsets.zero,
            children: [
              _buildYearButton(context),
              Obx(
                () => Visibility(
                  visible: controller.selectedYear != 0,
                  child: _buildMonthButton(context),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.init(targetTag);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Theme.of(context).canvasColor,
      title: Text(
        L10n.of(context).filter,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: _buildContent(context),
      contentPadding: EdgeInsets.fromLTRB(25, 15, 25, 0),
      actionsAlignment: MainAxisAlignment.end,
      actionsPadding: EdgeInsets.fromLTRB(15, 0, 15, 10),
      actions: [
        CupertinoButton(
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
      ],
    );
  }
}
