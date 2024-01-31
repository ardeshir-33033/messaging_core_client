import 'package:messaging_core/app/theme/app_images.dart';
import 'package:messaging_core/core/utils/extensions.dart';

class ContactProfile {
  String userId;
  String? firstName;
  String? lastName;
  String? bio;
  String? username;
  String? phone;
  List<String> avatarUrl = [];

  String? characterName;

  bool isVerified = false;

  ContactProfile(
      {required this.userId,
      this.firstName,
      this.lastName,
      this.bio,
      this.username,
      this.phone,
      this.isVerified = false,
      this.characterName});

  ContactProfile.fromJson(
    Map<String, dynamic> json,
  ) : userId = json['userId']! {
    firstName = json['firstName'];
    lastName = json['lastName'];
    bio = json['bio'];
    username = json['username'];
    characterName = json['characterName'] ?? "character-not-set";
    isVerified = json['isVerified'];
    phone = json['phone'];
    avatarUrl = (json['avatarUrl'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
  }

  factory ContactProfile.clone(ContactProfile user) => ContactProfile(
        userId: user.userId,
        username: user.username,
        characterName: user.characterName,
        bio: user.bio,
        firstName: user.firstName,
        isVerified: user.isVerified,
        lastName: user.lastName,
        phone: user.phone,
      )..setAvatarUrls(user.avatarUrl);

  // factory ContactProfile.fromUserTable(UserTableData user) => ContactProfile(
  //       userId: user.userId,
  //       username: user.username,
  //       characterName: user.characterName,
  //       bio: user.bio,
  //       firstName: user.firstName,
  //       isVerified: user.isVerified,
  //       lastName: user.lastName,
  //       phone: user.phone,
  //       userTypeEnum: user.userTypeEnum,
  //     )..setAvatarUrls(user.avatarUrl ?? []);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['bio'] = bio;
    data['username'] = username;
    data['phone'] = phone;
    return data;
  }

  // UserTableData toUserTableData({UserTypeEnum? userType}) => UserTableData(
  //       phone: phone,
  //       userId: userId,
  //       lastName: lastName,
  //       isVerified: isVerified,
  //       firstName: firstName,
  //       bio: bio,
  //       characterName: characterName,
  //       username: username,
  //       avatarUrl: avatarUrl,
  //       userTypeEnum: userType ?? userTypeEnum,
  //     );

  static const pogUserIdMaxLength = 12;

  void setAvatarUrls(List<String> avatarUrl) {
    this.avatarUrl = avatarUrl.map((e) => e).toList();
  }

  void setImageUrl(String url) {
    avatarUrl.add(url);
  }

  bool get isPogUser {
    return userId.length < pogUserIdMaxLength;
  }

  String get displayName {
    if (isPogUser) {
      if (firstName == null && lastName == null && isPogUser) {
        return username ?? "";
      }
      return getFullName() ?? "NA";
    }

    if (firstName == null && lastName == null && characterName == null) {
      return userId.midEllipsis();
    } else if (firstName == null && lastName == null && characterName != null) {
      return characterName!;
    }

    return getFullName() ?? "NA";
  }

  String? getFullName() {
    if (firstName == null && lastName == null) {
      return null;
    } else {
      return firstName?.concat(lastName != null ? " $lastName" : "");
    }
  }

  String get image {
    return avatarUrl.lastOrNull() ?? '${AppImages.basePath}unknown.png';
  }

  String get briefUserId {
    return userId.toHex().midEllipsis();
  }
}
