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
}
