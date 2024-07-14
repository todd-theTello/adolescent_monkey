import 'package:adolescence_chat_bot/core/states/authentication/authentication.dart';
import 'package:adolescence_chat_bot/ui/widgets/rich_text_widget/rich_text.dart';
import 'package:adolescence_chat_bot/utils/Space/horizontal_space.dart';
import 'package:adolescence_chat_bot/utils/extensions/build_context.dart';
import 'package:adolescence_chat_bot/utils/extensions/date_time.dart';
import 'package:adolescence_chat_bot/utils/extensions/error.dart';
import 'package:adolescence_chat_bot/utils/extensions/objects.dart';
import 'package:adolescence_chat_bot/utils/extensions/widgets.dart';
import 'package:adolescence_chat_bot/utils/overlays/loading/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/states/authentication/authorization.dart';
import '../../utils/Space/vertical_space.dart';
import '../../utils/mixins/input_validation_mixins.dart';
import '../widgets/text_fields/text_fields.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final firstName = TextEditingController();
  final surname = TextEditingController();
  final ValueNotifier<DateTime?> dateOfBirth = ValueNotifier(null);
  final email = TextEditingController();
  final password = TextEditingController();

  final ValueNotifier<Gender?> gender = ValueNotifier(null);
  final ValueNotifier<DisabilityStatus> disabilityStatus = ValueNotifier(DisabilityStatus.notDisabled);
  final formIsValid = ValueNotifier(false);

  void checkForm() {
    formIsValid.value = kIsEmailValid(email: email.text) &&
        kIsPasswordValid(passwordText: password.text) &&
        dateOfBirth.value.isNotNull &&
        firstName.text.trim().isNotEmpty &&
        surname.text.trim().isNotEmpty &&
        gender.value.isNotNull &&
        disabilityStatus.value.isNotNull;
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        children: [
          kVerticalSpace16,
          SvgPicture.asset('assets/images/adole-bot.svg', height: 120),
          Text(
            'Welcome to Teen Bot',
            style: context.titleMedium.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          kVerticalSpace8,
          Text('Create a free Knowledge Navigator account and spark your curiosity!', style: context.bodyMedium),
          kVerticalSpace24,
          Row(
            children: [
              DefaultTextField(
                controller: firstName,
                validatorPattern: '',
                labelText: 'First Name',
                hintText: 'Enter first name ',
                errorText: 'First name cannot be empty',
                onChanged: checkForm,
              ).expanded,
              kHorizontalSpace16,
              DefaultTextField(
                controller: surname,
                validatorPattern: '',
                labelText: 'Surname',
                hintText: 'Enter your surname',
                errorText: 'Surname cannot be empty',
                onChanged: checkForm,
              ).expanded,
            ],
          ),
          kVerticalSpace20,
          ValueListenableBuilder(
              valueListenable: dateOfBirth,
              builder: (context, date, _) {
                return DefaultTextField(
                  controller: TextEditingController(text: date.isNotNull ? date!.dateTimeToString : ''),
                  readOnly: true,
                  onTap: () async {
                    dateOfBirth.value = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now().subtract(const Duration(days: 7300)),
                          lastDate: DateTime.now().subtract(const Duration(days: 3650)),
                        ) ??
                        dateOfBirth.value;
                    checkForm();
                  },
                  validatorPattern: '',
                  labelText: 'Date of Birth',
                  hintText: 'Select your date of birth',
                  suffixIcon: const Icon(Iconsax.calendar),
                );
              }),
          kVerticalSpace20,
          Text('Gender', style: context.bodyMedium.copyWith(fontWeight: FontWeight.w600))
              .paddingSymmetric(horizontal: 8),
          ValueListenableBuilder(
            valueListenable: gender,
            builder: (context, selected, _) => Row(
              children: [
                Radio(
                  value: Gender.male,
                  groupValue: selected,
                  onChanged: (value) => gender.value = value,
                ),
                const Text('Male'),
                kHorizontalSpace16,
                Radio(
                  value: Gender.female,
                  groupValue: selected,
                  onChanged: (value) => gender.value = value,
                ),
                const Text('Female')
              ],
            ),
          ),
          Text('Disability', style: context.bodyMedium.copyWith(fontWeight: FontWeight.w600))
              .paddingSymmetric(horizontal: 8),
          ValueListenableBuilder(
              valueListenable: disabilityStatus,
              builder: (context, selected, _) {
                return Row(
                  children: List.generate(
                    DisabilityStatus.values.length,
                    (index) {
                      final disability = DisabilityStatus.values[index];
                      return Row(
                        children: [
                          Radio(
                            value: disability,
                            groupValue: selected,
                            onChanged: (value) => disabilityStatus.value = value!,
                          ),
                          Text(disability.name),
                        ],
                      );
                    },
                  ),
                );
              }),
          kVerticalSpace20,
          DefaultTextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            validatorPattern: kEmailValidationPattern,
            labelText: 'Email',
            hintText: 'Enter your email address',
            errorText: 'Please enter a valid email address',
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(kEmailInputPattern)),
            ],
            onChanged: checkForm,
          ),
          kVerticalSpace20,
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
          ValueListenableBuilder(
              valueListenable: formIsValid,
              builder: (context, isValid, _) {
                return FilledButton(
                  onPressed: isValid
                      ? () {
                          ref.read(authenticationProvider.notifier).authenticate(
                                data: AuthenticationRequestData(
                                  email: email.text,
                                  password: password.text,
                                  gender: gender.value!.value,
                                  dateOfBirth: dateOfBirth.value,
                                  firstName: firstName.text,
                                  surname: surname.text,
                                  type: disabilityStatus.value.value,
                                ),
                              );
                        }
                      : null,
                  child: const Text('Register'),
                );
              }),
          kVerticalSpace24,
          RichTextWidget(
            texts: [
              BaseText.plain(text: "Already have an account?"),
              BaseText.custom(text: " Sign in", onTapped: () => ref.read(routerConfigProvider.notifier).setLogin()),
            ],
            textAlign: TextAlign.center,
          ),
        ],
      ).safeArea,
    );
  }
}

enum Gender {
  male(name: 'Male', value: 'MALE'),
  female(name: 'Female', value: 'FEMALE');

  const Gender({required this.name, required this.value});
  final String name;
  final String value;
}

enum DisabilityStatus {
  notDisabled(name: 'Not disabled', value: 'NOT DISABLED'),
  blind(name: 'Blind', value: 'BLIND'),
  deaf(name: 'Deaf', value: 'DEAF');

  const DisabilityStatus({required this.name, required this.value});
  final String name;
  final String value;
}
