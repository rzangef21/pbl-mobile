import 'package:client/models/position_model.dart';
import 'package:client/services/base_service.dart';
import 'package:client/utils/api_wrapper.dart';

class PositionService extends BaseService {
  PositionService._();

  static PositionService instance = PositionService._();

  Future<ApiResponse<List<PositionModel>>> getPositions() async {
    final response = await dio.get("/positions");
    final json = response.data;

    final rawPositions = json["data"] as List;
    final positions = rawPositions.map((item) {
      return PositionModel.fromJson(item);
    }).toList();

    return ApiResponse<List<PositionModel>>(
      message: json["message"],
      success: json["success"],
      data: positions,
      error: json["error"],
    );
  }
}
