import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nttcs/core/utils/functions.dart';
import 'package:nttcs/data/models/content.dart';
import 'bloc/news_bloc.dart';
class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = '';
  String _filter = 'all'; // Biến để lưu trữ trạng thái bộ lọc

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                if (state is NewsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NewsLoaded) {
                  final filteredItems = state.data.items.where((content) {
                    final matchesSearch = content.tieuDe
                        ?.toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ??
                        false;

                    if (_filter == 'all') {
                      return matchesSearch; // Hiển thị tất cả
                    } else if (_filter == 'audio') {
                      // return matchesSearch && content. == 2;
                    } else if (_filter == 'live') {
                      // return matchesSearch && content.status == 0;
                    }
                    return false;
                  }).toList();

                  if (filteredItems.isEmpty) {
                    return const Center(child: Text('Không có lịch phát nào.'));
                  }

                  return ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final content = filteredItems[index];
                      // final createdTime = DateFormat('HH:mm - dd/MM/yyyy').format(DateTime.parse(content.createdTime!));
                      return _buildNewsCard(content);
                    },
                  );
                } else if (state is NewsError) {
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
            hintText: 'Tìm kiếm...',
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
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Lọai bản tin:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Bản tin âm thanh'),
                leading: Radio<String>(
                  value: 'audio',
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
                title: const Text('Bản tin trực tiếp'),
                leading: Radio<String>(
                  value: 'live',
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

  Widget _buildNewsCard(Content content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(
                Icons.queue_music,  // Biểu tượng âm nhạc
                color: Colors.blue,
                size: 30,
              ),
              const SizedBox(width: 10), // Khoảng cách giữa icon và text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.tieuDe ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Màu xanh cho tiêu đề
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                     convertSecondsToHHMMSS(content.thoiLuong ?? "0"), // Thời lượng
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey, // Màu xám cho thời gian
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
