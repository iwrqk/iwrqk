import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import '../../../global_widgets/iwr_progress_indicator.dart';
import 'controller.dart';

class RegisterPage extends GetView<RegisterController> {
  RegisterPage({super.key});

  final FocusNode blankNode = FocusNode();
  final FocusNode focusNode = FocusNode();

  final BoxConstraints constraints = const BoxConstraints(maxWidth: 500);

  Widget _buildFailWidget(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                controller.loadData();
              },
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.arrowRotateLeft,
                  color: Theme.of(context).primaryColor,
                  size: 42,
                ),
              )),
          Container(
            margin: const EdgeInsets.all(20),
            child: Text(
              errorMessage,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
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
            L10n.of(context).register,
          )),
      body: controller.obx(
        (state) {
          return Form(
            key: controller.formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.1,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 25,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/app_icon.png",
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      constraints: constraints,
                      child: TextFormField(
                        validator: (input) {
                          if (input != null) {
                            if (input.isNotEmpty &&
                                controller.emailRegExp.hasMatch(input)) {
                              return null;
                            }
                          }
                          return L10n.of(context).message_please_type_email;
                        },
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(FontAwesomeIcons.solidEnvelope),
                          border: const OutlineInputBorder(),
                          labelText: L10n.of(context).email,
                        ),
                        onSaved: (input) => controller.email = input,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(focusNode);
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      constraints: constraints,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        child: AspectRatio(
                          aspectRatio: 30 / 4,
                          child: Image.memory(
                            controller.imageData,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      constraints: constraints,
                      child: TextFormField(
                        validator: (input) {
                          if (input != null) {
                            if (input.isNotEmpty) {
                              return null;
                            }
                          }
                          return L10n.of(context).message_please_type_captcha;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(FontAwesomeIcons.lock),
                          border: const OutlineInputBorder(),
                          labelText: L10n.of(context).captcha,
                        ),
                        onSaved: (input) => controller.captcha = input,
                        focusNode: focusNode,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      constraints: constraints,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15)),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(blankNode);
                          controller.register();
                        },
                        child: Text(
                          L10n.of(context).register,
                          style: const TextStyle(fontSize: 17.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        onLoading: const Center(
          child: IwrProgressIndicator(),
        ),
        onError: (error) => _buildFailWidget(context, error!),
      ),
    );
  }
}
