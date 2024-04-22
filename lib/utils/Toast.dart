import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  static late FToast fToast;

  static void initializeToast(BuildContext context) {
    fToast = FToast();
    fToast.init(context);
  }

  static void showToast(String message,
      {required ToastGravity gravity,
      Color? backgroundColor,
      Color? textColor,
      double? fontSize,
      IconData? icon}) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: backgroundColor ?? Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, color: textColor),
          if (icon != null) const SizedBox(width: 12.0),
          Text(
            message,
            style: TextStyle(
              color: textColor ?? Colors.black,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: gravity,
      toastDuration: const Duration(seconds: 2),
    );
  }
}