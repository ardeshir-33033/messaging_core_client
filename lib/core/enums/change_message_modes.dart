enum ChangeMessageEnum {
  edit,
  delete;

  static ChangeMessageEnum fromString(String name) {
    switch (name) {
      case "edit":
        return edit;
      case "delete":
        return delete;
      default:
        return edit;
    }
  }

  @override
  String toString() {
    switch (this) {
      case edit:
        return "edit";
      case delete:
        return "delete";
      default:
        return "edit";
    }
  }
}
