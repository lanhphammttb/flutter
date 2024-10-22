import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nttcs/core/app_export.dart';
import 'package:nttcs/core/utils/functions.dart';
import 'package:nttcs/data/models/schedule_date.dart';
import 'package:nttcs/presentation/schedule/bloc/schedule_bloc.dart';
import 'package:nttcs/widgets/custom_dates_picker_dialog.dart';
import 'package:nttcs/widgets/custom_elevated_button.dart';

import 'bloc/create_schedule_bloc.dart';

class CreateScheduleScreen extends StatefulWidget {
  const CreateScheduleScreen({super.key});

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  late TextEditingController _nameController;
  late CreateScheduleBloc createScheduleBloc;
  late ScheduleBloc scheduleBloc;

  @override
  void initState() {
    super.initState();
    createScheduleBloc = context.read<CreateScheduleBloc>();
    scheduleBloc = context.read<ScheduleBloc>();
    _nameController = TextEditingController(text: createScheduleBloc.state.scheduleName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Tạo lịch phát',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            createScheduleBloc.add(ResetCreateSchedule());
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[300],
            height: 1.0,
          ),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CreateScheduleBloc, CreateScheduleState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if (state.status == CreateScheduleStatus.success && state.syncStatus != SyncStatus.loading) {
                Fluttertoast.showToast(
                    msg: 'Lưu lịch phát thành công',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);

                context.read<ScheduleBloc>().add(const FetchSchedule(0));
                Future.delayed(const Duration(seconds: 0), () {
                  Navigator.pop(context);
                  createScheduleBloc.add(ResetCreateSchedule());
                });
              }
            },
          ),
          BlocListener<CreateScheduleBloc, CreateScheduleState>(
            listenWhen: (previous, current) => previous.delStatus != current.delStatus,
            listener: (context, state) {
              if (state.delStatus == DelStatus.success) {
                Fluttertoast.showToast(
                    msg: 'Hủy lịch phát thành công',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);

                context.read<ScheduleBloc>().add(const FetchSchedule(0));
                Future.delayed(const Duration(seconds: 0), () {
                  Navigator.pop(context);
                  createScheduleBloc.add(ResetCreateSchedule());
                });
              }
            },
          ),
          BlocListener<CreateScheduleBloc, CreateScheduleState>(
            listenWhen: (previous, current) => previous.syncStatus != current.syncStatus,
            listener: (context, state) {
              if (state.syncStatus == SyncStatus.loading) {
                Fluttertoast.showToast(
                    msg: 'Đồng bộ lịch phát...',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.orange,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else if (state.syncStatus == SyncStatus.success) {
                Fluttertoast.showToast(
                    msg: 'Phát lịch phát thành công',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);

                context.read<ScheduleBloc>().add(const FetchSchedule(0));
                Future.delayed(const Duration(seconds: 0), () {
                  Navigator.pop(context);
                  createScheduleBloc.add(ResetCreateSchedule());
                });
              }
            },
          ),
        ],
        child: BlocBuilder<CreateScheduleBloc, CreateScheduleState>(
          builder: (context, state) {
            if (state.status == CreateScheduleStatus.failure || state.delStatus == DelStatus.failure || state.syncStatus == SyncStatus.failure) {
              return Center(child: Text('Có lỗi xảy ra: ${state.message}'));
            } else {
              return _buildCreateScheduleForm(context, state);
            }
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn giữa các nút
            children: [
              Expanded(
                child: CustomElevatedButton(
                  text: 'Hủy lịch',
                  backgroundColor: Colors.red,
                  onPressed: () => createScheduleBloc.add(Del2Schedule()),
                ),
              ),
              const SizedBox(width: 8), // Khoảng cách giữa các nút
              Expanded(
                child: CustomElevatedButton(
                  text: 'Lưu & Phát',
                  backgroundColor: Colors.green,
                  onPressed: () => createScheduleBloc.add(Sync2Schedule(_nameController.text)),
                ),
              ),
              const SizedBox(width: 8), // Khoảng cách giữa các nút
              Expanded(
                child: CustomElevatedButton(
                  text: 'Lưu nháp',
                  backgroundColor: appTheme.primary,
                  onPressed: () => createScheduleBloc.add(CreateSchedule(_nameController.text)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateScheduleForm(BuildContext context, CreateScheduleState state) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black12, // Màu của viền
                width: 1.0, // Độ dày của viền
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Tên lịch phát:',
                    style: CustomTextStyles.titleLargeBlue800,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        // Đảm bảo không có padding bên trong
                        hintText: 'Nhập tên lịch phát...',
                      ),
                      style: const TextStyle(fontSize: 16),
                      maxLines: null,
                    ),
                  ),
                  if (_nameController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.black),
                      onPressed: () {
                        _nameController.clear();
                        setState(() {});
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
        _buildOptionTile(context, title: 'Địa điểm phát', subtitle: 'Địa điểm đã chọn: ${state.locationName}', onTap: () => Navigator.pushNamed(context, '/choice-place')),
        _buildOptionTile(context, title: 'Thiết bị phát', subtitle: 'Đã chọn: ${state.selectedDeviceIds.length}', onTap: () {
          createScheduleBloc.add(FetchDevices());
          Navigator.pushNamed(context, '/choice-device');
        }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black12, // Màu của viền
                width: 1.0, // Độ dày của viền
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text('Ngày phát', style: CustomTextStyles.titleLargeBlue800),
              subtitle: Text('${state.scheduleDates.length} ngày', style: const TextStyle(fontSize: 16)),
              trailing: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: appTheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pushNamed(context, '/choice-date'),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: state.scheduleDates.length,
          itemBuilder: (context, index) {
            final date = state.scheduleDates[index];
            return Slidable(
              key: ValueKey(date),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  _buildSlidableAction('Xóa', Icons.delete, Colors.red, () => createScheduleBloc.add(RemoveScheduleDate(index))),
                  _buildSlidableAction(
                      'Sao chép',
                      Icons.copy,
                      Colors.orange,
                      () =>
                          CustomDatesPickerDialog.datesPickerDialog(context, (selectedDate) => createScheduleBloc.add(CopyDate(date, selectedDate)), state.scheduleDates.map((e) => e.date).toList())),
                  _buildSlidableAction('Sửa', Icons.edit, Colors.blue, () {
                    // Handle edit action
                  }),
                ],
              ),
              child: _buildDates(date),
            );
          },
        ),
      ],
    ));
  }

  Widget _buildSlidableAction(String label, IconData icon, Color color, VoidCallback onPressed) {
    return SlidableAction(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      onPressed: (context) => onPressed(),
      backgroundColor: color,
      foregroundColor: Colors.white,
      icon: icon,
      label: label,
    );
  }

  Widget _buildDates(ScheduleDate scheduleDate) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.0),
        border: Border.all(
          color: Colors.black12, // Màu của viền
          width: 1.0, // Độ dày của viền
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(convertDateFormat(scheduleDate.date), style: CustomTextStyles.titleLargeBlack900),
          // Wrap the ListView in a Container to provide a specific height
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: scheduleDate.schedulePlaylistTimes.map((timeFrame) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                child: Text(
                  '${timeFrame.start} - ${timeFrame.end}    ${timeFrame.playlists.length} bản tin',
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, {required String title, required String subtitle, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black12, // Màu của viền
            width: 1.0, // Độ dày của viền
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(title, style: CustomTextStyles.titleLargeBlue800),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
          onTap: onTap,
        ),
      ),
    );
  }
}
