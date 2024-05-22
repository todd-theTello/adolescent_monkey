import 'package:adolescence_chat_bot/core/states/authentication/authentication.dart';
import 'package:adolescence_chat_bot/core/states/authentication/authorization.dart';
import 'package:adolescence_chat_bot/ui/widgets/text_fields/text_fields.dart';
import 'package:adolescence_chat_bot/utils/Space/vertical_space.dart';
import 'package:adolescence_chat_bot/utils/extensions/build_context.dart';
import 'package:adolescence_chat_bot/utils/extensions/error.dart';
import 'package:adolescence_chat_bot/utils/extensions/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/mixins/input_validation_mixins.dart';
import '../../utils/overlays/loading/loading_screen.dart';
import '../widgets/rich_text_widget/rich_text.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final formIsValid = ValueNotifier(false);
  final email = TextEditingController();
  final password = TextEditingController();
  void checkForm() {
    formIsValid.value = kIsEmailValid(email: email.text) && kIsPasswordValid(passwordText: password.text);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authenticationProvider, (previous, current) {
      if (current is AsyncLoading) {
        LoadingScreen.instance().show(context: context);
      } else {
        LoadingScreen.instance().hide();
      }
      if (current is AsyncError) {
        context.showErrorSnackBar(message: current.error.errorToString);
      }
    });
    return Scaffold(
      body: Column(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            children: [
              kVerticalSpace52,
              Text('Login to continue', style: context.titleLarge.copyWith(fontWeight: FontWeight.w500)),
              kVerticalSpace20,
              DefaultTextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                validatorPattern: kEmailValidationPattern,
                labelText: 'Email',
                hintText: 'Enter your email address',
                errorText: 'Please enter a valid email address',
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(kEmailInputPattern))],
                onChanged: checkForm,
              ),
              kVerticalSpace16,
              DefaultTextField(
                controller: password,
                keyboardType: TextInputType.visiblePassword,
                validatorPattern: kPasswordValidationPattern,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(kPasswordInputPattern))],
                errorText: 'Password must contain at least 8 characters',
                labelText: 'Password',
                hintText: 'Enter your password',
                hasTrailingObscureIcon: true,
                onChanged: checkForm,
              ),
              kVerticalSpace20,
              GestureDetector(
                child: Text(
                  'Forgot password?',
                  textAlign: TextAlign.right,
                  style: context.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                  ),
                ),
              ),
              kVerticalSpace20,
              ValueListenableBuilder(
                valueListenable: formIsValid,
                builder: (context, isValid, _) {
                  return FilledButton(
                    onPressed: isValid
                        ? () => ref.read(authenticationProvider.notifier).authenticate(
                              data: AuthenticationRequestData(email: email.text, password: password.text),
                            )
                        : null,
                    child: const Text('Login'),
                  );
                },
              )
            ],
          ).expanded,
          RichTextWidget(
            texts: [
              BaseText.plain(text: "Don't have an account?"),
              BaseText.custom(
                text: " Create one",
                onTapped: () => ref.read(routerConfigProvider.notifier).setRegister(),
              ),
            ],
          ),
          kVerticalSpace24,
        ],
      ).safeArea,
    );
  }
}
