class Chat {
  final String? botResponse;
  final int? id;
  final String? timestamp;
  final String? userInput;

  Chat({this.botResponse, this.id, this.timestamp, this.userInput});

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        botResponse: json["bot_response"],
        id: json["id"],
        timestamp: json["timestamp"],
        userInput: json["user_input"],
      );

  Map<String, dynamic> toJson() => {
        "bot_response": botResponse,
        "id": id,
        "timestamp": timestamp,
        "user_input": userInput,
      };
}
