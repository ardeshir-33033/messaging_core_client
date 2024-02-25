class SelectableModel<T> {
  late T model;
  bool isSelected = false;

  SelectableModel(this.model, this.isSelected);

  void toggleSelection() {
    isSelected = !isSelected;
  }
}
