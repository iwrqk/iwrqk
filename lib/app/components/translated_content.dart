import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.translate,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              TextSpan(
                text: "Powered by ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: 14,
                ),
              ),
              TextSpan(
                text: "Google Translate",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        SizedBox(
          width: double.infinity,
          child: IwrMarkdown(
            selectable: true,
            data: translatedContent,
          ),
        ),
      ],
    );
  }
}
