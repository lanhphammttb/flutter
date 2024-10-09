import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/widgets/custom_image_view.dart';
import 'package:nttcs/gen/assets.gen.dart';
import 'bloc/create_schedule_bloc.dart';

class ChoiceDeviceScreen extends StatelessWidget {
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Nhập địa địa điểm...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: BlocBuilder<CreateScheduleBloc, CreateScheduleState>(
              builder: (context, state) {
                if (state is DeviceLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is DeviceErrorState) {
                  return Text("Error: ${state.error}");
                } else if (state is DeviceLoadedState) {
                  int selectedCount = state.selectedDeviceIds.length;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedCount == 0
                            ? 'Đã chọn: Toàn bộ địa bàn'
                            : 'Đã chọn: $selectedCount',
                        style: TextStyle(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          bool selectAll =
                              selectedCount != state.devices.length;
                          context
                              .read<CreateScheduleBloc>()
                              .add(ToggleSelectAllDevicesEvent(selectAll));
                        },
                        child: Text(
                          selectedCount == state.devices.length
                              ? 'Bỏ chọn tất cả'
                              : 'Chọn tất cả',
                          style: TextStyle(color: Colors.blue),
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
                if (state is DeviceLoadedState) {
                  return ListView.builder(
                    itemCount: state.devices.length,
                    itemBuilder: (context, index) {
                      final device = state.devices[index];
                      final isSelected =
                          state.selectedDeviceIds.contains(device.id);
                      return ListTile(
                        leading: CustomImageView(
                          imagePath: Assets.images.icSpeakerOn.path,
                          height: 24,
                          width: 24,
                        ),
                        title: Text(device.name),
                        trailing: isSelected
                            ? Icon(Icons.check, color: Colors.blue)
                            : null,
                        onTap: () {
                          context
                              .read<CreateScheduleBloc>()
                              .add(SelectDeviceEvent(device));
                        },
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
}
