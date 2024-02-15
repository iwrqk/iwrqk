import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../data/services/config_service.dart';
import '../../../utils/log_util.dart';

class DisplayModeDialog extends StatefulWidget {
  const DisplayModeDialog({super.key});

  @override
  State<DisplayModeDialog> createState() => _DisplayModeDialogState();
}

class _DisplayModeDialogState extends State<DisplayModeDialog> {
  List<DisplayMode> modes = <DisplayMode>[];
  DisplayMode? active;
  DisplayMode? preferred;

  final ConfigService _configService = Get.find();

  @override
  void initState() {
    super.initState();
    init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAll();
    });
  }

  Future<void> fetchAll() async {
    preferred = await FlutterDisplayMode.preferred;
    active = await FlutterDisplayMode.active;
    _configService.setting[ConfigKey.displayMode] = preferred.toString();
    setState(() {});
  }

  Future<void> init() async {
    try {
      modes = await FlutterDisplayMode.supported;
    } on PlatformException catch (e, stackTrace) {
      LogUtil.logger.e(e, stackTrace: stackTrace);
    }
    var res = await getDisplayModeType(modes);

    preferred = modes.toList().firstWhere((el) => el == res);
    FlutterDisplayMode.setPreferredMode(preferred!);
  }

  Future<DisplayMode> getDisplayModeType(modes) async {
    var value = _configService.setting[ConfigKey.displayMode];
    DisplayMode f = DisplayMode.auto;
    if (value != null) {
      f = modes.firstWhere((e) => e.toString() == value);
    }
    return f;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(t.settings.display_mode),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      content: Container(
        width: Get.width * 0.8,
        constraints: const BoxConstraints(maxHeight: 400),
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            if (modes.isEmpty)
              SliverToBoxAdapter(
                child: Text(t.display_mode.no_available),
              ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final DisplayMode mode = modes[index];

                  return RadioListTile<DisplayMode>(
                    value: mode,
                    title: mode == DisplayMode.auto
                        ? Text(t.display_mode.auto)
                        : Text(
                            '$mode${mode == active ? "  [${t.display_mode.system}]" : ""}',
                          ),
                    groupValue: preferred,
                    onChanged: (DisplayMode? newMode) async {
                      await FlutterDisplayMode.setPreferredMode(newMode!);
                      await Future<dynamic>.delayed(
                        const Duration(milliseconds: 100),
                      );
                      SmartDialog.showToast(t.message.restart_required);
                      HapticFeedback.mediumImpact();
                      await fetchAll();
                    },
                  );
                },
                childCount: modes.length,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(t.notifications.cancel),
        ),
      ],
    );
  }
}
