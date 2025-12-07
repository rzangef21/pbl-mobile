import 'package:client/models/leave_report_model.dart';
import 'package:client/utils/api_wrapper.dart';
import 'package:client/utils/constant.dart';
import 'package:client/services/base_service.dart';

class LeaveReportService extends BaseService<LeaveReportResponse> {
  Future<ApiResponse<LeaveReportResponse>> getDashboard() async {
    try {
      final res = await dio.get("${Constant.apiUrl}/izin-dashboard");

      return ApiResponse.fromJson(
        res.data,
        (raw) => LeaveReportResponse.fromJson(raw as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse(
        message: "Gagal memuat data dashboard",
        success: false,
        data: null,
        error: e.toString(),
      );
    }
  }
}
