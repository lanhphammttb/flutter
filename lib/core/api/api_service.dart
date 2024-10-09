import 'package:dio/dio.dart';
import 'package:nttcs/data/auth_local_data_source.dart';
import 'package:nttcs/data/dtos/login_dto.dart';
import 'package:nttcs/data/dtos/login_success_dto.dart';
import 'package:nttcs/data/dtos/register_dto.dart';
import 'package:nttcs/data/models/content.dart';
import 'package:nttcs/data/models/device.dart';
import 'package:nttcs/data/models/device2.dart';
import 'package:nttcs/data/models/information.dart';
import 'package:nttcs/data/models/schedule.dart';
import 'package:nttcs/data/models/location.dart';
import 'package:nttcs/data/models/res_overview.dart';
import 'package:nttcs/data/models/schedule_date.dart';
import 'package:nttcs/data/models/schedule_request.dart';
import 'package:nttcs/data/models/specific_response.dart';
import 'package:nttcs/data/models/specific_status_reponse.dart';
import 'package:nttcs/data/models/user.dart';
import 'package:nttcs/data/result_type.dart';
import 'package:nttcs/core/constants/constants.dart';
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

        await authLocalDataSource.saveString(
            AuthDataConstants.token, result.token);
        await authLocalDataSource.saveString(
            AuthDataConstants.code,
            userData.items.isNotEmpty
                ? userData.items[0].code
                : null as String);
        await authLocalDataSource.saveString(
            AuthDataConstants.name,
            userData.items.isNotEmpty
                ? userData.items[0].name
                : null as String);
        await authLocalDataSource.saveInt(AuthDataConstants.id,
            userData.items.isNotEmpty ? userData.items[0].id : null as int);

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
          AuthDataConstants.selectCode,
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
      String token = await authLocalDataSource.getToken() as String;
      int siteId = await authLocalDataSource.getSiteId() as int;
      final response =
          await dio.get('Device/sitemapid', token: token, queryParameters: {
        'SiteMapId': siteMapId,
        'SiteId': siteId,
        'Type': 'IPRADIO',
        'Page': page,
        'Size': 1000
      });

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

  Future<SpecificResponse<Device2>> getDevice2(String token) async {
    try {
      final response = await dio.post(
        'Device/list',
        token: token,
        data: {
          'Type': "IPRADIO",
          'Code': "H39",
          'Province': "H39",
          'Page': 1,
          'Size': 1000,
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
      String token = await authLocalDataSource.getToken() as String;
      String code = await authLocalDataSource.getCode() as String;
      String selectCode = await authLocalDataSource.getSelectCode() as String;
      final response = await dio.get(
        'SourceData/code',
        token: token,
        queryParameters: {
          'Code': selectCode,
          'Province': code,
        },
      );

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

  Future<SpecificResponse<Location>> getLocations(String token) async {
    try {
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

  Future<SpecificResponse<Schedule>> getSchedules(String token) async {
    try {
      final response = await dio.post(
        'Schedule/data',
        token: token,
        data: {
          'Type': 'IPRADIO',
          'SiteId': '5',
          'SiteMapIds': [769, 770, 771, 772, 773, 774, 775, 776, 777, 778],
          'Page': 1,
          'Size': 1000,
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

  Future<SpecificStatusResponse<Schedule>> createSchedule(
      String token,
      int locationSelected,
      String name,
      List<ScheduleDate> scheduleDates,
      List<Device> devices,
      int id) async {
    try {
      // Map devices to device IDs
      List<int> deviceIds = devices.map((device) => device.id).toList();

      // Map schedule dates to the required format
      List<ScheduleDate> formatSchedules = scheduleDates.map((scheduleDate) {
        List<SchedulePlaylistTime> playlistTimes =
            scheduleDate.schedulePlaylistTimes.map((playlistTime) {
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

  Future<SpecificResponse<Content>> getNews(String token) async {
    try {
      final response = await dio.get(
        'content/publish/list',
        token: token,
        queryParameters: {
          'contentType': 3,
          'code': 'H39',
          'page': 1,
          'size': 1000,
        },
      );

      return SpecificResponse<Content>.fromJson(
        response.data,
        (item) => Content.fromJson(item as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<SpecificStatusResponse<Information>> getInformation(
      String token) async {
    try {
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

  Future<SpecificStatusResponse<dynamic>> controlDevice(
      String token, int siteId, int maLenh, int thamSo) async {
    try {
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
          'CumLoaID': [1],
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
}
