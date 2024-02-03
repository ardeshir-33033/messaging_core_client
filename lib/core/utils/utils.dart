import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messaging_core/main.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

void postFrameCallback(VoidCallback callback) {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) => callback.call());
}

void dismissKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

Future<void> copyToClipboard(String text) async {
  await Clipboard.setData(
    ClipboardData(
      text: text,
    ),
  );
  Fluttertoast.showToast(
    msg: "Copied",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.grey[600],
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Future<void> launchExternalUrl(
  String url, {
  Function(dynamic)? onError,
}) async {
  try {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.platformDefault,
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true,
      ),
    );
  } catch (e) {
    onError?.call(e);
  }
}
