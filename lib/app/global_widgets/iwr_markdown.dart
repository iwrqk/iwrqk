import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../core/utils/url_util.dart';

class IwrMarkdown extends StatelessWidget {
  final String data;
  final bool selectable;
  final EdgeInsets padding;

  const IwrMarkdown(
      {super.key,
      required this.data,
      this.selectable = false,
      this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Markdown(
      selectable: selectable,
      onTapLink: (text, href, title) async {
        if (href == null) return;
        var regex = RegExp(r"^http[s]?:\/\/");
        if (regex.hasMatch(href)) {
          if (!await UrlUtil.jumpTo(href)) {
            launchUrlString(href);
          }
        }
      },
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      data: data,
    );
  }
}
