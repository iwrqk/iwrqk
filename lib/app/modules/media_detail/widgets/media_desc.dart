import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../components/iwr_markdown.dart';
import '../../../components/translated_content.dart';
import '../../../data/models/media/media.dart';
import '../../../data/providers/translate_provider.dart';
import '../../../utils/display_util.dart';

class MeidaDescription extends StatefulWidget {
  final MediaModel media;

  const MeidaDescription({
    super.key,
    required this.media,
  });

  @override
  State<MeidaDescription> createState() => _MeidaDescriptionState();
}

class _MeidaDescriptionState extends State<MeidaDescription> {
  String? translatedContent;

  void _getTranslatedContent() async {
    if (translatedContent != null || widget.media.body == null) {
      return;
    }
    TranslateProvider.google(
      text: widget.media.body!,
    ).then((value) {
      if (value.success) {
        setState(() {
          translatedContent = value.data;
        });
      } else {
        SmartDialog.showToast(value.message!);
      }
    });
  }

  Widget _buildTagClip(BuildContext context, int index) {
    var tag = widget.media.tags[index];

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: tag.id));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            tag.id,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.only(left: 16, right: 16),
      height: Get.height - Get.width / 16 * 9 - Get.mediaQuery.padding.top,
      child: Column(
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              height: 36,
              padding: const EdgeInsets.only(bottom: 2),
              child: Center(
                child: Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.media.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    width: double.infinity,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(
                                Icons.remove_red_eye,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: DisplayUtil.compactBigNumber(
                                widget.media.numViews),
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const WidgetSpan(
                            child: SizedBox(width: 16),
                          ),
                          TextSpan(
                            text: DisplayUtil.getDetailedTime(
                              DateTime.parse(widget.media.createdAt),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  if (widget.media.body != null)
                    SizedBox(
                      width: double.infinity,
                      child: IwrMarkdown(
                        selectable: true,
                        data: widget.media.body ?? "",
                      ),
                    ),
                  if (translatedContent == null &&
                      widget.media.body != null) ...[
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        backgroundColor:
                            Theme.of(context).colorScheme.onInverseSurface,
                      ),
                      onPressed: () {
                        _getTranslatedContent();
                      },
                      child: Text(t.common.translate),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (translatedContent != null)
                    TranslatedContent(
                      padding: const EdgeInsets.only(top: 12),
                      translatedContent: translatedContent!,
                    ),
                  if (widget.media.tags.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.start,
                        children: List.generate(
                          widget.media.tags.length,
                          (index) => _buildTagClip(context, index),
                        ),
                      ),
                    ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
