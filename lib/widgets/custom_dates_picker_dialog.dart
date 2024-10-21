import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Để sao chép vào clipboard
import 'package:nttcs/core/app_export.dart';
import 'package:nttcs/core/constants/constants.dart';
import 'package:nttcs/widgets/custom_bottom_sheet.dart';
import 'package:nttcs/widgets/custom_elevated_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class CustomDatesPickerDialog {
  static void datesPickerDialog(BuildContext context, void Function(List<String>) selectedDates, List<String> disabledDateStrings) {
    List<DateTime> _selectedDates = [];
    final today = DateTime.now();
    final List<DateTime> disabledDates = disabledDateStrings.map((date) => DateFormat('dd-MM-yyyy').parse(date)).toList();

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
              selectionColor: appTheme.primary,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is List<DateTime>) {
                  _selectedDates = args.value;
                }
              },
              selectionMode: DateRangePickerSelectionMode.multiple,
              selectableDayPredicate: (DateTime date) {
                bool isDisabledDate = disabledDates.any((disabledDate) => date.year == disabledDate.year && date.month == disabledDate.month && date.day == disabledDate.day);

                // Disable nếu là ngày trong danh sách hoặc trước hôm nay
                return !isDisabledDate && !date.isBefore(DateTime(today.year, today.month, today.day));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: CustomElevatedButton(
              text: 'Sao chép',
              backgroundColor: Colors.green,
              onPressed: () {
                if (_selectedDates.isNotEmpty) {
                  selectedDates(_selectedDates.map((date) => DateFormat(Constants.formatDate).format(date)).toList());
                  Navigator.of(context).pop();
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
