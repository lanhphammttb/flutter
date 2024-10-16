import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                        style: TextStyle(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          bool selectAll = selectedCount != state.devices.length;
                          context.read<CreateScheduleBloc>().add(ToggleSelectAllDevicesEvent(selectAll));
                        },
                        child: Text(
                          selectedCount == state.devices.length ? 'Bỏ chọn tất cả' : 'Chọn tất cả',
                          style: const TextStyle(color: Colors.blue),
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
                if (state.deviceStatus == DeviceStatus.success) {
                  return ListView.builder(
                    itemCount: state.devices.length,
                    itemBuilder: (context, index) {
                      final device = state.devices[index];
                      final isSelected = state.selectedDeviceIds.contains(device.id);
                      return ListTile(
                        leading: CustomImageView(
                          imagePath: Assets.images.icSpeakerOn.path,
                          height: 24,
                          width: 24,
                        ),
                        title: Text(device.name),
                        trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
                        onTap: () => createScheduleBloc.add(SelectDeviceEvent(device)),
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
      onChanged: (value) => createScheduleBloc.add(SearchTextChanged(value)),
      onClear: () {
        _deviceSearchController.clear();
        createScheduleBloc.add(const SearchTextChanged(''));
      },
    );
  }
}
