import 'package:adolescence_chat_bot/core/states/authentication/authorization.dart';
import 'package:adolescence_chat_bot/core/states/chat/chat.dart';
import 'package:adolescence_chat_bot/core/states/user/users.dart';
import 'package:adolescence_chat_bot/ui/theme/colors.dart';
import 'package:adolescence_chat_bot/ui/widgets/animated_scale_button.dart';
import 'package:adolescence_chat_bot/ui/widgets/chat_bubbles.dart';
import 'package:adolescence_chat_bot/ui/widgets/circle_container.dart';
import 'package:adolescence_chat_bot/ui/widgets/netwrok_error_widget.dart';
import 'package:adolescence_chat_bot/utils/Space/horizontal_space.dart';
import 'package:adolescence_chat_bot/utils/Space/vertical_space.dart';
import 'package:adolescence_chat_bot/utils/extensions/build_context.dart';
import 'package:adolescence_chat_bot/utils/extensions/error.dart';
import 'package:adolescence_chat_bot/utils/extensions/objects.dart';
import 'package:adolescence_chat_bot/utils/extensions/provider.dart';
import 'package:adolescence_chat_bot/utils/extensions/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final text = TextEditingController();
  final ValueNotifier<String?> inputText = ValueNotifier(null);
  SpeechToText speechToText = SpeechToText();
  ValueNotifier<bool> speechEnabled = ValueNotifier(false);

  @override
  void initState() {
    initSpeech();
    super.initState();
  }

  /// This has to happen only once per app
  void initSpeech() async {
    await speechToText.initialize();
  }

  /// Each time to start a speech recognition session
  Future<void> startListening() async {
    speechEnabled.value = true;
    await speechToText.listen(onResult: onSpeechResult);
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    speechEnabled.value = false;

    await speechToText.stop();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    text.text = result.recognizedWords;
  }

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final chats = ref.watch(chatsProvider.buildWhenData);

    ref
      ..listen(userProvider, (previous, current) {
        if (current is AsyncError) {
          if ((current.error as DioException).response?.statusCode == 401) {
            ref.read(routerConfigProvider.notifier).setLogOut();
          }
        }
      })
      ..listen(chatsProvider, (previous, current) {
        if (current is! AsyncLoading) {
          inputText.value = null;
        }
      });
    return Scaffold(
      appBar: user.when(
        data: (data) {
          return AppBar(
            title: const Text('Adolescent Monkey'),
            actions: [
              IconButton(
                onPressed: () async => showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialogWidget(
                    confirmAction: () => ref.read(routerConfigProvider.notifier).setLogOut(),
                    header: 'Logout',
                    content: 'Are you sure you want to logout?',
                    confirmActionText: 'Yes, Logout',
                  ),
                ),
                icon: const Icon(Iconsax.logout),
              )
            ],
          );
        },
        error: (_, __) => null,
        loading: () => null,
      ),
      body: user.when(
        data: (data) => Column(
          children: [
            chats
                .when(
                  data: (data) {
                    return switch (data!.isNotEmpty) {
                      true => ValueListenableBuilder(
                          valueListenable: inputText,
                          builder: (context, text, _) {
                            return ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                              itemBuilder: (context, index) {
                                if (text.isNotNull && index == data.length) {
                                  return CustomPaint(
                                    painter: UserChatBubble(context: context),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                                      constraints: BoxConstraints(
                                        minWidth: 64,
                                        maxWidth: MediaQuery.sizeOf(context).width * 0.7,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            text!,
                                            style: context.bodyMedium.copyWith(color: kDarkColor.shade800),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                            width: 12,
                                            child: CircularProgressIndicator.adaptive(),
                                          ).centerRightAlign
                                        ],
                                      ),
                                    ),
                                  ).centerRightAlign;
                                }
                                final chat = data[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    CustomPaint(
                                      painter: UserChatBubble(context: context),
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                                        constraints: BoxConstraints(
                                          minWidth: 64,
                                          maxWidth: MediaQuery.sizeOf(context).width * 0.7,
                                        ),
                                        child: Text(
                                          chat.userInput!,
                                          style: context.bodyMedium.copyWith(color: kDarkColor.shade800),
                                        ),
                                      ),
                                    ).centerRightAlign,
                                    kVerticalSpace12,
                                    CustomPaint(
                                      painter: BotChatBubble(context: context),
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                                        constraints: BoxConstraints(
                                          minWidth: 64,
                                          maxWidth: MediaQuery.sizeOf(context).width * 0.7,
                                        ),
                                        child: Text(
                                          chat.botResponse!,
                                          style: context.bodyMedium.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ).centerLeftAlign,
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) => kVerticalSpace16,
                              itemCount: text.isNotNull ? data.length + 1 : data.length,
                            );
                          }),
                      _ => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/images/chats.svg', height: 140),
                            kVerticalSpace20,
                            Center(
                              child: Text('This is the beginning of your session', style: context.bodyLarge),
                            ),
                          ],
                        ),
                    };
                  },
                  error: (err, stacktrace) {
                    return Text(err.errorToString);
                  },
                  loading: () => const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                )
                .expanded,
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                border: Border(
                  top: BorderSide(color: kDarkColor.shade300),
                ),
              ),
              child: Row(
                children: [
                  TextField(
                    controller: text,
                    onSubmitted: (_) {
                      if (text.text.trim().isNotEmpty) {
                        stopListening();
                        inputText.value = text.text.trim();
                        ref.read(chatsProvider.notifier).askChat(text: text.text);
                        text.clear();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Ask any question...',
                      suffixIcon: ValueListenableBuilder(
                          valueListenable: speechEnabled,
                          builder: (context, enabled, _) {
                            return IconButton(
                              onPressed: () => enabled ? stopListening() : startListening(),
                              icon: Icon(enabled ? Iconsax.microphone_slash : Iconsax.microphone),
                            );
                          }),
                    ),
                  ).expanded,
                  kHorizontalSpace16,
                  CustomAnimatedScale(
                    onPressed: () {
                      if (text.text.trim().isNotEmpty) {
                        stopListening();
                        inputText.value = text.text.trim();
                        ref.read(chatsProvider.notifier).askChat(text: text.text);
                        text.clear();
                      }
                    },
                    child: CircleContainer(
                      color: context.primaryColor,
                      padding: const EdgeInsets.all(12),
                      child: const Icon(Iconsax.send1, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        error: (error, stacktrace) {
          return NetworkErrorWidget(
              message: error.errorToString,
              onPressed: () {
                ref.read(userProvider.notifier).getUser();
              });
        },
        loading: () => const Center(
          child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator.adaptive()),
        ),
      ),
    );
  }
}

///
class AlertDialogWidget extends StatelessWidget {
  ///
  const AlertDialogWidget({
    required this.confirmAction,
    required this.header,
    required this.content,
    this.destroyAction,
    this.confirmActionText,
    this.destroyActionText,
    super.key,
  });

  ///
  final VoidCallback confirmAction;

  ///
  final VoidCallback? destroyAction;

  ///
  final String header;

  ///
  final String content;

  ///
  final String? confirmActionText;

  ///
  final String? destroyActionText;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 296,
            minHeight: 140,
            maxWidth: 500,
            minWidth: 200,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                header,
                textAlign: TextAlign.center,
                style: context.titleLarge.copyWith(fontWeight: FontWeight.w500, color: kDarkColor.shade800),
              ),
              kVerticalSpace8,
              Text(
                content,
                textAlign: TextAlign.center,
                style: context.bodyMedium.copyWith(color: kDarkColor.shade500),
              ),
              kVerticalSpace20,
              Row(
                children: [
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: confirmAction,
                    child: Text(confirmActionText ?? 'Yes, Delete'),
                  ).expanded,
                  kHorizontalSpace12,
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: kDarkColor.shade200,
                      foregroundColor: kDarkColor.shade800,
                    ),
                    onPressed: destroyAction ?? () => Navigator.of(context).pop(),
                    child: Text(destroyActionText ?? 'Cancel'),
                  ).expanded
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
