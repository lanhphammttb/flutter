import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/presentation/device/device_screen.dart';
import 'package:nttcs/presentation/information/information_screen.dart';
import 'package:nttcs/presentation/news/news_screen.dart';
import 'package:nttcs/presentation/overview/overview_screen.dart';
import 'package:nttcs/presentation/schedule/schedule_screen.dart';
import 'package:nttcs/presentation/device/bloc/device_bloc.dart';
import 'bloc/home_bloc.dart'; // Import BLoC của Device

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Cờ kiểm tra nếu tab Device đã gọi API chưa
  bool _isDeviceApiCalled = false;

  final List<Widget> _pages = <Widget>[
    OverviewScreen(),
    const DeviceScreen(), // Tab Device
    const ScheduleScreen(),
    const NewsScreen(),
    const InformationScreen(),
  ];

  // Hàm xử lý khi người dùng chọn tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      // N��u người dùng chọn tab Device (index = 1) và API chưa được gọi
      if (index == 1 && !_isDeviceApiCalled) {
        _callDeviceApi(); // Gọi API cho Device tab
        _isDeviceApiCalled = true; // Đánh dấu API đã được gọi
      }
    });
  }

  // Gọi API cho tab Device thông qua BLoC
  void _callDeviceApi() {
    final deviceBloc = context.read<DeviceBloc>(); // Lấy DeviceBloc từ ngữ cảnh
    deviceBloc.add(FetchDevices()); // Gửi sự kiện FetchDevices
  }

  // Gọi API khi mở bottom sheet
  void _callApiInBottomSheet() {
    final homeBloc = context.read<HomeBloc>(); // Lấy OverviewBloc từ ngữ cảnh
    homeBloc.add(FetchLocations()); // Gửi sự kiện FetchOverview
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          elevation: 0,
          title: GestureDetector(
            onTap: () {
              _callApiInBottomSheet(); // Gọi API khi mở bottom sheet
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is LocationsLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is LocationsSuccess) {
                        return ListView.builder(
                          itemCount: state.locations.data.length,
                          itemBuilder: (context, index) {
                            final location = state.locations.data[index];
                            return ListTile(
                              title: Text(location.name),
                              subtitle: Text(location.description),
                            );
                          },
                        );
                      } else if (state is LocationsFailure) {
                        return Center(child: Text('Failed to load locations: ${state.error}'));
                      } else {
                        return Center(child: Text('No data available'));
                      }
                    },
                  );
                },
              );
            },
            child: const Row(
              children: [
                Text(
                  'Tỉnh Long An',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
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
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}