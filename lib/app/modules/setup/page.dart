import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../l10n.dart';
import '../../routes/pages.dart';
import 'controller.dart';

class SetupPage extends GetView<SetupController> {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          WelcomePage(controller: controller),
          LanguageSelectPage(controller: controller),
          ThemeSelectPage(controller: controller),
          FinishPage(controller: controller),
        ],
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  final SetupController controller;

  const WelcomePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 50,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/app_icon.png",
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "IwrQk",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(controller.l10n.get_started),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class LanguageSelectPage extends StatelessWidget {
  final SetupController controller;

  const LanguageSelectPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Theme.of(context).canvasColor,
          alignment: Alignment.centerLeft,
          padding: MediaQuery.of(context).padding.copyWith(bottom: 0),
          child: SizedBox(
            height: kTextTabBarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.only(left: 15),
                  borderRadius: BorderRadius.zero,
                  onPressed: () {
                    controller.pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: Text(
                    controller.l10n.back,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.only(right: 15),
                  borderRadius: BorderRadius.zero,
                  onPressed: () {
                    controller.pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: Text(
                    controller.l10n.skip,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1),
                alignment: Alignment.center,
                child: FaIcon(
                  FontAwesomeIcons.earthAmericas,
                  size: 150,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20).add(
                  const EdgeInsets.only(bottom: 25),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        controller.setLanguage(
                            L10n.languageMap.keys.elementAt(index));
                        controller.pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(L10n.languageMap.values.elementAt(index)),
                            FaIcon(
                              FontAwesomeIcons.circleRight,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: L10n.languageMap.length,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ThemeSelectPage extends StatelessWidget {
  final SetupController controller;

  const ThemeSelectPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final Map<ThemeMode, String> themeMap = {
      ThemeMode.system: controller.l10n.theme_system,
      ThemeMode.light: controller.l10n.theme_light_mode,
      ThemeMode.dark: controller.l10n.theme_dark_mode,
    };

    return Column(
      children: [
        Container(
          color: Theme.of(context).canvasColor,
          alignment: Alignment.centerLeft,
          padding: MediaQuery.of(context).padding.copyWith(bottom: 0),
          child: SizedBox(
            height: kTextTabBarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.only(left: 15),
                  borderRadius: BorderRadius.zero,
                  onPressed: () {
                    controller.pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: Text(
                    controller.l10n.back,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.only(right: 15),
                  borderRadius: BorderRadius.zero,
                  onPressed: () {
                    controller.pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: Text(
                    controller.l10n.skip,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1),
                alignment: Alignment.center,
                child: FaIcon(
                  FontAwesomeIcons.palette,
                  size: 150,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20).add(
                  const EdgeInsets.only(bottom: 25),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        controller.configService.themeMode =
                            themeMap.keys.elementAt(index);
                        controller.pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(themeMap.values.elementAt(index)),
                            FaIcon(
                              FontAwesomeIcons.circleRight,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: themeMap.length,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FinishPage extends StatelessWidget {
  final SetupController controller;

  const FinishPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Theme.of(context).canvasColor,
          alignment: Alignment.centerLeft,
          padding: MediaQuery.of(context).padding.copyWith(bottom: 0),
          child: SizedBox(
            height: kTextTabBarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.only(left: 15),
                  borderRadius: BorderRadius.zero,
                  onPressed: () {
                    controller.pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: Text(
                    controller.l10n.back,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.only(right: 15),
                  borderRadius: BorderRadius.zero,
                  onPressed: () {
                    controller.configService.setFirstRun(false);
                    Get.toNamed(AppRoutes.home);
                  },
                  child: Text(
                    controller.l10n.finish,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1),
                alignment: Alignment.center,
                child: FaIcon(
                  FontAwesomeIcons.circleCheck,
                  size: 150,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20).add(
                  const EdgeInsets.only(bottom: 25),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [
                    Text(
                      controller.l10n.finish,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        controller.l10n.setup_finish_description,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
