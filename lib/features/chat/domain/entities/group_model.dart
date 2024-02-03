class GroupModel {
  int id;
  String name;
  String? avatar;
  int? creatorUserId;
  int categoryId;
  DateTime createdAt;
  DateTime updatedAt;

  GroupModel(
      {required this.id,
      required this.name,
      this.avatar,
      this.creatorUserId,
      required this.categoryId,
      required this.createdAt,
      required this.updatedAt});

  static GroupModel fromJson(Map<String, dynamic> json) {
    return GroupModel(
        id: json['id'],
        name: json['name'],
        avatar: json['avatar'],
        creatorUserId: json['creator_user_id'],
        categoryId: json['category_id'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updated_at']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['avatar'] = avatar;
    data['creator_user_id'] = creatorUserId;
    data['category_id'] = categoryId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  List<GroupModel> listFromJson(dynamic json) {
    if (json != null) {
      return json.map<GroupModel>((j) {
        return GroupModel.fromJson(j);
      }).toList();
    }
    return [];
  }
}
