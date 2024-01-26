import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../routes/pages.dart';
import 'controller.dart';

class LoginPage extends GetView<LoginController> {
  LoginPage({super.key});

  final FocusNode blankNode = FocusNode();
  final FocusNode focusNode = FocusNode();

  final BoxConstraints constraints = const BoxConstraints(maxWidth: 500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.account.login,
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.2,
          ),
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  constraints: constraints,
                  child: TextFormField(
                    controller: controller.accountController,
                    validator: (input) {
                      if (input != null) {
                        if (input.isNotEmpty) {
                          return null;
                        }
                      }
                      return t.message.account.please_type_email_or_username;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      labelText: t.account.email_or_username,
                      border: const OutlineInputBorder(),
                    ),
                    onSaved: (input) => controller.account = input,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(focusNode);
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  constraints: constraints,
                  child: Obx(
                    () => TextFormField(
                      controller: controller.passwordController,
                      obscureText: !controller.passwordVisibility,
                      validator: (input) {
                        if (input == null) {
                          return t.message.account.please_type_password;
                        }
                        if (input.length < 6) {
                          return t.message.account.login_password_longer_than_6;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            controller.togglePasswordVisibility();
                          },
                          child: Icon(
                            controller.passwordVisibility
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        border: const OutlineInputBorder(),
                        labelText: t.account.password,
                      ),
                      onSaved: (input) => controller.password = input,
                      focusNode: focusNode,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20).copyWith(top: 0),
                  constraints: constraints,
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonal(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(blankNode);
                            Get.toNamed(AppRoutes.register);
                          },
                          child: Text(
                            t.account.register,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(blankNode);
                            controller.login(context);
                          },
                          child: Text(
                            t.account.login,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
