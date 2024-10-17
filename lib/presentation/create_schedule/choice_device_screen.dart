import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/core/app_export.dart';
import 'package:nttcs/widgets/custom_image_view.dart';
import 'package:nttcs/gen/assets.gen.dart';
import 'package:nttcs/widgets/search_field.dart';
import 'bloc/create_schedule_bloc.dart';

class ChoiceDeviceScreen extends StatefulWidget {
  const ChoiceDeviceScreen({super.key});

  @override
  State<ChoiceDeviceScreen> createState() => _ChoiceDeviceScreenState();
}

class _ChoiceDeviceScreenState extends State<ChoiceDeviceScreen> {
  late TextEditingController _deviceSearchController;
  late CreateScheduleBloc createScheduleBloc;

  @override
  void initState() {
    super.initState();
    createScheduleBloc = context.read<CreateScheduleBloc>();
    _deviceSearchController = TextEditingController(text: createScheduleBloc.state.deviceSearchQuery);
  }

  @override
  void dispose() {
    _deviceSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quay lại'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          _buildSearchField(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: BlocBuilder<CreateScheduleBloc, CreateScheduleState>(
              builder: (context, state) {
                if (state.deviceStatus == DeviceStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.deviceStatus == DeviceStatus.failure) {
                  return Text('Có lỗi xảy ra: ${state.message}');
                } else if (state.deviceStatus == DeviceStatus.success) {
                  int selectedCount = state.selectedDeviceIds.length;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedCount == 0 ? 'Đã chọn: Toàn bộ địa bàn' : 'Đã chọn: $selectedCount',
                        style: CustomTextStyles.titleSmallInter,
                      ),
                      GestureDetector(
                        onTap: () => createScheduleBloc.add(const SelectAllDevices()),
                        child: Text(
                          state.isSelectAll ? 'Bỏ chọn tất cả' : 'Chọn tất cả',
                          style: CustomTextStyles.titleMediumBlue800,
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<CreateScheduleBloc, CreateScheduleState>(
              builder: (context, state) {
                if (state.deviceStatus == DeviceStatus.success && state.devices.isNotEmpty) {
                  final filteredDevices = state.devices.where((device) => device.name.toLowerCase().contains(state.deviceSearchQuery.toLowerCase())).toList();
                  return ListView.builder(
                    itemCount: filteredDevices.length,
                    itemBuilder: (context, index) {
                      final device = filteredDevices[index];
                      return ListTile(
                        leading: CustomImageView(
                          imagePath: Assets.images.icSpeakerOn.path,
                          height: 24,
                          width: 24,
                        ),
                        title: Text(device.name),
                        trailing: state.selectedDeviceIds.contains(device.id) ? const Icon(Icons.check, color: Colors.green) : null,
                        onTap: () => createScheduleBloc.add(SelectDevice(device.id)),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return SearchField(
      hintSearch: 'Tìm kiếm thiết bị',
      controller: _deviceSearchController,
      onChanged: (value) => createScheduleBloc.add(DeviceSearchTextChanged(value)),
      onClear: () {
        _deviceSearchController.clear();
        createScheduleBloc.add(const SearchTextChanged(''));
      },
    );
  }
}
