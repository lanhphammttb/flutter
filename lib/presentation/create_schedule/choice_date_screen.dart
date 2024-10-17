import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nttcs/core/app_export.dart';
import 'package:nttcs/widgets/custom_date_picker_dialog.dart';
import 'package:nttcs/widgets/custom_elevated_button.dart';
import 'package:nttcs/widgets/custom_time_line_dialog.dart';

import 'bloc/create_schedule_bloc.dart';

class ChoiceDateScreen extends StatefulWidget {
  const ChoiceDateScreen({super.key});

  @override
  State<ChoiceDateScreen> createState() => _ChoiceDateScreenState();
}

class _ChoiceDateScreenState extends State<ChoiceDateScreen> {
  late CreateScheduleBloc createScheduleBloc;

  @override
  void initState() {
    super.initState();
    createScheduleBloc = context.read<CreateScheduleBloc>();
  }

  List<Map<String, dynamic>> timeFrames = [
    {
      "startTime": "05:00:00",
      "endTime": "05:28:40",
      "reports": 4,
    },
    {
      "startTime": "05:00:00",
      "endTime": "05:40:00",
      "reports": 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quay lại'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GestureDetector(
              onTap: () => CustomDatePickerDialog.datePickerDialog(context, (String selectedDate) => createScheduleBloc.add(DateStringChanged(selectedDate))),
              child: BlocBuilder<CreateScheduleBloc, CreateScheduleState>(
                builder: (context, state) => Row(
                  children: [
                    Icon(Icons.edit_calendar, color: appTheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      state.dateString == '' ? DateFormat('dd/MM/yyyy').format(DateTime.now()) : state.dateString,
                      style: CustomTextStyles.bodyLargeBlue700,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GestureDetector(
              onTap: () => CustomTimeLineDialog.show(context),
              child: BlocBuilder<CreateScheduleBloc, CreateScheduleState>(
                builder: (context, state) => Row(
                  children: [
                    Icon(Icons.access_time, color: appTheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      "Khung giờ",
                      style: CustomTextStyles.bodyLargeBlue700,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: timeFrames.length,
              itemBuilder: (context, index) {
                final timeFrame = timeFrames[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.blue,
                        child: ListTile(
                          title: Text(
                            'Khung giờ từ ${timeFrame["startTime"]} đến ${timeFrame["endTime"]}',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.calendar_today, color: Colors.blue),
                                SizedBox(width: 10),
                                Text(
                                  '${timeFrame["startTime"]} - ${timeFrame["endTime"]}',
                                  style: TextStyle(color: Colors.black, fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.article, color: Colors.blue),
                                SizedBox(width: 10),
                                Text(
                                  '${timeFrame["reports"]} bản tin',
                                  style: TextStyle(color: Colors.black, fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: CustomElevatedButton(text: 'Lưu', onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
