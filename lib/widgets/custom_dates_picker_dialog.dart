import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Để sao chép vào clipboard
import 'package:nttcs/core/app_export.dart';
import 'package:nttcs/widgets/custom_bottom_sheet.dart';
import 'package:nttcs/widgets/custom_elevated_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class CustomDatesPickerDialog {
  static void datesPickerDialog(BuildContext context, void Function(List<String>) selectedDates) {
    List<DateTime> _selectedDates = []; // Lưu trữ các ngày đã chọn

    CustomBottomSheet(
      height: 450,
      showDraggableIndicator: false,
      child: Column(
        children: [
          Expanded(
            child: SfDateRangePicker(
              backgroundColor: Colors.white,
              headerStyle: DateRangePickerHeaderStyle(
                textAlign: TextAlign.center,
                backgroundColor: appTheme.primary,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              monthViewSettings: DateRangePickerMonthViewSettings(
                firstDayOfWeek: 1,
                showTrailingAndLeadingDates: false,
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: Colors.blue[200],
                ),
              ),
              selectionColor: appTheme.primary, // Màu của ngày đã chọn
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is List<DateTime>) {
                  _selectedDates = args.value;
                }
              },
              selectionMode: DateRangePickerSelectionMode.multiple, // Chọn nhiều ngày
              initialSelectedDates: [DateTime.now()], // Chọn sẵn ngày hiện tại
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: CustomElevatedButton(
              text: 'Sao chép',
              backgroundColor: Colors.green,
              onPressed: () {
                if (_selectedDates.isNotEmpty) {
                  List<String> formattedDates = _selectedDates
                      .map((date) => DateFormat('dd-MM-yyyy').format(date))
                      .toList();
                  selectedDates(formattedDates);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vui lòng chọn ít nhất một ngày.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    ).show(context);
  }
}
