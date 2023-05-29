import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import 'controller.dart';

class SetPasswordPage extends GetView<SetPasswordController> {
  const SetPasswordPage({super.key});

  Widget _buildPasswordDots(BuildContext context) {
    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(6, (index) {
        return Obx(
          () => Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: controller.currentPassword.length > index
                  ? Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey),
            ),
          ),
        );
      }),
    );
    return AnimatedBuilder(
      animation: controller.passwordErrorShakeController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              sin(controller.passwordErrorShakeAnimation.value * 4 * pi) * 15,
              0),
          child: child,
        );
      },
      child: child,
    );
  }

  Widget _buildNumberDot(int number, {String? subtitle}) {
    return InkWell(
      onTap: () {
        controller.addPassword(number.toString());
      },
      borderRadius: BorderRadius.circular(1000),
      splashColor: Colors.transparent,
      child: Container(
        width: 75,
        height: 75,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number.toString(),
              style: const TextStyle(fontSize: 30),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: const TextStyle(fontSize: 10),
              ),
          ],
        ),
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
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0,
          ),
        ),
        centerTitle: true,
        title: Text(
          L10n.of(context).set_password,
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          highlightColor: Theme.of(context).brightness == Brightness.light
              ? ThemeData.light().highlightColor
              : ThemeData.dark().highlightColor,
        ),
        child: CustomScrollView(
          slivers: [
            SliverSafeArea(
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(
                          () => Text(
                            controller.confirmingPassword
                                ? L10n.of(context).repeat_password
                                : L10n.of(context).set_password,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 50),
                          child: _buildPasswordDots(context),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildNumberDot(1, subtitle: ''),
                              _buildNumberDot(2, subtitle: 'ABC'),
                              _buildNumberDot(3, subtitle: 'DEF'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildNumberDot(4, subtitle: 'GHI'),
                              _buildNumberDot(5, subtitle: 'JKL'),
                              _buildNumberDot(6, subtitle: 'MNO'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildNumberDot(7, subtitle: 'PQRS'),
                              _buildNumberDot(8, subtitle: 'TUV'),
                              _buildNumberDot(9, subtitle: 'WXYZ'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 75),
                              _buildNumberDot(0),
                              InkWell(
                                onTap: () {
                                  controller.removePassword();
                                },
                                borderRadius: BorderRadius.circular(1000),
                                splashColor: Colors.transparent,
                                child: Container(
                                  width: 75,
                                  height: 75,
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child:
                                      const Icon(FontAwesomeIcons.deleteLeft),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
