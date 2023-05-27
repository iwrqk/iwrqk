import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import '../../../global_widgets/iwr_progress_indicator.dart';
import 'controller.dart';

class RegisterPage extends GetView<RegisterController> {
  RegisterPage({super.key});

  FocusNode blankNode = FocusNode();
  FocusNode focusNode = FocusNode();

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
            margin: EdgeInsets.all(20),
            child: Text(
              errorMessage,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.grey),
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
            icon: FaIcon(FontAwesomeIcons.chevronLeft),
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
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 500,
              ),
              child: Form(
                key: controller.formKey,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 25),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/app_icon.png",
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                          prefixIcon: Icon(FontAwesomeIcons.solidEnvelope),
                          border: OutlineInputBorder(),
                          labelText: L10n.of(context).email,
                        ),
                        onSaved: (input) => controller.email = input,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(focusNode);
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: AspectRatio(
                          aspectRatio: 30 / 4,
                          child: Image.memory(
                            controller.imageData,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                          prefixIcon: Icon(FontAwesomeIcons.lock),
                          border: OutlineInputBorder(),
                          labelText: L10n.of(context).captcha,
                        ),
                        onSaved: (input) => controller.captcha = input,
                        focusNode: focusNode,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15)),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(blankNode);
                          controller.register();
                        },
                        child: Text(
                          L10n.of(context).register,
                          style: TextStyle(fontSize: 17.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        onLoading: Center(
          child: IwrProgressIndicator(),
        ),
        onError: (error) => _buildFailWidget(context, error!),
      ),
    );
  }
}
