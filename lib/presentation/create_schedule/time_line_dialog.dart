import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nttcs/core/app_export.dart';
import 'package:nttcs/core/utils/functions.dart';
import 'package:nttcs/data/models/content.dart';
import 'package:nttcs/data/models/schedule_date.dart';
import 'package:nttcs/presentation/create_schedule/bloc/create_schedule_bloc.dart';
import 'package:nttcs/presentation/device/TooltipShape.dart';
import 'package:nttcs/presentation/news/bloc/news_bloc.dart';
import 'package:nttcs/widgets/custom_bottom_sheet.dart';
import 'package:nttcs/widgets/custom_elevated_button.dart';

import '../../widgets/custom_time_picker_dialog.dart';

class TimeLineDialog extends StatefulWidget {
  final String? timeStart;
  final String? timeEnd;
  final String? name;
  final int? timeLineIndex;

  const TimeLineDialog({super.key, this.timeStart, this.timeEnd, this.name, this.timeLineIndex});

  static void show(
    BuildContext context, {
    SchedulePlaylistTime? timeFrame,
    int? timeLineIndex,
  }) {
    CustomBottomSheet(
      height: 420,
      showDraggableIndicator: false,
      child: TimeLineDialog(
        timeStart: timeFrame?.start ?? '05:00:00',
        timeEnd: timeFrame?.end ?? '05:00:00',
        name: timeFrame?.name ?? 'Khung giờ từ 05:00:00 đến 05:00:00',
        timeLineIndex: timeLineIndex ?? -1,
      ),
    ).show(context);
  }

  @override
  _TimeLineDialogState createState() => _TimeLineDialogState();
}

class _TimeLineDialogState extends State<TimeLineDialog> {
  late String timeStart;
  late String timeEnd;
  late int timeLineIndex;
  TextEditingController nameController = TextEditingController();
  bool autoRenderText = true;
  late CreateScheduleBloc createScheduleBloc;

  @override
  void initState() {
    super.initState();
    createScheduleBloc = context.read<CreateScheduleBloc>();

    timeStart = widget.timeStart ?? '05:00:00';
    timeEnd = widget.timeEnd ?? '05:00:00';
    timeLineIndex = widget.timeLineIndex ?? -1;

    nameController.text = widget.name ?? 'Khung giờ từ 05:00:00 đến 05:00:00';
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
                LengthLimitingTextInputFormatter(60),
              ],
              onChanged: (value) => setState(() {
                autoRenderText = false;
                nameController.text = value;
              }),
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
          timeLineIndex,
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
                                        if (content.loaiBanTin == '5') {
                                          CustomTimePickerDialog.timePickerDialog(context, 1, addSelectedNews: (String time) {
                                            setTimeEnd(() => createScheduleBloc.add(SelectNews(content: content, duration: time)));
                                          });
                                        } else {
                                          setTimeEnd(() => createScheduleBloc.add(SelectNews(content: content)));
                                        }
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
                              title: Text(state.selectedNews[index].tieuDe ?? ''),
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

  Future<void> setTimeEnd([Function()? callback]) async {
    await callback?.call();
    int totalDuration = 0;
    if (createScheduleBloc.state.delPlaylistStatus != DelPlaylistStatus.loading) {
      if (createScheduleBloc.state.selectedNews.isEmpty) {
        setState(() {
          timeEnd = timeStart;
          if (autoRenderText) {
            nameController.text = 'Khung giờ từ $timeStart đến $timeEnd';
          }
        });
      } else {
        for (var news in createScheduleBloc.state.selectedNews) {
          totalDuration += int.parse(news.duration ?? news.thoiLuong);
        }
        final List<String> timeStartList = timeStart.split(':');
        final int hour = int.parse(timeStartList[0]);
        final int minute = int.parse(timeStartList[1]);
        final int second = int.parse(timeStartList[2]);

        setState(() {
          timeEnd = convertSecondsToHHMMSS((hour * 3600 + minute * 60 + second + totalDuration).toString());
          if (autoRenderText) {
            nameController.text = 'Khung giờ từ $timeStart đến $timeEnd';
          }
        });
      }
    }
  }
}
