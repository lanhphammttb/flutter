import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'bloc/create_schedule_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CreateScheduleScreen extends StatefulWidget {
  const CreateScheduleScreen({Key? key}) : super(key: key);

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text:
          'Thị trấn Bến Lức - ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
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
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
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
          if (state is CreateScheduleInitial) {
            context
                .read<CreateScheduleBloc>()
                .add(InitializeCreateScheduleEvent());
          }
          if (state is CreateScheduleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CreateScheduleLoaded) {
            return const Center(child: Text('Lịch phát đã được lưu.'));
          } else if (state is CreateScheduleUpdated) {
            return _buildCreateScheduleForm(context, state);
          }
          return const Center(child: Text('Đang tải...'));
        },
      ),
    );
  }

  Widget _buildCreateScheduleForm(
      BuildContext context, CreateScheduleUpdated state) {
    return Column(
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
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        // Đảm bảo không có padding bên trong
                        hintText: 'Nhập tên lịch phát...',
                      ),
                      style: const TextStyle(fontSize: 16),
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
        _buildOptionTile(
          context,
          title: 'Địa điểm phát',
          subtitle: 'Địa điểm đã chọn: ${state.location}',
          onTap: () => Navigator.pushNamed(context, '/choice-place'),
        ),
        // Thiết bị phát
        _buildOptionTile(
          context,
          title: 'Thiết bị phát',
          subtitle: 'Đã chọn: ${state.device}',
          onTap: () =>
              context.read<CreateScheduleBloc>().add(SelectDeviceEvent([])),
        ),
        // Ngày phát
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: const Text('Ngày phát',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue)),
              subtitle: Text('${state.selectedDates.length} ngày',
                  style: const TextStyle(fontSize: 16)),
              trailing: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  onPressed: () {
                    context
                        .read<CreateScheduleBloc>()
                        .add(AddDateEvent(DateTime.now()));
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Danh sách ngày phát
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.selectedDates.length,
            itemBuilder: (context, index) {
              final date = state.selectedDates[index];
              return Slidable(
                key: ValueKey(date),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    _buildSlidableAction('Xóa', Icons.delete, Colors.red, () {
                      // Handle delete action
                    }),
                    _buildSlidableAction('Sao chép', Icons.copy, Colors.orange,
                        () {
                      // Handle copy action
                    }),
                    _buildSlidableAction('Sửa', Icons.edit, Colors.blue, () {
                      // Handle edit action
                    }),
                  ],
                ),
                child: _buildDateTile(date),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                context.read<CreateScheduleBloc>().add(CreateSchedule());
              },
              child: const Text('Lưu',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlidableAction(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return SlidableAction(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      onPressed: (context) => onPressed(),
      backgroundColor: color,
      foregroundColor: Colors.white,
      icon: icon,
      label: label,
    );
  }

  Widget _buildDateTile(DateTime date) {
    return Container(
      width: double.infinity,
      // This makes the container take the full width available
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DateFormat('dd-MM-yyyy').format(date)),
          const Text('05:00:00 - 05:05:00 1 bản tin'),
        ],
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context,
      {required String title,
      required String subtitle,
      required VoidCallback onTap}) {
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
          onTap: onTap,
        ),
      ),
    );
  }
}
