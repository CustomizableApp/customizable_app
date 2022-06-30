class LikeDislikeCommentItemModel {
  String id;
  int like;
  int dislike;
  List<CommentModel>? comments;
  LikeDislikeCommentItemModel({
    required this.id,
    required this.like,
    required this.dislike,
    this.comments,
  });

  factory LikeDislikeCommentItemModel.fromMap(Map<String, dynamic> map) {
    return LikeDislikeCommentItemModel(
      id: map['id'] ?? '',
      like: map['like']?.toInt() ?? 0,
      dislike: map['dislike']?.toInt() ?? 0,
      comments: map['comments'] != null
          ? List<CommentModel>.from(
              map['comments']?.map((x) => CommentModel.fromMap(x)))
          : null,
    );
  }
}

class CommentModel {
  String comment;
  String id;
  String likeDislikeFieldId;
  String userId;
  CommentModel({
    required this.comment,
    required this.id,
    required this.likeDislikeFieldId,
    required this.userId,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      comment: map['comment'] ?? '',
      id: map['id'] ?? '',
      likeDislikeFieldId: map['l_c_d_field_id'] ?? '',
      userId: map['user_id'] ?? '',
    );
  }
}
