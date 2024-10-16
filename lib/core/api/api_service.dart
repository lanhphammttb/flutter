import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:nttcs/core/constants/constants.dart';
import 'package:nttcs/data/auth_local_data_source.dart';
import 'package:nttcs/data/dtos/login_dto.dart';
import 'package:nttcs/data/dtos/login_success_dto.dart';
import 'package:nttcs/data/dtos/register_dto.dart';
import 'package:nttcs/data/models/content.dart';
import 'package:nttcs/data/models/device.dart';
import 'package:nttcs/data/models/device2.dart';
import 'package:nttcs/data/models/information.dart';
import 'package:nttcs/data/models/location.dart';
import 'package:nttcs/data/models/res_overview.dart';
import 'package:nttcs/data/models/schedule.dart';
import 'package:nttcs/data/models/schedule_date.dart';
import 'package:nttcs/data/models/schedule_request.dart';
import 'package:nttcs/data/models/specific_response.dart';
import 'package:nttcs/data/models/specific_status_reponse.dart';
import 'package:nttcs/data/models/user.dart';

import 'dio_client.dart';

class AuthApiClient {
  AuthApiClient(this.dio, this.authLocalDataSource);

  final DioClient dio;
  final AuthLocalDataSource authLocalDataSource;

  Future<bool> login(LoginDto loginDto) async {
    try {
      // Gửi yêu cầu đăng nhập
      final response = await dio.post(
        '/Auth/KToken',
        data: loginDto.toJson(),
      );

      final result = LoginSuccessDto.fromJson(response.data);

      if (result.code == 1) {
        final userData = await getUser(result.token);

        await authLocalDataSource.saveString(Constants.token, result.token);
        await authLocalDataSource.saveString(Constants.code, userData.items.isNotEmpty ? userData.items[0].code : '');
        await authLocalDataSource.saveString(Constants.name, userData.items.isNotEmpty ? userData.items[0].name : '');
        await authLocalDataSource.saveInt(Constants.id, userData.items.isNotEmpty ? userData.items[0].id : 0);

        return userData.status;
      } else {
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<void> register(RegisterDto registerDto) async {
    try {
      await dio.post(
        '/auth/register',
        data: registerDto.toJson(),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<SpecificResponse<User>> getUser(String token) async {
    try {
      final response = await dio.get(
        'site',
        token: token,
      );

      final result = SpecificResponse<User>.fromJson(
        response.data,
        (item) => User.fromJson(item as Map<String, dynamic>),
      );

      if (result.items.isNotEmpty) {
        authLocalDataSource.saveString(
          Constants.selectCode,
          result.items[0].code,
        );
      }

      return result;
    } on DioException catch (e) {
      // Xử lý lỗi từ DioException
      final errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception(errorMessage);
    } catch (e) {
      // Xử lý lỗi chung
      throw Exception('An error occurred: $e');
    }
  }

  Future<SpecificResponse<Device>> getDevice(int siteMapId, int page) async {
    try {
      final [token, siteId] = authLocalDataSource.getValue([Constants.token, Constants.id]);
      final response = await dio.get('Device/sitemapid', token: token, queryParameters: {'SiteMapId': siteMapId, 'SiteId': siteId, 'Type': 'IPRADIO', 'Page': page, 'Size': Constants.pageSize});

      return SpecificResponse<Device>.fromJson(
        response.data,
        (item) => Device.fromJson(item as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<SpecificResponse<Device2>> getDevice2(int page, int reload) async {
    try {
      final [token, code, selectCode] = authLocalDataSource.getValue([Constants.token, Constants.code, Constants.selectCode]);
      final response = await dio.post(
        'Device/list',
        token: token,
        data: {
          'Type': "IPRADIO",
          'Code': selectCode,
          'Province': code,
          'Page': page,
          'Size': Constants.pageSize * reload,
        },
      );

      return SpecificResponse<Device2>.fromJson(
        response.data,
        (item) => Device2.fromJson(item as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<SpecificResponse<ResOverview>> getOverview() async {
    try {
      final stopwatch = Stopwatch()..start();

      final [token, code, selectCode] = authLocalDataSource.getValue([Constants.token, Constants.code, Constants.selectCode]);
      final response = await dio.get(
        'SourceData/code',
        token: token,
        queryParameters: {
          'Code': selectCode,
          'Province': code,
        },
      );

      log('API call duration: ${stopwatch.elapsedMicroseconds} µs');
      return SpecificResponse<ResOverview>.fromJson(
        response.data,
        (item) => ResOverview.fromJson(item as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<SpecificResponse<Location>> getLocations() async {
    try {
      final [token] = authLocalDataSource.getValue([Constants.token]);
      final response = await dio.get(
        'sitemap',
        token: token,
        queryParameters: {'SiteId': '5'},
      );

      return SpecificResponse<Location>.fromJson(
        response.data,
        (item) => Location.fromJson(item as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<SpecificResponse<Schedule>> getSchedules(int page, int reload) async {
    try {
      final [token, id] = authLocalDataSource.getValue([Constants.token, Constants.id]);
      final response = await dio.post(
        'Schedule/data',
        token: token,
        data: {
          'Type': 'IPRADIO',
          'SiteId': id,
          'SiteMapIds': [769, 770, 771, 772, 773, 774, 775, 776, 777, 778],
          'Page': page,
          'Size': Constants.pageSize * reload,
        },
      );

      return SpecificResponse<Schedule>.fromJson(
        response.data,
        (item) => Schedule.fromJson(item as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<SpecificStatusResponse<Schedule>> createSchedule(int locationSelected, String name, List<ScheduleDate> scheduleDates, List<Device> devices, int id) async {
    try {
      // Map devices to device IDs
      final [token] = authLocalDataSource.getValue([Constants.token]);
      List<int> deviceIds = devices.map((device) => device.id).toList();

      List<ScheduleDate> formatSchedules = scheduleDates.map((scheduleDate) {
        List<SchedulePlaylistTime> playlistTimes = scheduleDate.schedulePlaylistTimes.map((playlistTime) {
          List<Playlist> playlists = playlistTime.playlists.map((playlist) {
            return Playlist(
              id: playlist.id,
              order: playlist.order,
              mediaProjectId: playlist.mediaProjectId,
              thoiLuong: playlist.thoiLuong,
            );
          }).toList();

          return SchedulePlaylistTime(
            id: playlistTime.id,
            name: playlistTime.name,
            start: playlistTime.start,
            end: playlistTime.end,
            playlists: playlists,
          );
        }).toList();

        return ScheduleDate(
          id: scheduleDate.id,
          date: scheduleDate.date,
          schedulePlaylistTimes: playlistTimes,
        );
      }).toList();

      // Tạo request
      ScheduleRequest scheduleRequest = ScheduleRequest(
        name: name,
        id: id,
        attributes: '',
        siteId: 5,
        siteMapId: locationSelected,
        scheduleDates: formatSchedules,
        devices: deviceIds,
      );

      // Gửi yêu cầu POST
      final response = await dio.post(
        'Schedule/data',
        token: token,
        data: scheduleRequest.toJson(),
      );

      // Xử lý phản hồi từ API
      return SpecificStatusResponse<Schedule>.fromJson(
        response.data,
        (item) => Schedule.fromJson(item as Map<String, dynamic>),
      );
    } catch (e) {
      // Xử lý lỗi trong quá trình gọi API hoặc chuyển đổi dữ liệu
      throw Exception('An error occurred: $e');
    }
  }

  Future<SpecificResponse<Content>> getNews(int contentType, int page, int reload) async {
    try {
      final [token, code] = authLocalDataSource.getValue([Constants.token, Constants.code]);
      final response = await dio.get(
        'content/publish/list',
        token: token,
        queryParameters: {
          'contentType': contentType,
          'code': code,
          'page': page,
          'size': Constants.pageSize * reload,
        },
      );

      return SpecificResponse<Content>.fromJson(
        response.data,
        (item) => Content.fromJson(item as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<SpecificStatusResponse<Information>> getInformation() async {
    try {
      final [token] = authLocalDataSource.getValue([Constants.token]);
      final response = await dio.get('User/info', token: token);

      return SpecificStatusResponse<Information>.fromJson(
        response.data,
        (item) => Information.fromJson(item as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<SpecificStatusResponse<dynamic>> controlDevice(int maLenh, int thamSo, List<String> devicesArray) async {
    try {
      final [token, siteId] = authLocalDataSource.getValue([Constants.token, Constants.id]);
      final response = await dio.post(
        'Device/command',
        token: token,
        data: {
          'Type': 'IPRADIO',
          'SiteMapId': 754,
          'SiteId': siteId,
          'MaLenh': maLenh,
          'ThamSo': thamSo,
          'Otp': '',
          'CumLoaID': devicesArray,
        },
      );

      return SpecificStatusResponse<dynamic>.fromJson(
        response.data,
        (item) => item,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<SpecificStatusResponse<dynamic>> playNow(List<String> devices, Content content) async {
    try {
      final [token, siteId, siteMapId] = authLocalDataSource.getValue([Constants.token, Constants.id, Constants.siteMapId]);
      final response = await dio.post(
        'Device/live',
        token: token,
        data: {
          'Type': 'IPRADIO',
          'SiteMapId': siteMapId,
          'SiteId': siteId,
          'MediaId': content.banTinId,
          'Duration': content.thoiLuong,
          'Otp': '',
          'CumLoaID': devices,
        },
      );

      return SpecificStatusResponse<dynamic>.fromJson(
        response.data,
            (item) => item,
      );
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
