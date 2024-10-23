import 'package:flutter/material.dart';
import 'package:nttcs/core/app_export.dart';
import 'package:nttcs/core/constants/constants.dart';
import 'package:nttcs/widgets/custom_bottom_sheet.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class CustomDatePickerDialog {
  static void datePickerDialog(BuildContext context, void Function(String) selectedDate, List<String> disabledDateStrings, String? initialDateString) {
    final today = DateTime.now();
    DateTime? initialDate;

    if (initialDateString != null && initialDateString.isNotEmpty) {
      try {
        initialDate = DateFormat(Constants.formatDate2).parse(initialDateString);
      } catch (e) {
        initialDate = null;
      }
    }
    final List<DateTime> disabledDates =
        disabledDateStrings.map((date) => DateFormat(Constants.formatDate2).parse(date)).where((disabledDate) => disabledDate != initialDate).toList();
    CustomBottomSheet(
      height: 400,
      showDraggableIndicator: false,
      child: SfDateRangePicker(
        backgroundColor: Colors.white,
        headerStyle: DateRangePickerHeaderStyle(
          textAlign: TextAlign.center,
          backgroundColor: appTheme.primary, // Căn giữa tiêu đề tháng
          textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
          if (args.value is DateTime) {
            String formattedDate = DateFormat(Constants.formatDate2).format(args.value);
            selectedDate(formattedDate);
          }
        },
        selectionMode: DateRangePickerSelectionMode.single,
        initialSelectedDate: initialDate ?? today,
        selectableDayPredicate: (DateTime date) {
          bool isDisabledDate =
              disabledDates.any((disabledDate) => date.year == disabledDate.year && date.month == disabledDate.month && date.day == disabledDate.day);

          return !isDisabledDate && !date.isBefore(DateTime(today.year, today.month, today.day));
        },
      ),
    ).show(context);
  }
}
