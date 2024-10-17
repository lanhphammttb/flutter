import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nttcs/core/app_export.dart';
import 'package:nttcs/core/theme/custom_text_style.dart';
import 'package:nttcs/core/utils/functions.dart';
import 'package:nttcs/data/models/content.dart';
import 'package:nttcs/presentation/create_schedule/bloc/create_schedule_bloc.dart';
import 'package:nttcs/presentation/device/TooltipShape.dart';
import 'package:nttcs/presentation/news/bloc/news_bloc.dart';
import 'package:nttcs/widgets/custom_bottom_sheet.dart';
import 'package:nttcs/widgets/custom_elevated_button.dart';

import 'custom_time_picker_dialog.dart';

class CustomTimeLineDialog extends StatefulWidget {
  const CustomTimeLineDialog({super.key});

  static void show(BuildContext context) {
    CustomBottomSheet(
      height: 400,
      showDraggableIndicator: false,
      child: const CustomTimeLineDialog(),
    ).show(context);
  }

  @override
  _CustomTimeLineDialogState createState() => _CustomTimeLineDialogState();
}

class _CustomTimeLineDialogState extends State<CustomTimeLineDialog> {
  static String timeStart = '05:00:00';
  static String timeEnd = '05:00:00';
  static int contentType = 3;
  late CreateScheduleBloc createScheduleBloc;
  List<Content> selectedContentId = [];

  @override
  void initState() {
    super.initState();
    createScheduleBloc = context.read<CreateScheduleBloc>();
  }

  void showDialogBottomSheet(BuildContext context) {
    CustomBottomSheet(
      height: 400,
      showDraggableIndicator: false,
      child: const CustomTimeLineDialog(),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionHeader('Khung giờ phát'),
        _buildTextField('Tên khung giờ:', 'Khung giờ từ 05:00:00 đến 05:00:00'),
        _buildTimeRow(context, 'Thời gian bắt đầu:', timeStart, setState: setState),
        _buildTimeRow(context, 'Thời gian kết thúc:', timeEnd, enabled: false),
        BlocBuilder<CreateScheduleBloc, CreateScheduleState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nội dung đã chọn:',
                    style: CustomTextStyles.bodyLargeBlue700,
                  ),
                  GestureDetector(
                    onTap: () {
                      createScheduleBloc.add(const FetchNews3(3));
                      CustomBottomSheet(
                        child: Column(
                          children: [
                            _buildHeaderControl(setState, createScheduleBloc),
                            const SizedBox(height: 8),
                            _buildSectionHeader("Danh sách tin tức"),
                            Expanded(
                              child: BlocBuilder<CreateScheduleBloc, CreateScheduleState>(builder: (context, state) {
                                if (state.newsStatus == NewsStatus.loading) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (state.newsStatus == NewsStatus.failure) {
                                  return Center(child: Text('Failed to load news: ${state.message}'));
                                } else if (state.newsStatus == NewsStatus.success && state.news.isNotEmpty) {
                                  return ListView.builder(
                                    itemCount: state.news.length,
                                    itemBuilder: (context, index) {
                                      final content = state.news[index];
                                      return ListTile(
                                          leading: Icon(Icons.queue_music_outlined, color: appTheme.primary),
                                          title: Text(state.news[index].tieuDe),
                                          subtitle: Text(convertSecondsToHHMMSS(state.news[index].thoiLuong)),
                                          onTap: () => setState(() {
                                                selectedContentId.add(content);
                                              }),
                                          trailing: const Icon(Icons.add, color: Colors.blue));
                                    },
                                  );
                                } else {
                                  return const Center(child: Text(''));
                                }
                              }),
                            ),
                            const SizedBox(height: 8),
                            _buildSectionHeader("Danh sách nội dung phát"),
                            Expanded(
                              child: BlocBuilder<CreateScheduleBloc, CreateScheduleState>(builder: (context, state) {
                                return ListView.builder(
                                  itemCount: selectedContentId.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(selectedContentId[index].tieuDe),
                                      subtitle: Text(convertSecondsToHHMMSS(selectedContentId[index].thoiLuong)),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.remove, color: Colors.red),
                                        onPressed: () => setState(() {
                                          selectedContentId.removeAt(index);  // Cập nhật bằng setState khi xóa
                                        }),
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ).show(context);
                    },
                    child: Row(
                      children: [
                        Text(
                          '+ 0 bản tin',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.add_circle_outline,
                          size: 24,
                          color: appTheme.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const Spacer(),
        _buildConfirmButton(),
      ],
    );
  }

  static Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      width: double.infinity,
      color: appTheme.primary,
      child: Text(
        title.toUpperCase(),
        textAlign: TextAlign.center,
        style: CustomTextStyles.titleOverview,
      ),
    );
  }

  static Widget _buildTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: CustomTextStyles.bodyLargeBlue700,
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
// Đảm bảo không có padding bên trong
                hintText: 'Nhập tên lịch phát...',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: TextStyle(fontSize: 16),
              maxLines: null,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildTimeRow(BuildContext context, String label, String time, {bool enabled = true, StateSetter? setState}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: CustomTextStyles.bodyLargeBlue700,
          ),
          GestureDetector(
            onTap: enabled
                ? () {
                    CustomTimePickerDialog.timePickerDialog(
                      context,
                      2,
                      timeStart: time,
                      selectTimeStart: (String selectedTime) => setState!(() => timeStart = selectedTime),
                    );
                  }
                : null,
            child: Row(
              children: [
                Text(
                  time,
                  style: TextStyle(fontSize: 16, color: enabled ? Colors.black87 : Colors.grey),
                ),
                const SizedBox(width: 8),
                enabled ? Icon(Icons.av_timer_rounded, color: appTheme.primary) : const SizedBox(width: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildConfirmButton() {
    return CustomElevatedButton(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      text: 'Xong',
      leftIcon: const Icon(
        Icons.check,
        color: Colors.white,
      ),
    );
  }

  static Widget _buildHeaderControl(StateSetter? setState, CreateScheduleBloc? createScheduleBloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'title_news'.tr.toUpperCase(),
            style: CustomTextStyles.titleLargeBlack900,
          ), // Thêm khoảng cách giữa chữ và icon
          PopupMenuButton<String>(
            offset: const Offset(60, 50),
            color: Colors.white,
            shape: TooltipShape(),
            icon: Icon(Icons.filter_list_outlined, color: appTheme.primary),
            onSelected: (String value) {
              createScheduleBloc?.add(FetchNews3(value == 'audio' ? 3 : 5));
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'audio',
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    color: contentType == 3 ? appTheme.primaryContainer : null,
                    width: double.infinity, // ensures full width is colored
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0), // Optional padding for better aesthetics
                      child: Text('   Bản tin âm thanh'),
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'live',
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    color: contentType == 5 ? appTheme.primaryContainer : null,
                    width: double.infinity, // ensures full width is colored
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('   Bản tin trực tiếp'),
                    ),
                  ),
                ),
              ];
            },
          ),
          const Spacer(),
// Text(convertSecondsToHHMMSS(state.selectedContent != null ? state.selectedContent!.thoiLuong : '0'), style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
