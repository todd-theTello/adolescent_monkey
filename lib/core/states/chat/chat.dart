import 'dart:async';

import 'package:adolescence_chat_bot/core/models/chat.dart';
import 'package:adolescence_chat_bot/core/repository/repository.dart';
import 'package:adolescence_chat_bot/core/server/endpoints.dart';
import 'package:adolescence_chat_bot/core/server/network_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatsProvider = AutoDisposeAsyncNotifierProvider<ChatsNotifier, List<Chat>>(
  () => ChatsNotifier(),
);

class ChatsNotifier extends AutoDisposeAsyncNotifier<List<Chat>> {
  final Repository _repository = Repository();
  @override
  FutureOr<List<Chat>> build() => getChats();

  Future<List<Chat>> getChats() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return _repository.makeRequest(
        path: Endpoints.chats,
        method: RequestMethod.get,
        fromJson: (json) => List<Chat>.from(
          (json as List<dynamic>).map((e) => Chat.fromJson(e)),
        ),
      );
    });
    return state.value!;
  }

  Future<void> askChat({required String text}) async {
    final chats = switch (state.value) { null => [], _ => [...state.value!] };
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final response = await _repository.makeRequest(
        path: Endpoints.bot,
        method: RequestMethod.post,
        data: {'input': text},
        fromJson: (json) => json['output'] as String?,
      );

      return [...chats, Chat(botResponse: response!, userInput: text)];
    });
  }
}
