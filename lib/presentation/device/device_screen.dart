import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/data/models/device2.dart';
import 'package:nttcs/widgets/custom_bottom_sheet.dart';
import 'package:nttcs/widgets/custom_image_view.dart';
import 'bloc/device_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nttcs/core/app_export.dart';
import 'package:nttcs/gen/assets.gen.dart';
class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
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
            child: BlocBuilder<DeviceBloc, DeviceState>(
              builder: (context, state) {
                if (state is DeviceLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DeviceLoaded) {
                  final filteredItems = state.data.items.where((device) {
                    // Lọc thiết bị theo truy vấn tìm kiếm
                    final matchesSearch = device.tenThietBi?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;

                    // Lọc thiết bị theo trạng thái
                    if (_filter == 'all') {
                      return matchesSearch; // Hiển thị tất cả
                    } else if (_filter == 'playing') {
                      return matchesSearch && device.dangPhat; // Chỉ hiển thị thiết bị đang phát
                    } else if (_filter == 'connected') {
                      return matchesSearch && !device.matKetNoi; // Chỉ hiển thị thiết bị đang kết nối
                    } else if (_filter == 'disconnected') {
                      return matchesSearch && device.matKetNoi; // Chỉ hiển thị thiết bị mất kết nối
                    }
                    return false;
                  }).toList();

                  if (filteredItems.isEmpty) {
                    return const Center(child: Text('Không có thiết bị nào.'));
                  }

                  return ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final device = filteredItems[index];
                      final formattedDate = DateFormat('HH:mm - dd/MM/yyyy').format(
                        DateTime.fromMillisecondsSinceEpoch(device.thoiDiemBatDau * 1000),
                      );

                      return _buildDeviceCard(device, formattedDate);
                    },
                  );
                } else if (state is DeviceError) {
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
          ElevatedButton(
            onPressed: () {
              CustomBottomSheet(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Thanh trượt âm lượng
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: 0,
                                min: 0,
                                max: 100,
                                onChanged: (value) {
                                  // Logic xử lý thay đổi giá trị âm lượng
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Logic xử lý khi bấm vào nút Âm lượng
                              },
                              icon: const Icon(Icons.volume_up, color: Colors.white),
                              label: const Text('Âm lượng', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: GridView.count(
                          crossAxisCount: crossAxisCount, // Số lượng cột linh hoạt
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildControlButton('Khởi động lại', Icons.refresh, Colors.blue),
                            _buildControlButton2('Bật công suất', Assets.images.icHotspotOn, Colors.green),
                            _buildControlButton2('Tắt công suất', Assets.images.icHotspotOff, Colors.red),
                            _buildControlButton('Phát tiếp', Icons.play_arrow, Colors.blue),
                            _buildControlButton('Tạm dừng', Icons.pause, Colors.orange),
                            _buildControlButton('Bản tin tiếp', Icons.fast_forward, Colors.purple),
                            _buildControlButton('Dừng phát', Icons.stop, Colors.red),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                height: bottomSheetHeight,
              ).show(context);

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text(
              'Điều khiển',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              // Hành động khi nhấn nút phát khẩn
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Phát khẩn', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: _controller,
          onChanged: (value) {
            setState(() {
              _searchQuery = value; // Cập nhật giá trị tìm kiếm
            });
          },
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            filled: true,
            contentPadding: const EdgeInsets.all(12.0),
            prefixIcon: const Icon(Icons.search, color: Colors.blue),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _controller.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _searchQuery = ''; // Xóa giá trị tìm kiếm
                    });
                  },
                )
                    : const SizedBox.shrink(),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.blue),
                  onPressed: _showFilterBottomSheet,
                ),
              ],
            ),
            hintStyle: const TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Chọn trạng thái:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
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
                title: const Text('Đang phát'),
                leading: Radio<String>(
                  value: 'playing',
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
                title: const Text('Đang kết nối'),
                leading: Radio<String>(
                  value: 'connected',
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
                title: const Text('Mất kết nối'),
                leading: Radio<String>(
                  value: 'disconnected',
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
          ),
        );
      },
    );
  }

  Widget _buildDeviceCard(Device2 device, String formattedDate) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDeviceHeader(device),
              const SizedBox(height: 8),
              _buildDeviceInfo(device),
              const SizedBox(height: 8),
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

  Widget _buildDeviceHeader(Device2 device) {
    return Row(
      children: [
        const Icon(Icons.volume_up, size: 24, color: Colors.blue),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            device.tenThietBi ?? 'Thiết bị không xác định',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceInfo(Device2 device) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoText('Mã thiết bị: ${device.maThietBi ?? 'Không xác định'}'),
        _buildInfoText('Nhà cung cấp: ${device.maNhaCungCap ?? 'Không xác định'}'),
        _buildInfoText('Địa bàn: ${device.tenNguon ?? 'Không xác định'}'),
        _buildInfoText('Lịch phát: ${device.noiDungPhat?.isNotEmpty == true ? device.noiDungPhat : 'Chưa lập lịch'}'),
        _buildInfoText('Âm lượng: ${device.amLuong ?? 'Không xác định'}'),
      ],
    );
  }

  Widget _buildInfoText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildDeviceStatus(Device2 device) {
    return Text(
      device.dangPhat ? 'Đang phát' : 'Không phát',
      style: TextStyle(
        fontSize: 14,
        color: device.dangPhat ? Colors.green : Colors.red,
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
}

