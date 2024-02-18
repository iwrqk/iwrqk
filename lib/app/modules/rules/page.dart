import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../components/load_fail.dart';
import 'controller.dart';

class RulesPage extends GetView<RulesController> {
  const RulesPage({super.key});

  Widget _buildMarkdown(BuildContext context, String data) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config =
        isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: MarkdownGenerator().buildWidgets(
        data,
        config: config.copy(
          configs: [
            isDark ? PreConfig.darkConfig : const PreConfig(),
            TableConfig(
              wrapper: (child) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: child,
                );
              },
            ),
            LinkConfig(
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
              onTap: (url) async {
                var regex = RegExp(r"^http[s]?:\/\/");
                if (regex.hasMatch(url)) {
                  launchUrlString(url);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleContent(BuildContext context, String language) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...controller.rules.map((rule) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${controller.rules.indexOf(rule) + 1}. ${rule.title[language] ?? ''}",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              _buildMarkdown(context, rule.body[language] ?? ''),
            ],
          );
        }).toList(),
        FilledButton(
          child: Text(t.rules.accept),
          onPressed: () {
            Get.dialog(
              AlertDialog(
                title: Text(t.rules.accept),
                content: Text(t.rules.accept_desc),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      t.notifications.cancel,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                      controller.acceptRules();
                    },
                    child: Text(t.notifications.ok),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: Get.mediaQuery.padding.bottom + 16),
      ],
    );
  }

  Widget _buildDataWidget(BuildContext context) {
    return Obx(() => _buildRuleContent(context, controller.language));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.rules.title),
        actions: [
          IconButton(
            onPressed: () {
              controller.refreshData(showSplash: true);
            },
            icon: const Icon(Icons.refresh),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.translate),
            onSelected: (String language) {
              controller.language = language;
            },
            itemBuilder: (BuildContext context) {
              return controller.languages.map((language) {
                return PopupMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: controller.obx(
        (state) {
          return _buildDataWidget(context);
        },
        onError: (error) {
          return Center(
            child: LoadFail(
              errorMessage: error!,
              onRefresh: () {
                controller.refreshData(showSplash: true);
              },
            ),
          );
        },
        onLoading: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
