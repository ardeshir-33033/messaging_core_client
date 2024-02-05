enum UserRoles {
  admin,
  user;

  static UserRoles fromString(String? type) {
    type = type?.toLowerCase();
    switch (type) {
      case "admin":
        return UserRoles.admin;
      case "user":
        return UserRoles.user;
      default:
        return UserRoles.user;
    }
  }

  static List<UserRoles> fromList(List<dynamic> roles) {
    List<UserRoles> result = [];

    roles.forEach((element) {
      result.add(UserRoles.fromString(element));
    });

    return result;
  }
}
