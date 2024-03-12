import 'package:flutter/material.dart';
import 'package:messaging_core/app/component/TextFieldWidget.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/core/utils/debouncer/function_debouncer.dart';

class SearchInputWidget extends StatefulWidget {
  final Function(String query) onSearch;
  final String hintText;
  final TextEditingController? textController;
  final FocusNode? focusNode;
  final int? debounceDuration;

  const SearchInputWidget({
    Key? key,
    required this.onSearch,
    required this.hintText,
    this.textController,
    this.focusNode,
    this.debounceDuration,
  }) : super(key: key);

  @override
  State<SearchInputWidget> createState() => _SearchInputWidgetState();
}

class _SearchInputWidgetState extends State<SearchInputWidget> {
  late FunctionDeBouncer _searchDispatcher;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _searchDispatcher = FunctionDeBouncer(widget.debounceDuration);
    _textController = widget.textController ?? TextEditingController();
  }

  @override
  void dispose() {
    _searchDispatcher.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      controller: _textController,
      hintText: widget.hintText,
      textInputType: TextInputType.name,
      focusNode: widget.focusNode,
      prefixIcon: const IconWidget(
        icon: Icons.search,
        iconColor: Color(0xff4E5670),
        size: 16,
        height: 16,
      ),
      onChanged: (value) {
        _onSearchFieldTextChanged(value);
      },
    );
  }

  void _onSearchFieldTextChanged(value) {
    _searchDispatcher.add(_search);
  }

  void _search() {
    widget.onSearch(_textController.text);
  }
}
