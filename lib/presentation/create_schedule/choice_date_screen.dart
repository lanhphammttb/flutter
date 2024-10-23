import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nttcs/core/app_export.dart';
import 'package:nttcs/widgets/confirm_dialog.dart';
import 'package:nttcs/widgets/custom_date_picker_dialog.dart';
import 'package:nttcs/widgets/custom_elevated_button.dart';
import 'package:nttcs/presentation/create_schedule/time_line_dialog.dart';

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
              onTap: () => CustomDatePickerDialog.datePickerDialog(context, (String selectedDate) => createScheduleBloc.add(DateStringChanged(selectedDate)),
                  createScheduleBloc.state.scheduleDates.map((e) => e.date).toList(), createScheduleBloc.state.dateString),
              child: BlocBuilder<CreateScheduleBloc, CreateScheduleState>(
                builder: (context, state) => Row(
                  children: [
                    Icon(Icons.edit_calendar, color: appTheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      state.dateString == '' ? DateFormat('dd-MM-yyyy').format(DateTime.now()) : state.dateString,
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
              onTap: () => TimeLineDialog.show(context),
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
            child: BlocBuilder<CreateScheduleBloc, CreateScheduleState>(
              builder: (context, state) {
                // Lấy dữ liệu từ state
                return ListView.builder(
                  itemCount: state.schedulePlaylistTimes.length,
                  itemBuilder: (context, index) {
                    final timeFrame = state.schedulePlaylistTimes[index];
                    return GestureDetector(
                      onTap: () {
                        TimeLineDialog.show(context, timeFrame: timeFrame, timeLineIndex: index);
                        createScheduleBloc.add(SelectNews(selectedNews: timeFrame.playlists));
                      },
                      child: Card(
                        color: appTheme.white,
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: appTheme.primary, // Đặt màu ở đây thay vì thuộc tính color.
                                borderRadius: BorderRadius.circular(8.0), // Bo góc cho container.
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                title: Text(
                                  timeFrame.name,
                                  style: CustomTextStyles.titleOverview,
                                ),
                                trailing: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () => ConfirmDialog.confirmDialog(context, 'Bạn có chắc chắn muốn xóa?',
                                      onConfirm: () => createScheduleBloc.add(RemoveSchedulePlaylistTimes(index))),
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
                                      Icon(Icons.calendar_month_outlined, color: appTheme.primary),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${timeFrame.start} - ${timeFrame.end}',
                                        style: CustomTextStyles.titleSmallInter,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.article_outlined, color: appTheme.primary),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${timeFrame.playlists.length} bản tin',
                                        style: CustomTextStyles.titleSmallInter,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    ;
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: CustomElevatedButton(
                text: 'Lưu',
                onPressed: () {
                  createScheduleBloc.add(const AddScheduleDate());
                  Navigator.pop(context);
                }),
          ),
        ],
      ),
    );
  }
}
