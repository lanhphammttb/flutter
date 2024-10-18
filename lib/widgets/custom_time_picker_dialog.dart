import 'package:flutter/material.dart';
import 'package:nttcs/core/theme/custom_text_style.dart';
import 'package:nttcs/widgets/custom_elevated_button.dart';
import 'package:numberpicker/numberpicker.dart';

class CustomTimePickerDialog {
  static void timePickerDialog(BuildContext context, int type, {void Function(String)? addSelectedNews, void Function(String)? selectTimeStart, String? timeStart}) {
    //type 1 là chọn thời lượng phát, 2 là chọn thời gian bắt đầu
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime now = DateTime.now();
        // nếu timeStart tồn tại thì gán mặc định now ban đầu là giá trị của timeStart
        if (timeStart != null) {
          List<String> time = timeStart.split(':');
          now = DateTime(now.year, now.month, now.day, int.parse(time[0]), int.parse(time[1]), int.parse(time[2]));
        }
        int selectedHour = type == 2 ? now.hour : 0;
        int selectedMinute = type == 2 ? now.minute : 0;
        int selectedSecond = type == 2 ? now.second : 0;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(type == 1 ? 'CHỌN THỜI LƯỢNG PHÁT' : 'CHỌN THỜI GIAN BẮT ĐẦU', style: CustomTextStyles.titleLargeBlack900),
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
                                if (int.parse(numberText) == selectedHour && type == 1) {
                                  return '$numberText giờ';
                                }
                                return type == 2 ? numberText.padLeft(2, '0') : numberText;
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
                                if (int.parse(numberText) == selectedMinute && type == 1) {
                                  return '$numberText phút';
                                }
                                return type == 2 ? numberText.padLeft(2, '0') : numberText;
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
                                if (int.parse(numberText) == selectedSecond && type == 1) {
                                  return '$numberText giây';
                                }
                                return type == 2 ? numberText.padLeft(2, '0') : numberText;
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

                      if (selectTimeStart != null) {
                        selectTimeStart('${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}:${selectedSecond.toString().padLeft(2, '0')}');
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