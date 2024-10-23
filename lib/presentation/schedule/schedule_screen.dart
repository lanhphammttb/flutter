import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nttcs/core/theme/custom_text_style.dart';
import 'package:nttcs/data/models/schedule.dart';
import 'package:nttcs/presentation/create_schedule/bloc/create_schedule_bloc.dart';
import 'package:nttcs/widgets/confirm_dialog.dart';
import 'package:nttcs/widgets/custom_bottom_sheet.dart';
import 'package:nttcs/widgets/custom_elevated_button.dart';
import 'package:nttcs/widgets/search_field.dart';
import 'package:shimmer/shimmer.dart';
import 'bloc/schedule_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late TextEditingController _searchController;
  final ScrollController _scrollController = ScrollController();
  late ScheduleBloc scheduleBloc;

  @override
  void initState() {
    super.initState();
    scheduleBloc = context.read<ScheduleBloc>();
    _scrollController.addListener(_onScroll);
    _searchController = TextEditingController(text: scheduleBloc.state.searchQuery);
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 200 && scheduleBloc.state.status == ScheduleStatus.success) {
      scheduleBloc.add(const FetchSchedule(1));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
          listeners: [
            BlocListener<ScheduleBloc, ScheduleState>(
              listenWhen: (previous, current) => previous.syncStatus != current.syncStatus,
              listener: (context, state) {
                if (state.syncStatus != SyncStatus.initial) {
                  switch (state.syncStatus) {
                    case SyncStatus.success:
                      Fluttertoast.showToast(
                          msg: 'Phát lịch thành công!',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      break;
                    case SyncStatus.failure:
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                      break;
                    case SyncStatus.initial:
                      break;
                    case SyncStatus.loading:
                      Fluttertoast.showToast(
                          msg: 'Đang đồng bộ...',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.orange,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      break;
                  }
                }
              },
            ),
            BlocListener<ScheduleBloc, ScheduleState>(
              listenWhen: (previous, current) => previous.delStatus != current.delStatus,
              listener: (context, state) {
                if (state.delStatus != DelStatus.initial) {
                  switch (state.delStatus) {
                    case DelStatus.success:
                      Fluttertoast.showToast(
                          msg: 'Xóa lịch thành công!',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      break;
                    case DelStatus.failure:
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                      break;
                    case DelStatus.initial:
                      break;
                    case DelStatus.loading:
                      Fluttertoast.showToast(
                          msg: 'Đang xóa...',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      break;
                  }
                }
              },
            )
          ],
          child: Column(
            children: [
              _buildControlPanel(),
              _buildSearchField(),
              Expanded(
                child: BlocBuilder<ScheduleBloc, ScheduleState>(
                  builder: (context, state) {
                    if (state.status == ScheduleStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.status == ScheduleStatus.success || state.status == ScheduleStatus.more) {
                      final filteredItems = _getFilteredItems(state);
                      if (filteredItems.isEmpty) {
                        return const Center(child: Text('Không có lịch phát nào.'));
                      }

                      return RefreshIndicator(
                          // Thêm RefreshIndicator ở đây
                          onRefresh: () async => scheduleBloc.add(const FetchSchedule(0)),
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: filteredItems.length + (state.isMoreOrRefresh == 1 ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == filteredItems.length && state.isMoreOrRefresh == 1) {
                                return _buildShimmer(); // Hiển thị shimmer khi đang tải thêm
                              }

                              final schedule = filteredItems[index];
                              final createdTime = DateFormat('HH:mm - dd/MM/yyyy').format(DateTime.parse(schedule.createdTime!));
                              final modifiedTime = DateFormat('HH:mm - dd/MM/yyyy').format(DateTime.parse(schedule.modifiedTime!));
                              return _buildScheduleCard(schedule, createdTime, modifiedTime);
                            },
                          ));
                    } else if (state.status == ScheduleStatus.failure) {
                      return Center(
                        child: Text('Lỗi: ${state.message}', style: const TextStyle(color: Colors.red)),
                      );
                    }
                    return const Center(child: Text(''));
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildControlPanel() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomElevatedButton(
                onPressed: () {
                  if (state.locationNode?.level == 3) {
                    context.read<CreateScheduleBloc>().add(SelectLocation(
                          state.locationNode!.name,
                          state.locationNode!.id,
                          scheduleName: '${state.locationNode!.name} - ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                          locationCode: state.locationNode!.code,
                        ));
                    Navigator.pushNamed(context, '/create-schedule');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng chọn địa bàn cấp xã!')),
                    );
                  }
                },
                text: 'Lập lịch',
                leftIcon: const Icon(Icons.add_rounded, color: Colors.white),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return SearchField(
      controller: _searchController,
      hintSearch: 'Tìm kiếm lịch phát...',
      onChanged: (value) => scheduleBloc.add(SearchSchedule(value)),
      onClear: () {
        setState(() {
          _searchController.clear();
          scheduleBloc.add(const SearchSchedule(''));
        });
      },
      onFilter: _showFilterBottomSheet,
    );
  }

  void _showFilterBottomSheet() {
    CustomBottomSheet(
        height: 270,
        child: BlocBuilder<ScheduleBloc, ScheduleState>(builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Tất cả'),
                leading: Radio<String>(
                  value: 'all',
                  groupValue: state.filter,
                  onChanged: (value) {
                    scheduleBloc.add(UpdateFilter(value!));
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Bản nháp'),
                leading: Radio<String>(
                  value: 'draft',
                  groupValue: state.filter,
                  onChanged: (value) {
                    scheduleBloc.add(UpdateFilter(value!));
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Đang sử dụng'),
                leading: Radio<String>(
                  value: 'used',
                  groupValue: state.filter,
                  onChanged: (value) {
                    scheduleBloc.add(UpdateFilter(value!));
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Đã hủy'),
                leading: Radio<String>(
                  value: 'cancelled',
                  groupValue: state.filter,
                  onChanged: (value) {
                    scheduleBloc.add(UpdateFilter(value!));
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        })).show(context);
  }

  Widget _buildScheduleCard(Schedule schedule, String createdTime, String modifiedTime) {
    return Slidable(
      key: ValueKey(schedule.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          CustomSlidableAction(
            onPressed: (context) =>
                ConfirmDialog.confirmDialog(context, 'Ban có chắc chắn muốn hủy lịch?', onConfirm: () => scheduleBloc.add(DelSchedule(schedule.id))),
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            backgroundColor: Colors.red, // Màu nền đỏ cho nút xóa
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete, color: Colors.white, size: 24),
                SizedBox(height: 4),
                Text(
                  'Hủy lịch',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          CustomSlidableAction(
            onPressed: (context) =>
                ConfirmDialog.confirmDialog(context, 'Ban có chắc chắn muốn phát lịch?', onConfirm: () => scheduleBloc.add(SyncSchedule(schedule.id))),
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sync, color: Colors.white, size: 28),
                SizedBox(height: 4),
                Text(
                  'Phát lịch',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          if (schedule.status == 2)
            CustomSlidableAction(
              onPressed: (context) {
                context.read<CreateScheduleBloc>().add(FetchDetailSchedule(schedule.id, schedule.siteMapName, schedule.siteMapId, schedule.name));
                Navigator.pushNamed(context, '/create-schedule');
              },
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, color: Colors.white, size: 28),
                  SizedBox(height: 4),
                  Text(
                    'Sửa',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          if (schedule.status == 0)
            CustomSlidableAction(
              onPressed: (context) =>
                  ConfirmDialog.confirmDialog(context, 'Ban có chắc chắn muốn phát lịch?', onConfirm: () => scheduleBloc.add(CopySchedule(schedule.id))),
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.copy, color: Colors.white, size: 28),
                  SizedBox(height: 4),
                  Text(
                    'Sao chép',
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
            schedule.name,
            style: CustomTextStyles.titleLargeBlue800,
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
        _buildInfoText('Địa bàn', schedule.siteMapName),
        _buildInfoText('Lặp lại', '${schedule.scheduleDates.length} ngày'),
        _buildInfoText('Thiết bị', schedule.devices.isEmpty ? 'Tất cả' : '${schedule.devices.length} thiết bị'),
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

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  List<Schedule> _getFilteredItems(ScheduleState state) {
    return state.schedules.where((schedule) {
      final matchesSearch = schedule.name.toLowerCase().contains(state.searchQuery.toLowerCase());
      switch (state.filter) {
        case 'draft':
          return matchesSearch && schedule.status == 2;
        case 'used':
          return matchesSearch && schedule.status == 0;
        case 'cancelled':
          return matchesSearch && schedule.status == 1;
        default:
          return matchesSearch;
      }
    }).toList();
  }
}
