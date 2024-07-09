import 'package:flutter/material.dart';
import 'package:nttcs/core/app_export.dart'; // Assuming this contains necessary theming and utility classes
import 'package:nttcs/presentation/home/bloc/home_bloc.dart';
import 'package:nttcs/widgets/custom_search_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<HomeBloc>().add(SearchTextChanged(_controller.text));
  }

  void _onItemTapped(int index) {
    context.read<HomeBloc>().add(ItemTapped(index));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: appTheme.bg_gray,
          resizeToAvoidBottomInset: false,
          body: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                CustomSearchView(
                  controller: _controller,
                  hintText: 'placeholder_search'.tr,
                ),

                Expanded(
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is SearchLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is SearchSuccess) {
                        return ListView.builder(
                          itemCount: state.results.length,
                          itemBuilder: (context, index) =>
                              ListTile(
                                title: Text(state.results[index]),
                              ),
                        );
                      } else if (state is SearchFailure) {
                        return Center(child: Text("Error: ${state.error}"));
                      }
                      return const Center(child: Text(
                          "Enter a search term to start searching"));
                    },
                  ),
                ),
                SizedBox(height: 10.v),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildText(
                    context,
                    userFive: ImageConstant.imageNotFound,
                    tipsngvovone: '',
                    urlhttpsvovone: '',
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar:
          BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                int selectedIndex = 0;
                if (state is ItemSelected) {
                  selectedIndex = state.selectedIndex;
                }
                return BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Trang chủ',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.business),
                      label: 'Business',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.school),
                      label: 'School',
                    ),
                  ],
                  currentIndex: selectedIndex,
                  selectedItemColor: Colors.amber[800],
                  onTap: _onItemTapped,
                );
              })
      ),
    );
  }

  Widget _buildText(BuildContext context, {
    required String userFive,
    required String tipsngvovone,
    required String urlhttpsvovone,
    Function? onTapUrlhttpsvovone1,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Row(
        children: [
          CustomImageView(
            imagePath: userFive,
            height: 24.v,
            width: 32.h,
          ),
          SizedBox(width: 16.h),
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(
                top: 8.v,
                bottom: 6.v,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tipsngvovone,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: appTheme.bg_gray,
                    ),
                  ),
                  SizedBox(height: 2.v),
                  GestureDetector(
                    onTap: () {
                      onTapUrlhttpsvovone1?.call();
                    },
                    child: Text(
                      urlhttpsvovone,
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: appTheme.bg_gray,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
