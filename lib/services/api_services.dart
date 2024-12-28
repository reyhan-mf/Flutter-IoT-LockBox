import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://10.0.2.2/locker_api";

  Future<Map<String, dynamic>> login(String email, String password) async {
    print('Sending request to: $baseUrl/auth/register.php');

    final response = await http.post(
      Uri.parse("$baseUrl/auth/login.php"),
      body: {'email': email, 'password': password},
    );
    print(response.body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to log in");
    }
  }

  // Logout user void
  Future<void> logout() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/auth/logout.php'));
      if (response.statusCode == 200) {
        print('User logged out');
      } else {
        throw Exception('Failed to log out');
      }
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }

  Future<void> updateRentalStatus(String lockerId, String rentalId) async {
    final url = Uri.parse(
        '$baseUrl/locker/update_rental.php'); // Ganti dengan URL API Anda
    try {
      final response = await http.post(
        url,
        body: {
          'locker_id': lockerId,
          'rental_id': rentalId,
        },
      );
      print('Response status code dari update rental: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          print('Rental updated successfully: ${responseData['message']}');
        } else {
          print('Failed to update rental: ${responseData['message']}');
        }
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating rentals status: $error');
    }
  }

  Future<List<dynamic>> getUserRented({required int userId}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/locker/user_rented.php'),
        body: {
          'user_id': userId.toString(),
        },
      );

      print("print dari service.dart, response.body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['data'] != null) {
          return decoded['data']; // Return the list of lockers
        } else {
          return []; // Return empty list if 'data' key is null
        }
      } else {
        throw Exception('Failed to get user rented lockers');
      }
    } catch (e) {
      print('Error during getting user rented lockers: $e');
      rethrow;
    }
  }

  Future<Map<dynamic, dynamic>> rentLocker(
      {required int userId,
      required int lockerId,
      required int durationTime,
      required int price}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/locker/rent_locker.php'),
        body: {
          'user_id': userId.toString(), // Convert to String
          'locker_id': lockerId.toString(), // Convert to String
          'duration': durationTime.toString(), // Convert to String
          'price': price.toString(), // Convert to String
        },
      );
      print("Print dari rent locker: ${response.body}");
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to rent locker');
      }
    } catch (e) {
      print('Error during renting locker: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updatePassword(
      {required int userId,
      required String oldPassword,
      required String newPassword}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/update_password.php'),
        body: {
          'user_id': userId.toString(),
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );
      print("Print dari edit password: ${response.body}");
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update password');
      }
    } catch (e) {
      print('Error during updating membership: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateMembership({required int userId}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/update_membership.php'),
        body: {
          'user_id': userId.toString(),
        },
      );
      print("Print dari edit membership: ${response.body}");
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update membership');
      }
    } catch (e) {
      print('Error during updating membership: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateProfile(
      {required int userId,
      required String name,
      required String number}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/update_profile.php'),
        body: {
          'user_id': userId.toString(),
          'name': name,
          'phone': number,
        },
      );
      print("Print dari edit profile: ${response.body}");
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print('Error during updating profile: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      print('Sending request to: $baseUrl/auth/register.php');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register.php'),
        body: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 409) {
        throw Exception("User already exists");
      } else {
        throw Exception(
            "Failed to register user. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error during registration: $e');
      rethrow;
    }
  }

  // Read Locker Data
  Future<Map<String, dynamic>> readLocker() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/locker/locker_available.php'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to read locker data');
      }
    } catch (e) {
      print('Error during reading locker data: $e');
      rethrow;
    }
  }
}
