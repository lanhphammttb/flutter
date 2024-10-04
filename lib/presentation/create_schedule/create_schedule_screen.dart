import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'bloc/create_schedule_bloc.dart';

class CreateScheduleScreen extends StatelessWidget {
  const CreateScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo lịch phát'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
        body: BlocBuilder<CreateScheduleBloc, CreateScheduleState>(
          builder: (context, state) {
            if (state is CreateScheduleInitial) {
              // Gửi một sự kiện khởi tạo để bắt đầu với trạng thái mặc định
              context.read<CreateScheduleBloc>().add(InitializeCreateScheduleEvent());
            }
            if (state is CreateScheduleLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CreateScheduleLoaded) {
              return const Center(child: Text('Lịch phát đã được lưu.'));
            } else if (state is CreateScheduleUpdated) {
              // Xây dựng giao diện với trạng thái đã cập nhật
              return _buildCreateScheduleForm(context, state);
            }
            return const Center(child: Text('Đang tải...'));
          },
        ),
    );
  }

  Widget _buildCreateScheduleForm(BuildContext context, CreateScheduleUpdated state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            title: const Text('Tên lịch phát:'),
            subtitle: Text(
                'Thị trấn Bến Lức - ${DateTime.now().toString().split(' ')[0]}'),
            trailing: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                // Xử lý khi người dùng muốn xoá
              },
            ),
          ),
          ListTile(
            title: const Text('Địa điểm phát'),
            subtitle: Text('Địa điểm đã chọn: ${state.location}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              context.read<CreateScheduleBloc>().add(SelectLocationEvent(1));
            },
          ),
          ListTile(
            title: const Text('Thiết bị phát'),
            subtitle: Text('Đã chọn: ${state.device}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              context.read<CreateScheduleBloc>().add(SelectDeviceEvent([]));
            },
          ),
          ListTile(
            title: const Text('Ngày phát'),
            subtitle: Text('${state.selectedDates.length} ngày'),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                context.read<CreateScheduleBloc>().add(AddDateEvent(DateTime.now()));
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: state.selectedDates.length,
              itemBuilder: (context, index) {
                final date = state.selectedDates[index];
                return ListTile(
                  title: Text(
                    DateFormat('dd-MM-yyyy').format(date),
                  ),
                  subtitle: const Text('05:00:00 - 05:15:28  4 bản tin'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                context.read<CreateScheduleBloc>().add(CreateSchedule());
              },
              child: const Text('Lưu'),
            ),
          ),
        ],
      ),
    );
  }
}
