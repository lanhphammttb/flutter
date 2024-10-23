import 'package:flutter/material.dart';
import 'package:nttcs/core/theme/custom_text_style.dart';
import 'package:nttcs/widgets/custom_elevated_button.dart';
import 'package:numberpicker/numberpicker.dart';

class ConfirmDialog {
  static void confirmDialog(BuildContext context, String title, {void Function()? onConfirm}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Xác nhận', style: CustomTextStyles.titleLargeBlack900),
              content: Text(title, style: CustomTextStyles.titleSmallInter),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Hủy", style: (TextStyle(color: Colors.red))),
                ),
                CustomElevatedButton(
                  text: "Xác nhận",
                  width: 100,
                  onPressed: () {
                    onConfirm!();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
