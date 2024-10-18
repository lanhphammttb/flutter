import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nttcs/core/app_export.dart';
import 'package:nttcs/data/models/schedule_date.dart';
import 'package:nttcs/widgets/custom_dates_picker_dialog.dart';
import 'package:nttcs/widgets/custom_elevated_button.dart';
import 'bloc/create_schedule_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CreateScheduleScreen extends StatefulWidget {
  const CreateScheduleScreen({super.key});

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  late TextEditingController _nameController;
  late CreateScheduleBloc createScheduleBloc;

  @override
  void initState() {
    super.initState();
    createScheduleBloc = context.read<CreateScheduleBloc>();
    _nameController = TextEditingController(
      text: 'Thị trấn Bến Lức - ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
    );
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
      body: BlocBuilder<CreateScheduleBloc, CreateScheduleState>(
        builder: (context, state) {
          if (state.status == CreateScheduleStatus.initial) {
            // Chỉ gọi sự kiện khi cần thiết, tránh gọi lại nhiều lần khi quay lại từ các màn hình khác
            if (!context.read<CreateScheduleBloc>().isInitialized) {
              context.read<CreateScheduleBloc>().add(InitializeCreateScheduleEvent());
            }
          }

          // if (state.status == CreateScheduleStatus.loading) {
          //   return const Center(child: CircularProgressIndicator());
          // } else if (state.status == CreateScheduleStatus.failure) {
          //   return const Center(child: Text('Lịch phát đã được lưu.'));
          // } else if (state.status == CreateScheduleStatus.success) {
          //   return _buildCreateScheduleForm(context, state);
          // }
          return _buildCreateScheduleForm(context, state);
          // return const Center(child: Text('Đang tải...'));
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: SizedBox(
          width: double.infinity,
          child: CustomElevatedButton(
            text: 'Lưu',
            backgroundColor: appTheme.primary,
            onPressed: () {
              context.read<CreateScheduleBloc>().add(CreateSchedule());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCreateScheduleForm(BuildContext context, CreateScheduleState state) {
    return SingleChildScrollView(
        child: Column(
      children: [
        // Ô nhập tên lịch phát với nút xóa khi có giá trị
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
        // Địa điểm phát
        _buildOptionTile(context, title: 'Địa điểm phát', subtitle: 'Địa điểm đã chọn: ${state.location}', onTap: () {
          createScheduleBloc.add(FetchLocations()); // Gọi API chỉ khi chưa có dữ liệu
          Navigator.pushNamed(context, '/choice-place');
        }),
        // Thiết bị phát
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
              subtitle: Text('${state.selectedDates.length} ngày', style: const TextStyle(fontSize: 16)),
              trailing: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: appTheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  onPressed: () {
                    context.read<CreateScheduleBloc>().add(AddDateEvent(DateTime.now()));
                    Navigator.pushNamed(context, '/choice-date');
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Danh sách ngày phát
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
                      () => CustomDatesPickerDialog.datesPickerDialog(
                          context,
                          (selectedDate) => {
                                // createScheduleBloc.add(AddDateEvent(selectedDate))
                              })),
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
          Text(scheduleDate.date, style: CustomTextStyles.titleLargeBlack900),
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
