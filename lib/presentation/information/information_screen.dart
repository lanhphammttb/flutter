import 'package:flutter/material.dart';
import 'package:nttcs/core/app_export.dart';
import 'package:nttcs/presentation/information/bloc/information_bloc.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<InformationBloc, InformationState>(
            builder: (context, state) {
              if (state is InformationLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is InformationLoaded) {
                final data = state.data.items;
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 30),
                          Center(
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey[300],
                              child: Icon(Icons.person,
                                  size: 60, color: Colors.grey[600]),
                            ),
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: Text(
                              data?.userName??'',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Tên đầy đủ: ${data?.fullName??''}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Email: ${data?.email??''}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Số điện thoại: ${data?.phone??''}',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                           Text(
                            'Xác thực 2 lớp: ${data?.isGoogle == true ? 'Có' : 'Không'}',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                           Text(
                            'Địa chỉ: ${data?.address??''}',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Code to handle update action
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  label: Text('Cập nhật',
                                      style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange),
                                ),
                                SizedBox(width: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Code to handle logout action
                                  },
                                  icon:
                                      Icon(Icons.exit_to_app, color: Colors.white),
                                  label: Text('Đăng xuất',
                                      style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'Mã QR xác thực 2 lớp',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Icon(Icons.qr_code, size: 150),
                                SizedBox(height: 8),
                                IconButton(
                                  icon: Icon(Icons.refresh),
                                  onPressed: () {
                                    // Code to refresh QR code
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text('Failed to load data'));
              }
        }),
      ),
    );
  }
}
