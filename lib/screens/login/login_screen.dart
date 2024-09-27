import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/login/login_bloc.dart';
import '../../data/repositories/user_repository.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository userRepository;

  const LoginScreen({super.key, required this.userRepository});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Biến để theo dõi trạng thái ẩn/hiện mật khẩu
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: BlocProvider(
              create: (context) => LoginBloc(widget.userRepository),
              child: BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state.isFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đăng nhập thất bại')),
                    );
                  }
                  if (state.isSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đăng nhập thành công')),
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // Đặt các phần tử ở giữa
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Điều chỉnh căn lề trái
                  children: <Widget>[
                    // Logo công ty
                    Center(
                      // Đặt logo ở giữa
                      child: Image.asset(
                        'assets/images/logo_vtc_trans.png',
                        // Đường dẫn đến logo của bạn
                        height: 180,
                        width: 250,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Tiêu đề Hệ thống thông tin
                    Center(
                      // Đặt tiêu đề ở giữa
                      child: Column(
                        children: [
                          Text(
                            'HỆ THỐNG THÔNG TIN NGUỒN CẤP TỈNH',
                            style: TextStyle(
                              fontSize: 16, // Chỉnh font cho tiêu đề lớn hơn
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0056A4), // Màu xanh dương đậm
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'TỔNG CÔNG TY TRUYỀN THÔNG ĐA PHƯƠNG TIỆN - VTC',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(
                                  0xFF0056A4), // Màu xám cho phần mô tả nhỏ
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),

                    // Trường nhập liệu tên tài khoản
                    Text(
                      'Tên tài khoản', // Nhãn của trường nhập
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold, // In đậm nhãn
                        color: Colors.black, // Màu đen cho nhãn
                      ),
                    ),
                    SizedBox(height: 5),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey),
                            hintText: 'Nhập tên tài khoản',
                            // Placeholder
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            // Điều chỉnh padding
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              // Bo góc
                              borderSide: BorderSide(
                                  color:
                                      Colors.grey), // Đường viền màu xám nhạt
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                  color: Colors
                                      .grey), // Màu viền khi không tương tác
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                  color: Color(0xFF0056A4),
                                  width: 1.0), // Màu viền khi focus
                            ),
                            prefixIcon: Icon(Icons.person, color: Colors.grey),
                            errorText: !state.isValidUsername &&
                                    _usernameController.text.isNotEmpty
                                ? 'Tên tài khoản không được để trống'
                                : null,
                          ),
                          onChanged: (value) {
                            context
                                .read<LoginBloc>()
                                .add(LoginUsernameChanged(value));
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20),

                    // Trường nhập liệu mật khẩu
                    Text(
                      'Mật khẩu', // Nhãn của trường nhập
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold, // In đậm nhãn
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          // Hiển thị/ẩn mật khẩu
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey),
                            hintText: 'Nhập mật khẩu',
                            // Placeholder
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            // Điều chỉnh padding
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                  color: Colors.grey), // Màu viền xám
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                  color: Colors
                                      .grey), // Màu viền khi không tương tác
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                  color: Color(0xFF0056A4),
                                  width: 1.0), // Màu viền khi focus
                            ),
                            prefixIcon: Icon(Icons.lock, color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            errorText: !state.isValidPassword &&
                                    _passwordController.text.isNotEmpty
                                ? 'Mật khẩu không được để trống'
                                : null,
                          ),
                          onChanged: (value) {
                            context
                                .read<LoginBloc>()
                                .add(LoginPasswordChanged(value));
                          },
                        );
                      },
                    ),
                    SizedBox(height: 30),

                    // Nút Đăng nhập
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                state.isValidUsername && state.isValidPassword
                                    ? () {
                                        context
                                            .read<LoginBloc>()
                                            .add(LoginSubmitted());
                                      }
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0056A4),
                              // Màu xanh dương đậm
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Tăng độ bo góc cho nút
                              ),
                            ),
                            child: state.isSubmitting
                                ? CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  )
                                : Text(
                                    'Đăng nhập',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white, // Màu chữ trắng
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
