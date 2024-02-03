enum EmailStatus {
  active,
  inactive;

  static EmailStatus fromString(String? type) {
    type = type?.toLowerCase();
    switch (type) {
      case "active":
        return EmailStatus.active;
      case "inactive":
        return EmailStatus.inactive;
      default:
        return EmailStatus.active;
    }
  }
}
