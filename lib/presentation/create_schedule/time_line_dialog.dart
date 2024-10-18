import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nttcs/core/app_export.dart';
import 'package:nttcs/core/utils/functions.dart';
import 'package:nttcs/presentation/create_schedule/bloc/create_schedule_bloc.dart';
import 'package:nttcs/presentation/device/TooltipShape.dart';
import 'package:nttcs/presentation/news/bloc/news_bloc.dart';
import 'package:nttcs/widgets/custom_bottom_sheet.dart';
import 'package:nttcs/widgets/custom_elevated_button.dart';

import '../../widgets/custom_time_picker_dialog.dart';

class TimeLineDialog extends StatefulWidget {
  const TimeLineDialog({super.key});

  static void show(BuildContext context) {
    CustomBottomSheet(
      height: 420,
      showDraggableIndicator: false,
      child: const TimeLineDialog(),
    ).show(context);
  }

  @override
  _TimeLineDialogState createState() => _TimeLineDialogState();
}

class _TimeLineDialogState extends State<TimeLineDialog> {
  String timeStart = '05:00:00';
  String timeEnd = '05:00:00';
  TextEditingController nameController = TextEditingController(text: 'Khung giờ từ 05:00:00 đến 05:00:00');
  late CreateScheduleBloc createScheduleBloc;

  @override
  void initState() {
    super.initState();
    createScheduleBloc = context.read<CreateScheduleBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionHeader('Khung giờ phát'),
        _buildTextField('Tên khung giờ:'),
        _buildTimeRow(context, 'Thời gian bắt đầu:', timeStart, setState: setState),
        _buildTimeRow(context, 'Thời gian kết thúc:', timeEnd, enabled: false),
        _buildSelectContent(),
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

  Widget _buildTextField(String label) {
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
          Expanded(
            child: TextField(
              controller: nameController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(60), // Giới hạn 50 ký tự
              ],
              onChanged: (value) => setState(() => nameController.text = value),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: 'Nhập tên lịch phát...',
                hintStyle: const TextStyle(color: Colors.grey),
                errorText: nameController.text.trim().length > 50 ? 'Tên không được quá 50 ký tự' : null,
              ),
              style: const TextStyle(fontSize: 16),
              maxLines: null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(BuildContext context, String label, String time, {bool enabled = true, StateSetter? setState}) {
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
                      selectTimeStart: (String selectedTime) => setState!(() {
                        timeStart = selectedTime;
                        setTimeEnd();
                      }),
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
                enabled ? const Icon(Icons.av_timer_rounded, color: Colors.blue) : const SizedBox(width: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return CustomElevatedButton(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      text: 'Xong',
      onPressed: () {
        createScheduleBloc.add(AddTimeLine(
          nameController.text,
          timeStart,
          timeEnd,
        ));
        Navigator.pop(context);
      },
      leftIcon: const Icon(
        Icons.check,
        color: Colors.white,
      ),
    );
  }

  Widget _buildHeaderControl(StateSetter? setState, CreateScheduleBloc? createScheduleBloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: BlocBuilder<CreateScheduleBloc, CreateScheduleState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'title_news'.tr.toUpperCase(),
                style: CustomTextStyles.titleLargeBlack900,
              ),
              PopupMenuButton<String>(
                offset: const Offset(60, 50),
                color: Colors.white,
                shape: TooltipShape(),
                icon: Icon(Icons.filter_list_outlined, color: appTheme.primary),
                onSelected: (String value) {
                  if (createScheduleBloc != null) {
                    createScheduleBloc.add(FetchNews3(value == 'audio' ? 3 : 5));
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'audio',
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        color: state.contentType == 3 ? appTheme.primaryContainer : null,
                        width: double.infinity,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('   Bản tin âm thanh'),
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'live',
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        color: state.contentType == 5 ? appTheme.primaryContainer : null,
                        width: double.infinity,
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
              // Uncomment or adjust the text below as per your requirement
              // Text(
              //   convertSecondsToHHMMSS(state.selectedContent != null ? state.selectedContent!.thoiLuong : '0'),
              //   style: const TextStyle(color: Colors.grey),
              // ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSelectContent() {
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
                                  contentPadding: const EdgeInsets.fromLTRB(16, 0, 0, 4),
                                  leading: Icon(Icons.queue_music_outlined, color: appTheme.primary),
                                  title: Text(state.news[index].tieuDe),
                                  subtitle: Text(convertSecondsToHHMMSS(state.news[index].thoiLuong)),
                                  trailing: IconButton(
                                      icon: const Icon(Icons.add, color: Colors.blue),
                                      onPressed: () {
                                        createScheduleBloc.add(SelectNews(content));
                                        setTimeEnd();
                                      }));
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
                          itemCount: state.selectedNews.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding: const EdgeInsets.fromLTRB(16, 0, 0, 4),
                              leading: Icon(Icons.queue_music_outlined, color: appTheme.primary),
                              title: Text(state.selectedNews[index].tieuDe),
                              subtitle: Text(convertSecondsToHHMMSS(state.selectedNews[index].thoiLuong)),
                              trailing: IconButton(
                                  icon: const Icon(Icons.remove, color: Colors.red),
                                  onPressed: () {
                                    createScheduleBloc.add(RemovePlaylist(index));
                                    setTimeEnd();
                                  }),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ).show(context);
            },
            child: BlocBuilder<CreateScheduleBloc, CreateScheduleState>(builder: (context, state) {
              return Row(
                children: [
                  Text(
                    '+ ${state.selectedNews.length} bản tin',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.add_circle_outline,
                    size: 24,
                    color: Colors.blue,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void setTimeEnd() {
    int totalDuration = 0;
    for (var news in createScheduleBloc.state.selectedNews) {
      totalDuration += int.parse(news.thoiLuong);
    }
    final List<String> timeStartList = timeStart.split(':');
    final int hour = int.parse(timeStartList[0]);
    final int minute = int.parse(timeStartList[1]);
    final int second = int.parse(timeStartList[2]);

    setState(() {
      timeEnd = convertSecondsToHHMMSS((hour * 3600 + minute * 60 + second + totalDuration).toString());
    });
  }
}
