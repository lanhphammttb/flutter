import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nttcs/core/utils/functions.dart';
import 'package:nttcs/data/models/content.dart';
import 'package:nttcs/widgets/custom_bottom_sheet.dart';
import 'package:nttcs/widgets/search_field.dart';
import 'package:shimmer/shimmer.dart';
import 'bloc/news_bloc.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late TextEditingController _searchController;
  late NewsBloc newsBloc;
  final ScrollController _scrollController = ScrollController(); // Tạo ScrollController

  @override
  void initState() {
    super.initState();
    newsBloc = context.read<NewsBloc>();
    _scrollController.addListener(_onScroll);
    _searchController = TextEditingController(text: newsBloc.state.searchQuery);
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 200 && newsBloc.state.status == NewsStatus.success) {
      newsBloc.add(const FetchNews(1));
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
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                if (state.status == NewsStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == NewsStatus.success || state.status == NewsStatus.more) {
                  if (state.data.isEmpty) {
                    return const Center(child: Text('Không có lịch phát nào.'));
                  }
                  return RefreshIndicator(
                      // Thêm RefreshIndicator ở đây
                      onRefresh: () async => newsBloc.add(const FetchNews(1)),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: state.data.length + (state.isMoreOrRefresh == 1 ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.data.length) {
                            return _buildShimmer(); // Hiển thị shimmer khi đang tải thêm
                          }
                          final content = state.data[index];
                          // final createdTime = DateFormat('HH:mm - dd/MM/yyyy').format(DateTime.parse(content.createdTime!));
                          return _buildNewsCard(content);
                        },
                      ) // Kết thúc RefreshIndicator
                      );
                } else if (state.status == NewsStatus.failure) {
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

  Widget _buildSearchField() {
    return BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
      return SearchField(
          controller: _searchController,
          onChanged: (value) => newsBloc.add(SearchNews(value)),
          onClear: () {
            _searchController.clear();
            newsBloc.add(const SearchNews(''));
          },
          hintSearch: 'Tìm kiếm bản tin',
          onFilter: _showFilterBottomSheet);
    });
  }

  void _showFilterBottomSheet() {
    CustomBottomSheet(
        height: 200,
        child: BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '     Loại bản tin:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('Bản tin âm thanh'),
                leading: Radio<String>(
                  value: 'audio',
                  groupValue: state.contentType == 3 ? 'audio' : 'live',
                  onChanged: (value) {
                    newsBloc.add(const FetchNews(0, contentType: 3));
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Bản tin trực tiếp'),
                leading: Radio<String>(
                  value: 'live',
                  groupValue: state.contentType == 5 ? 'live' : 'audio',
                  onChanged: (value) {
                    newsBloc.add(const FetchNews(0, contentType: 5));
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        })).show(context);
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
              const Icon(
                Icons.queue_music, // Biểu tượng âm nhạc
                color: Colors.blue,
                size: 30,
              ),
              const SizedBox(width: 10), // Khoảng cách giữa icon và text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.tieuDe ?? "", // Tiêu đề
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
}
