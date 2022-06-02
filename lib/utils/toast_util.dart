import 'package:flutter/material.dart';

class ToastUtil {
  static void toastMessage(BuildContext context, String message,
      [String? actionLabel]) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        action: actionLabel != null
            ? SnackBarAction(
                textColor: Colors.white,
                label: actionLabel,
                onPressed: () {},
              )
            : null));
  }
}
