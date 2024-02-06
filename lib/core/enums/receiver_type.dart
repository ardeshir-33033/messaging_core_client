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
}
