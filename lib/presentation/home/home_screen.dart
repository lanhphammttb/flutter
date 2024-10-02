import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nttcs/presentation/device/device_screen.dart';
import 'package:nttcs/presentation/information/information_screen.dart';
import 'package:nttcs/presentation/news/news_screen.dart';
import 'package:nttcs/presentation/overview/overview_screen.dart';
import 'package:nttcs/presentation/schedule/schedule_screen.dart';
import 'package:nttcs/widgets/search_field.dart';
import 'package:nttcs/widgets/tree_node_widget.dart';
import 'bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Widget> _pages = const <Widget>[
    OverviewScreen(),
    DeviceScreen(), // Tab Device
    ScheduleScreen(),
    NewsScreen(),
    InformationScreen(),
  ];

  void _onItemTapped(BuildContext context, int index) {
    context.read<HomeBloc>().add(TabChanged(index));  // Dispatch event to BLoC
  }

  void _callApiInBottomSheet(BuildContext context) {
    final currentState = context.read<HomeBloc>().state;
    if (currentState is! LocationsSuccess) {
      context.read<HomeBloc>().add(FetchLocations()); // Only fetch if not already loaded
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return IndexedStack(
              index: state is TabIndexChanged ? state.tabIndex : 0,  // Default index
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
      title: GestureDetector(
        onTap: () {
          _callApiInBottomSheet(context); // Call API only if needed when opening the bottom sheet
          _showBottomSheet(context);
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final locationText = state is LocationSelected ? state.locationName : 'Loading...';
            return Row(
              children: [
                Text(
                  locationText,  // Display the selected location name or loading text
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Make background transparent to allow rounded borders
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.87, // Set height to 85% of the screen
          decoration: const BoxDecoration(
            color: Colors.white, // BottomSheet background color
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
                  initialChildSize: 1.0, // Use full height within the container
                  minChildSize: 0.1,
                  maxChildSize: 1.0,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return Column(
                      children: [
                        _buildSearchField(context),
                        Expanded(
                          child: BlocBuilder<HomeBloc, HomeState>(
                            builder: (context, state) {
                              if (state is LocationsLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is LocationsSuccess) {
                                return TreeNodeWidget(
                                  treeNodes: state.treeNodes,
                                  onItemClick: (node) {
                                    context.read<HomeBloc>().add(SelectLocation(node.name));
                                    context.read<HomeBloc>().add(ExpandNode(node));
                                    Navigator.pop(context);  // Close the bottom sheet after selection
                                  },
                                );
                              } else if (state is LocationsFailure) {
                                return Center(
                                  child: Text('Failed to load locations: ${state.error}'),
                                );
                              } else {
                                return const Center(
                                  child: Text('No data available'),
                                );
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
      onChanged: (value) => context.read<HomeBloc>().add(SearchTextChanged(value)),
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
          currentIndex: currentIndex,  // Get index from BLoC state
          onTap: (index) => _onItemTapped(context, index),  // Dispatch tab change event
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
