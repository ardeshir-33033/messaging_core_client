class GroupUsersModel {
  int id;
  String name;

  GroupUsersModel({required this.id, required this.name});

  static GroupUsersModel fromJson(Map<String, dynamic> json) {
    return GroupUsersModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  static List<GroupUsersModel> listFromJson(dynamic json) {
    if (json != null) {
      return json.map<GroupUsersModel>((j) {
        return GroupUsersModel.fromJson(j);
      }).toList();
    }
    return [];
  }
}
