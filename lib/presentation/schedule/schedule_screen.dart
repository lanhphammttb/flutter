import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nttcs/data/models/schedule.dart';
import 'package:nttcs/widgets/custom_bottom_sheet.dart';
import 'package:nttcs/widgets/custom_elevated_button.dart';
import 'package:nttcs/widgets/search_field.dart';
import 'bloc/schedule_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = '';
  String _filter = 'all'; // Biến để lưu trữ trạng thái bộ lọc

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildControlPanel(),
          _buildSearchField(),
          Expanded(
            child: BlocBuilder<ScheduleBloc, ScheduleState>(
              builder: (context, state) {
                if (state is ScheduleLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ScheduleLoaded) {
                  final filteredItems = state.data.items.where((schedule) {
                    final matchesSearch = schedule.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;

                    if (_filter == 'all') {
                      return matchesSearch; // Hiển thị tất cả
                    } else if (_filter == 'draft') {
                      return matchesSearch && schedule.status == 2;
                    } else if (_filter == 'used') {
                      return matchesSearch && schedule.status == 0;
                    } else if (_filter == 'cancelled') {
                      return matchesSearch && schedule.status == 1;
                    }
                    return false;
                  }).toList();

                  if (filteredItems.isEmpty) {
                    return const Center(child: Text('Không có lịch phát nào.'));
                  }

                  return ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final schedule = filteredItems[index];
                      final createdTime = DateFormat('HH:mm - dd/MM/yyyy').format(DateTime.parse(schedule.createdTime!));
                      final modifiedTime = DateFormat('HH:mm - dd/MM/yyyy').format(DateTime.parse(schedule.modifiedTime!));
                      return _buildScheduleCard(schedule, createdTime, modifiedTime);
                    },
                  );
                } else if (state is ScheduleError) {
                  return Center(
                    child: Text('Lỗi: ${state.message}', style: const TextStyle(color: Colors.red)),
                  );
                }
                return const Center(child: Text('Không có dữ liệu.'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomElevatedButton(
            onPressed: () {
              // ở đây mở ra screen create schedule để tạo lịch phát
              Navigator.pushNamed(context, '/create-schedule');
            },
            text: 'Lập lịch',
            leftIcon: const Icon(Icons.add_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return SearchField(
      controller: _controller,
      hintSearch: 'Tìm kiếm lịch phát...',
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      onClear: () {
        setState(() {
          _controller.clear();
          _searchQuery = '';
        });
      },
      onFilter: _showFilterBottomSheet,
    );
  }

  void _showFilterBottomSheet() {
    CustomBottomSheet(
        height: 270,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Tất cả'),
              leading: Radio<String>(
                value: 'all',
                groupValue: _filter,
                onChanged: (value) {
                  setState(() {
                    _filter = value!; // Cập nhật giá trị bộ lọc
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Bản nháp'),
              leading: Radio<String>(
                value: 'draft',
                groupValue: _filter,
                onChanged: (value) {
                  setState(() {
                    _filter = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Đang sử dụng'),
              leading: Radio<String>(
                value: 'used',
                groupValue: _filter,
                onChanged: (value) {
                  setState(() {
                    _filter = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Đã hủy'),
              leading: Radio<String>(
                value: 'cancelled',
                groupValue: _filter,
                onChanged: (value) {
                  setState(() {
                    _filter = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        )).show(context);
  }

  Widget _buildScheduleCard(Schedule schedule, String createdTime, String modifiedTime) {
    return Slidable(
      key: ValueKey(schedule.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          CustomSlidableAction(
            onPressed: (context) {
              // Hành động cho nút xóa
            },
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            backgroundColor: Colors.red, // Màu nền đỏ cho nút xóa
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.delete, color: Colors.white, size: 24),
                SizedBox(height: 4),
                Text(
                  'Xóa',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          CustomSlidableAction(
            onPressed: (context) {
              // Hành động cho nút phát lịch
            },
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.sync, color: Colors.white, size: 28),
                SizedBox(height: 4),
                Text(
                  'Phát lịch',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          CustomSlidableAction(
            onPressed: (context) {
              // Hành động cho nút sửa
            },
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.edit, color: Colors.white, size: 28),
                SizedBox(height: 4),
                Text(
                  'Sửa',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildScheduleHeader(schedule),
                  const SizedBox(height: 8),
                  _buildScheduleInfo(schedule),
                  Text(
                    'Ngày cập nhật: $modifiedTime',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    'Ngày tạo: $createdTime',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleHeader(Schedule schedule) {
    return Row(
      children: [
        Expanded(
          child: Text(
            schedule.name ?? 'Lịch không xác định',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
        const SizedBox(width: 8),
        _buildScheduleStatus(schedule),
      ],
    );
  }

  Widget _buildScheduleInfo(Schedule schedule) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoText('Địa bàn', schedule.siteMapName ?? 'Không xác định'),
        _buildInfoText('Lặp lại', '${schedule.attributes} ngày'),
        _buildInfoText('Thiết bị', 'Tất cả'),
      ],
    );
  }

  Widget _buildInfoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ', // Chữ in đậm
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextSpan(
              text: value, // Giá trị không in đậm
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleStatus(Schedule schedule) {
    Color statusColor;
    String statusText;

    if (schedule.status == 2) {
      statusColor = Colors.orange;
      statusText = 'Bản nháp';
    } else if (schedule.status == 0) {
      statusColor = Colors.green;
      statusText = 'Đang sử dụng';
    } else {
      statusColor = Colors.grey;
      statusText = 'Đã hủy';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        statusText,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
