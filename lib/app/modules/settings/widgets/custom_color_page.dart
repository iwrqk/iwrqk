import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../const/colors.dart';
import '../../../data/services/config_service.dart';

class CustomColorPage extends StatefulWidget {
  const CustomColorPage({super.key});

  @override
  State<CustomColorPage> createState() => _CustomColorPageState();
}

class _CustomColorPageState extends State<CustomColorPage> {
  final ConfigService _configService = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.settings.custom_color,
        ),
      ),
      body: ListView(
        children: [
          Obx(
            () {
              return Padding(
                padding:
                    EdgeInsets.only(top: Get.height * 0.1, left: 12, right: 12),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 22,
                  runSpacing: 18,
                  children: [
                    ...colorThemeTypes.map(
                      (e) {
                        final index = colorThemeTypes.indexOf(e);
                        return GestureDetector(
                          onTap: () {
                            _configService.customColor = index;
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: e['color'].withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    width: 2,
                                    color: _configService.customColor == index
                                        ? Colors.black
                                        : e['color'].withOpacity(0.8),
                                  ),
                                ),
                                child: AnimatedOpacity(
                                  opacity: _configService.customColor == index
                                      ? 1
                                      : 0,
                                  duration: const Duration(milliseconds: 200),
                                  child: const Icon(
                                    Icons.done,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                t[e['label']],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _configService.customColor != index
                                      ? Theme.of(context).colorScheme.outline
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
