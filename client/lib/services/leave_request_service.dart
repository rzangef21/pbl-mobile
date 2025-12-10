import 'package:dio/dio.dart';
import 'package:client/utils/api_wrapper.dart';
import 'package:client/utils/constant.dart';
import 'package:client/models/leave_type_model.dart';
import 'package:client/models/leave_request_model.dart';

class LeaveRequestService {
  LeaveRequestService._();
  static final LeaveRequestService instance = LeaveRequestService._();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Constant.apiUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) => true,
    ),
  );

  /// GET list jenis izin
  Future<ApiResponse<List<LeaveType>>> getLeaveTypes() async {
    try {
      final res = await _dio.get('/letter-formats');

      if (res.statusCode == 200 && res.data['success'] == true) {
        List<LeaveType> list = (res.data['data'] as List)
            .map((e) => LeaveType.fromJson(e))
            .toList();

        return ApiResponse<List<LeaveType>>(
          message: "Berhasil memuat data",
          success: true,
          data: list,
        );
      }

      return ApiResponse<List<LeaveType>>(
        message: res.data['message'] ?? "Gagal memuat data",
        success: false,
        data: null,
      );
    } catch (e) {
      return ApiResponse<List<LeaveType>>(
        message: e.toString(),
        success: false,
        data: null,
      );
    }
  }

  /// POST pengajuan izin
  Future<ApiResponse<String>> submitLeave(LeaveRequestPayload payload) async {
    try {
      final res = await _dio.post('/letters', data: payload.toJson());

      if (res.statusCode == 201 && res.data['success'] == true) {
        return ApiResponse<String>(
          message: res.data['message'] ?? "Berhasil mengajukan izin",
          success: true,
          data: null,
        );
      }

      return ApiResponse<String>(
        message: res.data['message'] ?? "Gagal mengajukan izin",
        success: false,
        data: null,
      );
    } catch (e) {
      return ApiResponse<String>(
        message: e.toString(),
        success: false,
        data: null,
      );
    }
  }
}
