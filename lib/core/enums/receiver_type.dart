enum ReceiverType {
  user,
  group;

  static ReceiverType fromString(String type) {
    switch (type) {
      case "user":
        return ReceiverType.user;
      case "group":
        return ReceiverType.group;
      default:
        return ReceiverType.user;
    }
  }

  @override
  String toString() {
    switch (this) {
      case ReceiverType.user:
        return "user";
      case ReceiverType.group:
        return "group";
      default:
        return "user";
    }
  }
}
