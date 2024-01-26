import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../components/load_fail.dart';
import 'controller.dart';

class RegisterPage extends GetView<RegisterController> {
  RegisterPage({super.key});

  final FocusNode blankNode = FocusNode();
  final FocusNode focusNode = FocusNode();

  final BoxConstraints constraints = const BoxConstraints(maxWidth: 500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.account.register,
        ),
      ),
      body: controller.obx(
        (state) {
          return Form(
            key: controller.formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.15,
              ),
              children: [
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
                          return t.message.account.please_type_email;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          border: const OutlineInputBorder(),
                          labelText: t.account.email,
                        ),
                        onSaved: (input) => controller.email = input,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(focusNode);
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      constraints: constraints,
                      child: ClipRRect(
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
                          return t.message.account.please_type_captcha;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          border: const OutlineInputBorder(),
                          labelText: t.account.captcha,
                        ),
                        onSaved: (input) => controller.captcha = input,
                        focusNode: focusNode,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 24),
                      constraints: constraints,
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(blankNode);
                          controller.register();
                        },
                        child: Text(
                          t.account.register,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        onLoading: const Center(child: CircularProgressIndicator()),
        onError: (error) => Center(
          child: LoadFail(
            errorMessage: error!,
            onRefresh: controller.loadData,
          ),
        ),
      ),
    );
  }
}
