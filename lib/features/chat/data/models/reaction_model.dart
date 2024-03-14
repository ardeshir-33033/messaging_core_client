import 'package:messaging_core/features/chat/domain/entities/category_users.dart';

class ReactionModel {
  CategoryUser user;
  int emoji;

  ReactionModel({required this.user, required this.emoji});

  static ReactionModel fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      user: CategoryUser.fromJson(json['user']),
      emoji: json['emoji'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user.toJson();
    data['emoji'] = emoji;

    return data;
  }

  static List<ReactionModel> listFromJson(dynamic json) {
    if (json != null) {
      return json.map<ReactionModel>((j) {
        return ReactionModel.fromJson(j);
      }).toList();
    }
    return [];
  }
}
