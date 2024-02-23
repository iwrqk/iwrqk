import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/url_util.dart';

class IwrMarkdown extends StatelessWidget {
  final String data;
  final bool selectable;

  const IwrMarkdown({
    super.key,
    required this.data,
    this.selectable = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config =
        isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;

    Widget child = Column(
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
                  if (!await UrlUtil.jumpTo(url)) {
                    launchUrlString(url);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );

    return selectable ? SelectionArea(child: child) : child;
  }
}
