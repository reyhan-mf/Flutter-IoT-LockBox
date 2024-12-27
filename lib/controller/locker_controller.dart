import 'package:lockboxx/services/api_services.dart';

class LockerController {
  final ApiService _apiService = ApiService();



  Future<Map<String, dynamic>> getLockers() async {
    try {
      final data = await _apiService.readLocker();
      return data;
    } catch (e) {
      print('Error getting lockers: $e');
      rethrow;
    }
  }
}