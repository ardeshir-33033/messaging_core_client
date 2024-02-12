import 'package:flutter/material.dart';

class RadioButtonWidget extends StatelessWidget {
  final bool isSelected;

  const RadioButtonWidget({
    Key? key,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(0xffDADDEB),
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          height: isSelected ? 8:0,
          width: isSelected ? 8:0,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xff2F80ED) : Color(0xffffffff),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
