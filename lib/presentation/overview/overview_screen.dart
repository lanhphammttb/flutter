import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nttcs/core/app_export.dart';
import 'dart:async';
import 'bloc/overview_bloc.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OverviewBloc, OverviewState>(
        listener: (context, state) {
          if (state is OverviewLoaded || state is OverviewUpdating) {
            // Start the timer to fetch data periodically
            Timer.periodic(const Duration(minutes: 1), (timer) {
              context.read<OverviewBloc>().add(const FetchOverview());
            });
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<OverviewBloc>().add(const FetchOverview());
          },
          child: BlocBuilder<OverviewBloc, OverviewState>(
            builder: (context, state) {
              if (state is OverviewLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OverviewLoaded || state is OverviewUpdating) {
                final data = (state is OverviewLoaded)
                    ? state.data
                    : (state as OverviewUpdating).data;
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildStatusCard(
                            color: appTheme.primary,
                            icon: Icons.volume_up,
                            title: 'CỤM THU PHÁT THANH',
                            value: '${data.items[0].on + data.items[0].off}',
                          ),
                          const SizedBox(height: 16),
                          _buildStatusCard(
                            color: Colors.green,
                            icon: Icons.volume_up,
                            title: 'ĐANG PHÁT',
                            value: data.items[0].play.toString(),
                          ),
                          const SizedBox(height: 16),
                          _buildStatusCard(
                            color: Colors.lightBlue,
                            icon: Icons.wifi,
                            title: 'ĐANG KẾT NỐI',
                            value: data.items[0].on.toString(),
                          ),
                          const SizedBox(height: 16),
                          _buildStatusCard(
                            color: Colors.orange,
                            icon: Icons.wifi_off,
                            title: 'MẤT KẾT NỐI',
                            value: data.items[0].off.toString(),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Thời gian cập nhật: ${DateFormat('HH:mm:ss - dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(data.items[0].modifyDate * 1000))}',
                            style: CustomTextStyles.bodyMediumSecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (state is OverviewError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text('No data available'));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required Color color,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      key: ValueKey(title),  // Thêm key để tối ưu render
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(width: 16),
              Text(
                title.tr.toUpperCase(),
                style: CustomTextStyles.titleOverview,
              ),
            ],
          ),
          Text(
            value,
            style: CustomTextStyles.countOverview,
          ),
        ],
      ),
    );
  }
}