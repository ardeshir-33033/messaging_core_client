import 'package:flutter/material.dart';

void postFrameCallback(VoidCallback callback) {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) => callback.call());
}
