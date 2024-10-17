import 'package:flutter/material.dart';
import 'package:nttcs/core/app_export.dart';
import 'package:nttcs/widgets/custom_bottom_sheet.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class CustomDatePickerDialog {
  static void datePickerDialog(BuildContext context, void Function(String) selectedDate) {
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
        // Màu của ngày đã chọn
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          if (args.value is DateTime) {
            String formattedDate = DateFormat('dd/MM/yyyy').format(args.value);
            selectedDate(formattedDate);
          }
        },
        selectionMode: DateRangePickerSelectionMode.single,
        initialSelectedDate: DateTime.now(),
      ),
    ).show(context);
  }
}
