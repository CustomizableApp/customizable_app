class FeedDataModel{
  String content;
  String userID;
  String timeStamp;
  int contentType;

  FeedDataModel({required this.content,required this.contentType,required this.timeStamp,required this.userID});

  factory FeedDataModel.fromMap(Map<String, dynamic> map) {
    return FeedDataModel(
      content: map['content'] ?? '',
      contentType: map['content_type'] ?? '',
      timeStamp:map['time_stamp'] ?? '',
      userID: map['user_id'] ?? '',
    );
  }
}