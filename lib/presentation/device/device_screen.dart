import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/data/models/device2.dart';
import 'package:nttcs/widgets/custom_bottom_sheet.dart';
import 'package:nttcs/widgets/custom_image_view.dart';
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
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = '';
  String _filter = 'all';
  List<String> _selectedItems = []; // Danh sách các item đã được chọn
  bool _isSelectAll = false; // Trạng thái nút chọn tất cả

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildControlPanel(),
          _buildSearchField(),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Đã chọn: ${_selectedItems.length}',
                    style: TextStyle(fontSize: 16)),
                TextButton(
                  onPressed: _toggleSelectAll,
                  child: Text(
                    _isSelectAll ? 'Bỏ chọn tất cả' : 'Chọn tất cả',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<DeviceBloc, DeviceState>(
              builder: (context, state) {
                if (state is DeviceLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DeviceLoaded) {
                  final filteredItems = state.data.items.where((device) {
                    final matchesSearch = device.tenThietBi
                            ?.toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ??
                        false;
                    if (_filter == 'all') {
                      return matchesSearch;
                    } else if (_filter == 'playing') {
                      return matchesSearch && device.dangPhat;
                    } else if (_filter == 'connected') {
                      return matchesSearch && !device.matKetNoi;
                    } else if (_filter == 'disconnected') {
                      return matchesSearch && device.matKetNoi;
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
                      final formattedDate =
                          DateFormat('HH:mm - dd/MM/yyyy').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            device.thoiDiemBatDau * 1000),
                      );
                      return _buildDeviceCard(device, formattedDate);
                    },
                  );
                } else if (state is DeviceError) {
                  return Center(
                    child: Text('Lỗi: ${state.message}',
                        style: const TextStyle(color: Colors.red)),
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

  // Hàm để xây dựng mỗi item với checkbox
  Widget _buildDeviceCard(Device2 device, String formattedDate) {
    final isSelected = _selectedItems.contains(device.maThietBi);
    return InkWell(
      onTap: () => _toggleSelectItem(device.maThietBi!),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        // Chỉ cần khoảng cách trên dưới
        child: Container(
          color: Colors.white, // Đặt nền trắng để trông đơn giản hơn
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.volume_up, size: 24, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      device.tenThietBi ?? 'Thiết bị không xác định',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                  SizedBox(
                    width: 24,
                    // Kích thước chiều rộng cố định cho vị trí của biểu tượng
                    height: 24,
                    child: isSelected
                        ? Icon(Icons.check_circle,
                            color: Colors.green, size: 24)
                        : null, // Nếu không có icon, giữ khoảng trống cố định
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

  // Hàm chuyển đổi trạng thái chọn item
  void _toggleSelectItem(String itemId) {
    final state = BlocProvider.of<DeviceBloc>(context).state;
    if (state is DeviceLoaded) {
      setState(() {
        if (_selectedItems.contains(itemId)) {
          _selectedItems.remove(itemId);
        } else {
          _selectedItems.add(itemId);
        }
        _isSelectAll = _selectedItems.length == state.data.items.length;
      });
    }
  }

  void _toggleSelectAll() {
    final state = BlocProvider.of<DeviceBloc>(context).state;
    if (state is DeviceLoaded) {
      setState(() {
        if (_isSelectAll) {
          _selectedItems.clear();
        } else {
          _selectedItems =
              state.data.items.map((item) => item.maThietBi!).toList();
        }
        _isSelectAll = !_isSelectAll;
      });
    }
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: 50,
                                min: 0,
                                max: 100,
                                onChanged: (value) => context
                                    .read<DeviceBloc>()
                                    .add(DeviceVolumeChanged(
                                        "device_id_here", value.toInt())),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                context
                                    .read<DeviceBloc>()
                                    .add(CommitVolumeChange("device_id_here"));
                              },
                              icon: const Icon(Icons.volume_up,
                                  color: Colors.white),
                              label: const Text('Âm lượng',
                                  style: TextStyle(color: Colors.white)),
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
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 414 ? 4 : 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildControlButton(
                                'Khởi động lại', Icons.refresh, Colors.blue),
                            _buildControlButton2('Bật công suất',
                                Assets.images.icHotspotOn, Colors.blue),
                            _buildControlButton2('Tắt công suất',
                                Assets.images.icHotspotOff, Colors.red),
                            _buildControlButton(
                                'Phát tiếp', Icons.play_arrow, Colors.blue),
                            _buildControlButton(
                                'Tạm dừng', Icons.pause, Colors.red),
                            _buildControlButton('Bản tin tiếp',
                                Icons.fast_forward, Colors.blue),
                            _buildControlButton(
                                'Dừng phát', Icons.stop_circle, Colors.red),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                height: 510.v,
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
            child:
                const Text('Phát khẩn', style: TextStyle(color: Colors.white)),
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
              _searchQuery = value;
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
                            _searchQuery = '';
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
                      _filter = value!;
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

  Widget _buildDeviceInfo(Device2 device) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoText('Mã thiết bị: ${device.maThietBi ?? 'Không xác định'}'),
        _buildInfoText(
            'Nhà cung cấp: ${device.maNhaCungCap ?? 'Không xác định'}'),
        _buildInfoText('Địa bàn: ${device.tenNguon ?? 'Không xác định'}'),
        _buildInfoText(
            'Lịch phát: ${device.noiDungPhat.isNotEmpty == true && device.noiDungPhat != ' ' ? device.noiDungPhat : 'Chưa lập lịch'}'),
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
        : const Text(
            'Không phát',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red,
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
          style: TextStyle(
              fontSize: 14, color: color, fontWeight: FontWeight.w500),
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
          style: TextStyle(
              fontSize: 14, color: color, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
