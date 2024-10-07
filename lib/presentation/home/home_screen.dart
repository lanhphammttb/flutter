import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/presentation/device/bloc/device_bloc.dart';
import 'package:nttcs/presentation/device/device_screen.dart';
import 'package:nttcs/presentation/information/bloc/information_bloc.dart';
import 'package:nttcs/presentation/information/information_screen.dart';
import 'package:nttcs/presentation/news/bloc/news_bloc.dart';
import 'package:nttcs/presentation/news/news_screen.dart';
import 'package:nttcs/presentation/overview/overview_screen.dart';
import 'package:nttcs/presentation/schedule/bloc/schedule_bloc.dart';
import 'package:nttcs/presentation/schedule/schedule_screen.dart';
import 'package:nttcs/widgets/custom_bottom_sheet.dart';
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
      case 3:
        _callNewsApi(context);
        break;
      case 4:
        _callInformationApi(context);
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

  void _callNewsApi(BuildContext context) {
    final newsBloc = context.read<NewsBloc>();
    newsBloc.add(FetchNews());
  }

  void _callInformationApi(BuildContext context) {
    final informationBloc = context.read<InformationBloc>();
    informationBloc.add(FetchInformation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        // Kích thước mặc định của AppBar
        child: _buildAppBar(context), // Trả về widget từ _buildAppBar
      ),
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
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        int currentIndex = state is TabIndexChanged ? state.tabIndex : 0;
        if (currentIndex == 4) {
          // Trả về null để ẩn AppBar khi currentIndex == 4
          return SizedBox.shrink(); // Trả về một widget rỗng
        }

        final locationText =
            state is LocationSelected ? state.locationName : 'Loading...';
        return AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          elevation: 0,
          title: GestureDetector(
            onTap: () {
              CustomBottomSheet(
                child: Column(
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
                ),
              ).show(context);

              // Đảm bảo gọi hàm này sau khi showModalBottomSheet đã được hiển thị
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _callApiInBottomSheet(context);
              });
            },

            child: Row(
              children: [
                Text(
                  locationText,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),
        );
      },
    );
  }

  void _callApiInBottomSheet(BuildContext context) {
    context
        .read<HomeBloc>()
        .add(FetchLocations()); // Gọi API chỉ khi chưa có dữ liệu
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
