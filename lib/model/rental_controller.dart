import 'package:lockboxx/services/api_services.dart';

class RentalController {
  final ApiService _apiService = ApiService();

  // Rent
  Future<Map<dynamic, dynamic>> rentLocker(
      {required int userId,
      required int lockerId,
      required int durationTime,
      required int price}) async {
    try {
      final response = await _apiService.rentLocker(
          userId: userId,
          lockerId: lockerId,
          durationTime: durationTime,
          price: price);
      return response;
    } catch (e) {
      print('Error renting locker: $e');
      rethrow;
    }
  }
}
