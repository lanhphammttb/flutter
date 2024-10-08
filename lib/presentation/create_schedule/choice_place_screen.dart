import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/widgets/search_field.dart';
class ChoicePlaceScreen extends StatefulWidget {
  const ChoicePlaceScreen({Key? key}) : super(key: key);

  @override
  State<ChoicePlaceScreen> createState() => _ChoicePlaceScreenState();
}

class _ChoicePlaceScreenState extends State<ChoicePlaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedPlace = 'Thị trấn Bến Lức';
  List<String> places = [
    'Huyện Bến Lức',
    'Huyện Cần Đước',
    'Huyện Cần Giuộc',
    'Huyện Châu Thành',
    'Huyện Đức Hòa',
    'Huyện Đức Huệ',
    'Huyện Mộc Hóa',
    'Huyện Tân Hưng',
    'Huyện Tân Thạnh',
    'Huyện Tân Trụ',
    'Huyện Thạnh Hóa',
    'Huyện Thủ Thừa',
    'Huyện Vĩnh Hưng',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Quay lại',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.blue,
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Địa điểm đã chọn: $selectedPlace',
              style: const TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
          Column(
            children: [
              _buildSearchField(context),
              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is LocationsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is LocationsSuccess) {
                      return TreeNodeWidget(
                        treeNodes: state.treeNodes,
                        onItemClick: (node) {
                          // Gọi hành động khi nhấn vào mục trong danh sách
                          context.read<HomeBloc>().add(SelectLocation(node.name));
                          context.read<HomeBloc>().add(ExpandNode(node));
                          Navigator.pop(context); // Đóng BottomSheet sau khi chọn
                        },
                      );
                    } else if (state is LocationsFailure) {
                      return Center(child: Text('Failed to load locations: ${state.error}'));
                    } else {
                      return const Center(child: Text('No data available'));
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return SearchField(
      controller: TextEditingController(),
      onChanged: (value) =>
          context.read<HomeBloc>().add(SearchTextChanged(value)),
      onClear: () => context.read<HomeBloc>().add(SearchTextChanged('')),
      onFilter: () {},
    );
  }
}
