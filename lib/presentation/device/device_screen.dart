import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nttcs/data/models/device2.dart';
import 'package:nttcs/widgets/custom_bottom_sheet.dart';
import 'package:nttcs/widgets/custom_elevated_button.dart';
import 'package:nttcs/widgets/custom_image_view.dart';
import 'package:nttcs/widgets/search_field.dart';
import 'package:shimmer/shimmer.dart';
import 'bloc/device_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nttcs/core/app_export.dart';
import 'package:nttcs/gen/assets.gen.dart';
import 'package:text_marquee/text_marquee.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  late DeviceBloc deviceBloc;
  final ScrollController _scrollController = ScrollController(); // Tạo ScrollController
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    deviceBloc = context.read<DeviceBloc>();
    _scrollController.addListener(_onScroll);
    _searchController = TextEditingController(text: deviceBloc.state.searchQuery);
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 200 && deviceBloc.state.status == DeviceStatus.success) {
      deviceBloc.add(const FetchDevices(1));
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
      body: BlocListener<DeviceBloc, DeviceState>(
        listenWhen: (previous, current) => previous.message != current.message,
        listener: (context, state) {
          if (state.status == DeviceStatus.success && state.message.isNotEmpty) {
            print('Message to display: ${state.message}'); // Kiểm tra giá trị của state.message
            Fluttertoast.showToast(
                msg: state.message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
            );

            //gán mặc định cho message
            deviceBloc.add(const FetchDevices(2));
          }
          if (state.status == DeviceStatus.failure && state.message.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Column(
          children: [
            _buildControlPanel(),
            _buildSearchField(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: BlocBuilder<DeviceBloc, DeviceState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Đã chọn: ${state.selectedItems.length}', style: CustomTextStyles.titleSmallInter),
                      TextButton(
                        onPressed: () => deviceBloc.add(const SelectAllDevices()),
                        child: Text(
                          state.isSelectAll ? 'Bỏ chọn tất cả' : 'Chọn tất cả',
                          style: CustomTextStyles.titleMediumBlue800,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<DeviceBloc, DeviceState>(
                builder: (context, state) {
                  if (state.status == DeviceStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == DeviceStatus.success || state.status == DeviceStatus.more) {
                    final filteredItems = _getFilteredItems(state);

                    if (filteredItems.isEmpty) {
                      return const Center(child: Text('Không có thiết bị nào.'));
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: filteredItems.length + (state.isMoreOrRefresh == 1 ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == filteredItems.length) {
                          return _buildShimmer(); // Hiển thị shimmer khi đang tải thêm
                        }
                        final device = filteredItems[index];
                        final formattedDate = DateFormat('HH:mm - dd/MM/yyyy').format(
                          DateTime.fromMillisecondsSinceEpoch(device.thoiDiemBatDau * 1000),
                        );
                        return _buildDeviceCard(device, formattedDate, context);
                      },
                    );
                  } else if (state.status == DeviceStatus.failure) {
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
      ),
    );
  }

  List<Device2> _getFilteredItems(DeviceState state) {
    return state.data.where((device) {
      final matchesSearch = device.tenThietBi?.toLowerCase().contains(state.searchQuery.toLowerCase()) ?? false;
      switch (state.filter) {
        case 'playing':
          return matchesSearch && device.dangPhat;
        case 'connected':
          return matchesSearch && !device.matKetNoi;
        case 'disconnected':
          return matchesSearch && device.matKetNoi;
        default:
          return matchesSearch;
      }
    }).toList();
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

  // Hàm để xây dựng mỗi item với checkbox
  Widget _buildDeviceCard(Device2 device, String formattedDate, BuildContext context) {
    final isSelected = deviceBloc.state.selectedItems.contains(device.maThietBi);
    return InkWell(
      onTap: () => {if (!device.matKetNoi) deviceBloc.add(SelectDevice(device.maThietBi))},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.volume_up,
                      size: 24,
                      color: device.isActive
                          ? Colors.green
                          : !device.matKetNoi
                              ? appTheme.primary
                              : Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      device.tenThietBi ?? 'Thiết bị không xác định',
                      style: device.isActive
                          ? CustomTextStyles.titleActive
                          : !device.matKetNoi
                              ? CustomTextStyles.titleOn
                              : CustomTextStyles.titleOff,
                    ),
                  ),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: isSelected ? Icon(Icons.check_circle, color: appTheme.primary, size: 24) : null,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildDeviceInfo(device),
              _buildDeviceStatus(device),
              const SizedBox(height: 8),
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
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
              CustomBottomSheet(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 16, 0),
                        child: BlocBuilder<DeviceBloc, DeviceState>(
                          builder: (context, state) {
                            return Row(
                              children: [
                                Expanded(
                                    child: Slider(
                                        value: state.volumePreview!.toDouble() ?? 50.0,
                                        min: 0,
                                        max: 100,
                                        onChanged: (value) => deviceBloc.add(DeviceVolumeChanged(value.toInt())))),
                                Text('${state.volumePreview}'),
                                const SizedBox(width: 16),
                                CustomElevatedButton(
                                  onPressed: () => deviceBloc.add(const CommitVolumeChange()),
                                  text: 'Âm lượng',
                                  leftIcon: const Icon(Icons.volume_up, color: Colors.white, size: 20),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: GridView.count(
                          crossAxisCount: MediaQuery.of(context).size.width > 414 ? 4 : 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildControlButton('Khởi động lại', Icons.refresh, Colors.blue),
                            _buildControlButton2('Bật công suất', Assets.images.icHotspotOn, Colors.blue),
                            _buildControlButton2('Tắt công suất', Assets.images.icHotspotOff, Colors.red),
                            _buildControlButton('Phát tiếp', Icons.play_arrow, Colors.blue),
                            _buildControlButton('Tạm dừng', Icons.pause, Colors.red),
                            _buildControlButton('Bản tin tiếp', Icons.fast_forward, Colors.blue),
                            _buildControlButton('Dừng phát', Icons.stop_circle, Colors.red),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                height: 510.v,
              ).show(context);
            },
            text: 'Điều khiển',
            rightIcon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          ),
          const SizedBox(width: 8),
          CustomElevatedButton(
            onPressed: () {
              // Hành động khi nhấn nút phát khẩn
            },
            backgroundColor: Colors.red,
            rightIcon: const Icon(Icons.play_circle, color: Colors.white),
            text: 'Phát ngay',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      return SearchField(
        hintSearch: 'Tìm kiếm thiết bị...',
        controller: _searchController,
        onChanged: (value) => deviceBloc.add(SearchDevice(value)),
        onClear: () {
          _searchController.clear();
          deviceBloc.add(const SearchDevice(''));
        },
        onFilter: _showFilterBottomSheet,
      );
    });
  }

  void _showFilterBottomSheet() {
    CustomBottomSheet(
        height: 270,
        child: BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text('Tất cả'),
                leading: Radio<String>(
                  value: 'all',
                  groupValue: state.filter,
                  onChanged: (value) {
                    deviceBloc.add(UpdateFilter(value!));
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Đang phát'),
                leading: Radio<String>(
                  value: 'playing',
                  groupValue: state.filter,
                  onChanged: (value) {
                    deviceBloc.add(UpdateFilter(value!));
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Đang kết nối'),
                leading: Radio<String>(
                  value: 'connected',
                  groupValue: state.filter,
                  onChanged: (value) {
                    deviceBloc.add(UpdateFilter(value!));
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Mất kết nối'),
                leading: Radio<String>(
                  value: 'disconnected',
                  groupValue: state.filter,
                  onChanged: (value) {
                    deviceBloc.add(UpdateFilter(value!));
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        })).show(context);
  }
}

Widget _buildDeviceInfo(Device2 device) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoText('Mã thiết bị: ${device.maThietBi ?? 'Không xác định'}', device.matKetNoi),
      _buildInfoText('Nhà cung cấp: ${device.maNhaCungCap ?? 'Không xác định'}', device.matKetNoi),
      _buildInfoText('Địa bàn: ${device.tenNguon ?? 'Không xác định'}', device.matKetNoi),
      _buildInfoText('Lịch phát: ${device.schedule?.name.isNotEmpty == true ? device.schedule?.name : 'Chưa lập lịch'}', device.matKetNoi),
      _buildInfoText('Âm lượng: ${device.amLuong ?? 'Không xác định'}', device.matKetNoi),
    ],
  );
}

Widget _buildInfoText(String text, bool isMatKetNoi) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: Text(
      text,
      style: TextStyle(fontSize: 14, color: isMatKetNoi ? Colors.grey : Colors.black),
      overflow: TextOverflow.ellipsis,
      softWrap: false, // Giới hạn chỉ hiển thị một dòng
    ),
  );
}

Widget _buildDeviceStatus(Device2 device) {
  return device.dangPhat
      ? TextMarquee(
          device.noiDungPhat,
          spaceSize: 72,
          curve: Curves.easeInBack,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        )
      : Text(
          'Không phát',
          style: TextStyle(
            fontSize: 14,
            color: !device.matKetNoi ? Colors.red : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        );
}

Widget _buildControlButton(String label, IconData icon, Color color) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: color, size: 32),
      const SizedBox(height: 8),
      Text(
        label,
        style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Widget _buildControlButton2(String label, String svgPath, Color color) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      CustomImageView(
        imagePath: svgPath,
        height: 32,
        width: 32,
        color: color,
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
