import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'iwr_markdown.dart';

class TranslatedContent extends StatelessWidget {
  final String translatedContent;
  final EdgeInsetsGeometry? padding;

  const TranslatedContent({
    super.key,
    required this.translatedContent,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FaIcon(
                  FontAwesomeIcons.language,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 5),
                AutoSizeText.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Powered by ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.5,
                        ),
                      ),
                      TextSpan(
                        text: "Google Translate",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IwrMarkdown(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            selectable: true,
            data: translatedContent,
          ),
        ],
      ),
    );
  }
}
