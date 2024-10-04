import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/presentation/device/bloc/device_bloc.dart';
import 'package:nttcs/presentation/device/device_screen.dart';
import 'package:nttcs/presentation/information/information_screen.dart';
import 'package:nttcs/presentation/news/news_screen.dart';
import 'package:nttcs/presentation/overview/overview_screen.dart';
import 'package:nttcs/presentation/schedule/bloc/schedule_bloc.dart';
import 'package:nttcs/presentation/schedule/schedule_screen.dart';
import 'package:nttcs/widgets/search_field.dart';
import 'package:nttcs/widgets/tree_node_widget.dart';
import 'bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _pages = const <Widget>[
    OverviewScreen(),
    DeviceScreen(),
    ScheduleScreen(),
    NewsScreen(),
    InformationScreen(),
  ];

  void _onItemTapped(BuildContext context, int index) {
    context.read<HomeBloc>().add(TabChanged(index));

    // Gọi API tương ứng với mỗi tab
    switch (index) {
      case 1:
        _callDeviceApi(context);
        break;
      case 2:
        _callScheduleApi(context);
        break;
      default:
        break;
    }
  }

  void _callDeviceApi(BuildContext context) {
    final deviceBloc = context.read<DeviceBloc>();
    deviceBloc.add(FetchDevices());
  }

  void _callScheduleApi(BuildContext context) {
    final scheduleBloc = context.read<ScheduleBloc>();
    scheduleBloc.add(FetchSchedule());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            int currentIndex = state is TabIndexChanged ? state.tabIndex : 0;
            return IndexedStack(
              index: currentIndex,
              children: _pages,
            );
          },
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.blue,
      elevation: 0,
      title: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          // Lấy giá trị locationName
          final locationText =
              state is LocationSelected ? state.locationName : 'Loading...';
          return GestureDetector(
              onTap: () {
                _showBottomSheet(context);
                _callApiInBottomSheet(context);
              },
              child: Row(
                children: [
                  Text(
                    locationText,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ));
        },
      ),
    );
  }

  void _callApiInBottomSheet(BuildContext context) {
    // Chỉ gọi API nếu chưa có dữ liệu
    // final currentState = context.read<HomeBloc>().state;
    // if (currentState is! LocationsSuccess) {
    //
    // }
    context
        .read<HomeBloc>()
        .add(FetchLocations()); // Gọi API chỉ khi chưa có dữ liệu
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.87,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
          ),
          child: Column(
            children: [
              _buildDraggableIndicator(),
              Expanded(
                child: DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 1.0,
                  minChildSize: 0.1,
                  maxChildSize: 1.0,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Column(
                      children: [
                        _buildSearchField(context),
                        Expanded(
                          child: BlocBuilder<HomeBloc, HomeState>(
                            builder: (context, state) {
                              if (state is LocationsLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is LocationsSuccess) {
                                return TreeNodeWidget(
                                  treeNodes: state.treeNodes,
                                  onItemClick: (node) {
                                    context
                                        .read<HomeBloc>()
                                        .add(SelectLocation(node.name));
                                    context
                                        .read<HomeBloc>()
                                        .add(ExpandNode(node));
                                    Navigator.pop(
                                        context); // Đóng BottomSheet sau khi chọn
                                  },
                                );
                              } else if (state is LocationsFailure) {
                                return Center(
                                    child: Text(
                                        'Failed to load locations: ${state.error}'));
                              } else {
                                return const Center(
                                    child: Text('No data available'));
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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

  Widget _buildDraggableIndicator() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final currentIndex = state is TabIndexChanged ? state.tabIndex : 0;
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          currentIndex: currentIndex,
          onTap: (index) => _onItemTapped(context, index),
          // Dispatch tab change event
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.volume_up),
              label: 'Cụm loa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Lịch phát',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'Bản tin',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Cá nhân',
            ),
          ],
        );
      },
    );
  }
}
