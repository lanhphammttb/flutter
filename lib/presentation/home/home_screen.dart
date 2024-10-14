import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/presentation/device/bloc/device_bloc.dart';
import 'package:nttcs/presentation/device/device_screen.dart';
import 'package:nttcs/presentation/information/information_screen.dart';
import 'package:nttcs/presentation/news/bloc/news_bloc.dart';
import 'package:nttcs/presentation/news/news_screen.dart';
import 'package:nttcs/presentation/overview/bloc/overview_bloc.dart';
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
  late HomeBloc homeBloc;
  bool isLocationLoaded = false;

  @override
  void initState() {
    super.initState();
    homeBloc = context.read<HomeBloc>();
    homeBloc.add(const SelectLocation(locationName: ''));
  }

  final List<Widget> _pages = const <Widget>[
    OverviewScreen(),
    DeviceScreen(),
    ScheduleScreen(),
    NewsScreen(),
    InformationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _buildAppBar(context),
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listenWhen: (previous, current) => previous.locationName != current.locationName || previous.tabIndex != current.tabIndex,
        listener: (context, state) {
          switch (state.tabIndex) {
            case 0:
              context.read<OverviewBloc>().add(const FetchOverview());
              break;
            case 1:
              context.read<DeviceBloc>().add(const FetchDevices(0));
              break;
            case 2:
              context.read<ScheduleBloc>().add(FetchSchedule());
              break;
            case 3:
              context.read<NewsBloc>().add(const FetchNews(0));
              break;
            case 4:
              break;
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return IndexedStack(
              index: state.tabIndex,
              children: _pages,
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        int currentIndex = state.tabIndex;
        if (currentIndex == 4) {
          return SizedBox.shrink();
        }

        final locationText = state.locationName.isEmpty ? 'Loading...' : state.locationName;
        return AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.primary,
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
                          if (state.status == HomeStatus.loading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state.status == HomeStatus.success && state.treeNodes.isNotEmpty) {
                            isLocationLoaded = true;
                            return TreeNodeWidget(
                              treeNodes: state.treeNodes,
                              onItemClick: (node) {
                                homeBloc.add(SelectLocation(locationNode: node));
                                homeBloc.add(ExpandNode(node));
                                Navigator.pop(context);
                              },
                            );
                          } else if (state.status == HomeStatus.failure) {
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

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!isLocationLoaded) {
                  homeBloc.add(FetchLocations());
                }
              });
            },
            child: Row(
              children: [
                Text(locationText, style: const TextStyle(color: Colors.white, fontSize: 20)),
                const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.white),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return SearchField(
      hintSearch: 'Nhập tên địa điểm...',
      controller: TextEditingController(),
      onChanged: (value) => homeBloc.add(SearchTextChanged(value)),
      onClear: () => homeBloc.add(SearchTextChanged('')),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          currentIndex: state.tabIndex,
          onTap: (index) => homeBloc.add(TabChanged(index)),
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
