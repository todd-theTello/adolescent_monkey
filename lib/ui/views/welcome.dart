import 'package:adolescence_chat_bot/utils/extensions/build_context.dart';
import 'package:adolescence_chat_bot/utils/extensions/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/states/authentication/authorization.dart';
import '../../utils/Space/vertical_space.dart';
import '../widgets/rich_text_widget/rich_text.dart';

class WelcomeView extends ConsumerStatefulWidget {
  const WelcomeView({super.key});

  @override
  ConsumerState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeView> {
  final PageController pageController = PageController();
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageView(
            controller: pageController,
            children: [
              Column(
                children: [
                  Text(
                    'Explore Your World',
                    style: context.displayLarge,
                  ).paddingSymmetric(horizontal: 20),
                  kVerticalSpace12,
                  Text(
                    'Discover new knowledge, connect with your culture, and expand your horizons with our interactive chatbot designed just for you.',
                    style: context.bodyMedium,
                  ).paddingSymmetric(horizontal: 20),
                  kVerticalSpace24,
                  SvgPicture.asset('assets/images/onboarding-1.svg').centerRightAlign.expanded,
                ],
              ),
              Column(
                children: [
                  Text(
                    'Learn and grow',
                    style: context.displayLarge,
                  ).paddingSymmetric(horizontal: 20),
                  kVerticalSpace12,
                  Text(
                    'From science to history, get answers to all your questions and boost your skills with engaging and fun educational content.',
                    style: context.bodyMedium,
                  ).paddingSymmetric(horizontal: 20),
                  kVerticalSpace24,
                  SvgPicture.asset('assets/images/onboarding-2.svg').centerRightAlign.expanded,
                ],
              ),
              Column(
                children: [
                  Text(
                    'Stay Connected',
                    style: context.displayLarge,
                  ).paddingSymmetric(horizontal: 20),
                  kVerticalSpace12,
                  Text(
                    'Join a community of curious minds, share your thoughts, and stay informed about important topics affecting adolescents in Ghana.',
                    style: context.bodyMedium,
                  ).paddingSymmetric(horizontal: 20),
                  kVerticalSpace24,
                  SvgPicture.asset('assets/images/onboarding-3.svg').centerRightAlign.expanded,
                ],
              ),
            ],
          ).expanded,
          kVerticalSpace16,
          SmoothPageIndicator(
            controller: pageController,
            count: 3,
            effect: JumpingDotEffect(activeDotColor: context.primaryColor, dotHeight: 12, dotWidth: 12),
          ).center,
          kVerticalSpace16,
          FilledButton(
            onPressed: () {
              ref.read(routerConfigProvider.notifier).setRegister();
            },
            child: const Text('Get started'),
          ).paddingSymmetric(horizontal: 20),
          kVerticalSpace20,
          RichTextWidget(
            texts: [
              BaseText.plain(text: "Already have an account?"),
              BaseText.custom(
                text: " Login",
                onTapped: () => ref.read(routerConfigProvider.notifier).setLogin(),
              ),
            ],
            textAlign: TextAlign.center,
          ),
          kVerticalSpace24,
        ],
      ).safeArea,
    );
  }
}
