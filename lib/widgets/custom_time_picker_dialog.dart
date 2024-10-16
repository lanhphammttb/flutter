import 'package:flutter/material.dart';
import 'package:nttcs/core/theme/custom_text_style.dart';
import 'package:nttcs/widgets/custom_elevated_button.dart';
import 'package:numberpicker/numberpicker.dart';

class CustomTimePickerDialog {
  static void timePickerDialog(BuildContext context, void Function(String) addSelectedNews) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedHour = 0;
        int selectedMinute = 0;
        int selectedSecond = 0;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("CHỌN THỜI LƯỢNG PHÁT", style: CustomTextStyles.titleLargeBlack900),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            NumberPicker(
                              minValue: 0,
                              maxValue: 23,
                              value: selectedHour,
                              onChanged: (value) {
                                setState(() {
                                  selectedHour = value;
                                });
                              },
                              infiniteLoop: true,
                              textMapper: (numberText) {
                                if (int.parse(numberText) == selectedHour) {
                                  return '$numberText giờ';
                                }
                                return numberText;
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            NumberPicker(
                              minValue: 0,
                              maxValue: 59,
                              value: selectedMinute,
                              onChanged: (value) {
                                setState(() {
                                  selectedMinute = value;
                                });
                              },
                              infiniteLoop: true,
                              textMapper: (numberText) {
                                if (int.parse(numberText) == selectedMinute) {
                                  return '$numberText phút';
                                }
                                return numberText;
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            NumberPicker(
                              minValue: 0,
                              maxValue: 59,
                              value: selectedSecond,
                              onChanged: (value) {
                                setState(() {
                                  selectedSecond = value;
                                });
                              },
                              infiniteLoop: true,
                              textMapper: (numberText) {
                                if (int.parse(numberText) == selectedSecond) {
                                  return '$numberText giây';
                                }
                                return numberText;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
                    if (selectedHour == 0 && selectedMinute == 0 && selectedSecond == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Vui lòng chọn thời lượng lớn hơn 0."),
                      ));
                    } else {
                      if (addSelectedNews != null) {
                        addSelectedNews((selectedHour * 3600 + selectedMinute * 60 + selectedSecond).toString());
                      }
                      Navigator.of(context).pop();
                    }
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

// NumberPicker widget can be found here: https://pub.dev/packages/numberpicker
// Remember to import and use it.
