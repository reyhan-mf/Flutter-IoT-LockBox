import 'package:lockboxx/model/user_model.dart';
import 'package:lockboxx/services/api_services.dart';

class UserController {
  final ApiService _apiService = ApiService();

  Future<User?> login(String email, String password) async {
    try {
      print(email);
      print(password);
      final data = await _apiService.login(email, password);
      print("Print from user_controller.dart: $data");
      if (data['success'] == true) {
        print("Returning Model Data");
        print(User.fromJson(data["data"]));
        return User.fromJson(data["data"]);
      }
    } catch (e) {
      print("Login failed: $e");
    }
    return null;
  }

  Future<bool> logout() async {
    try {
      await _apiService.logout();
      return true;
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }
}
