import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/widgets/search_field.dart';
import 'package:nttcs/widgets/tree_node_widget.dart';

import 'bloc/create_schedule_bloc.dart';

class ChoicePlaceScreen extends StatefulWidget {
  const ChoicePlaceScreen({super.key});

  @override
  State<ChoicePlaceScreen> createState() => _ChoicePlaceScreenState();
}

class _ChoicePlaceScreenState extends State<ChoicePlaceScreen> {
  late TextEditingController _locationSearchController;
  String selectedPlace = 'Thị trấn Bến Lức';
  late CreateScheduleBloc createScheduleBloc;

  @override
  void initState() {
    super.initState();
    createScheduleBloc = context.read<CreateScheduleBloc>();
    _locationSearchController = TextEditingController(text: createScheduleBloc.state.locationSearchQuery);
  }

  @override
  void dispose() {
    _locationSearchController.dispose();
    super.dispose();
  }

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
          Expanded(
              child: Column(
            children: [
              _buildSearchField(context),
              Expanded(
                child: BlocBuilder<CreateScheduleBloc, CreateScheduleState>(
                  builder: (context, state) {
                    if (state.locationStatus == LocationStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.locationStatus == LocationStatus.success) {
                      return TreeNodeWidget(
                        treeNodes: state.treeNodes,
                        onItemClick: (node) {
                          // Gọi hành động khi nhấn vào mục trong danh sách
                          createScheduleBloc.add(SelectLocationEvent(node.name));
                          createScheduleBloc.add(ExpandNodeEvent(node));
                        },
                      );
                    } else if (state.locationStatus == LocationStatus.failure) {
                      return Text('Có lỗi xảy ra: ${state.message}');
                    } else {
                      return const Center(child: Text('No data available'));
                    }
                  },
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return SearchField(
      hintSearch: 'Tìm kiếm địa điểm',
      controller: _locationSearchController,
      onChanged: (value) => createScheduleBloc.add(SearchTextChanged(value)),
      onClear: () {
        _locationSearchController.clear();
        createScheduleBloc.add(const SearchTextChanged(''));
      },
    );
  }
}
