import 'package:adolescence_chat_bot/ui/widgets/animated_scale_button.dart';
import 'package:adolescence_chat_bot/ui/widgets/circle_container.dart';
import 'package:adolescence_chat_bot/utils/Space/vertical_space.dart';
import 'package:adolescence_chat_bot/utils/extensions/build_context.dart';
import 'package:adolescence_chat_bot/utils/extensions/error.dart';
import 'package:adolescence_chat_bot/utils/extensions/provider.dart';
import 'package:adolescence_chat_bot/utils/extensions/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../core/states/chat/chat.dart';
import '../widgets/netwrok_error_widget.dart';

class VoiceModeView extends ConsumerStatefulWidget {
  const VoiceModeView({super.key});

  @override
  ConsumerState createState() => _VoiceModeViewState();
}

class _VoiceModeViewState extends ConsumerState<VoiceModeView> {
  SpeechToText speechToText = SpeechToText();
  ValueNotifier<bool> speechEnabled = ValueNotifier(false);
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  String text = '';
  FlutterTts flutterTts = FlutterTts();
  bool toSpeach = false;
  final ValueNotifier<int?> messageIndex = ValueNotifier(null);
  @override
  void initState() {
    speechToText.initialize();
    Future(() => ref.read(chatsProvider.notifier).getChats());
    super.initState();
  }

  @override
  void dispose() {
    speechToText.cancel();
    speechEnabled.dispose();
    super.dispose();
  }

  Future<void> initSpeech() async => await speechToText.initialize();

  Future<void> startListening() async {
    speechEnabled.value = true;
    await speechToText.listen(
      onResult: (SpeechRecognitionResult result) {
        speechEnabled.value = true;

        text = result.recognizedWords;
      },
    );
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    speechEnabled.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(chatsProvider.buildWhenData);
    ref.listen(chatsProvider, (previous, current) async {
      if (current is AsyncLoading) {
        isLoading.value = true;
      } else {
        isLoading.value = false;
        speechEnabled.value = false;
      }

      if (current is AsyncData) {
        messageIndex.value = current.value!.length - 1;
        if (toSpeach) {
          toSpeach = false;
          await flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
          await flutterTts.speak(current.value!.last.botResponse!);
        }
      }
    });
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context, loading, _) {
                  if (loading) {
                    return CircleContainer(
                      color: context.primaryColor,
                      padding: const EdgeInsets.all(32),
                      child: LoadingAnimationWidget.discreteCircle(
                        color: Colors.white,
                        size: 80,
                      ),
                    );
                  }
                  return CustomAnimatedScale(
                    onPressed: () {},
                    onLongPress: () {
                      startListening();
                    },
                    onLongPressUp: () {
                      stopListening();
                      if (text.trim().isNotEmpty) {
                        toSpeach = true;
                        ref.read(chatsProvider.notifier).askChat(text: text);
                        text = '';
                      }
                    },
                    child: ValueListenableBuilder(
                        valueListenable: speechEnabled,
                        builder: (context, speech, _) {
                          return Column(
                            children: [
                              CircleContainer(
                                color: context.primaryColor,
                                padding: const EdgeInsets.all(32),
                                child: speechEnabled.value
                                    ? LoadingAnimationWidget.staggeredDotsWave(
                                        color: Colors.white,
                                        size: 80,
                                      )
                                    : const Icon(Iconsax.microphone, color: Colors.white, size: 80),
                              ),
                              kVerticalSpace12,
                              Text(
                                speech ? 'Listening' : 'Hold down to record then release to send',
                                style: context.titleMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          );
                        }),
                  );
                }),
          ),
          kVerticalSpace24,
          chat.when(
            data: (data) {
              return ValueListenableBuilder(
                  valueListenable: messageIndex,
                  builder: (context, index, _) {
                    return Row(
                      children: [
                        CustomAnimatedScale(
                          onPressed: () async {
                            if (index! > 0) {
                              messageIndex.value = messageIndex.value! - 1;

                              await flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
                              await flutterTts.speak(data![index].botResponse!);
                            }
                          },
                          child: CircleContainer(
                            color: index == 0 ? Colors.grey.shade400 : Colors.grey.shade700,
                            padding: const EdgeInsets.all(20),
                            child: const Icon(Iconsax.arrow_left, color: Colors.white),
                          ),
                        ),
                        Spacer(),
                        CustomAnimatedScale(
                          onPressed: () async {
                            if (index! < data!.length - 1) {
                              print('did this');
                              messageIndex.value = messageIndex.value! + 1;

                              await flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
                              await flutterTts.speak(data[index].botResponse!);
                            }
                          },
                          child: CircleContainer(
                            color: index == data!.length - 1 ? Colors.grey.shade400 : Colors.grey.shade700,
                            padding: const EdgeInsets.all(20),
                            child: const Icon(Iconsax.arrow_right_1, color: Colors.white),
                          ),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 32);
                  });
            },
            error: (error, stacktrace) {
              return NetworkErrorWidget(
                message: error.errorToString,
                onPressed: () => ref.read(chatsProvider.notifier).getChats(),
              );
            },
            loading: () => const Center(
              child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator.adaptive()),
            ),
          )
        ],
      ),
    );
  }
}
