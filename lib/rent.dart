import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lockboxx/model/user_model.dart';
import 'package:lockboxx/services/api_services.dart';

class RentPage extends StatefulWidget {
  const RentPage({super.key, required this.user});

  final User user;

  @override
  State<RentPage> createState() => _RentPageState();
}

class _RentPageState extends State<RentPage> {
  late Future<List<dynamic>> userRentals;
  late List<dynamic> activeRentals;
  Timer? _timer;

  Future<List<dynamic>> fetchUserRent() async {
    final ApiService apiService = ApiService();
    final response = await apiService.getUserRented(userId: widget.user.userId);

    // Hitung remaining_seconds berdasarkan waktu sekarang dan end_time
    final now = DateTime.now();
    return response.map((rental) {
      final endTime = DateTime.parse(rental['end_time']);
      final remainingSeconds =
          endTime.isAfter(now) ? endTime.difference(now).inSeconds : 0;

      return {
        ...rental,
        'remaining_seconds':
            remainingSeconds, // Tambahkan properti remaining_seconds
      };
    }).toList();
  }

  void startCountdown() {
    final ApiService apiService = ApiService();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        for (var rental in activeRentals) {
          if (rental['remaining_seconds'] > 0) {
            rental['remaining_seconds'] -= 1;
          } else if (rental['remaining_seconds'] == 0 &&
              rental['rental_status'] == "ACTIVE") {
            // Update status rental ke API
            apiService.updateRentalStatus(
              rental['locker_id'].toString(),
              rental['rental_id'].toString(),
            );
            // Ubah status di aplikasi menjadi "COMPLETED"
            rental['rental_status'] = "COMPLETED";
          }
        }
      });
    });
  }

  String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    userRentals = fetchUserRent().then((data) {
      activeRentals = data.where((rental) => rental['is_active'] == 1).toList();

      if (activeRentals.isNotEmpty) {
        startCountdown();
      }
      return data;
    }).catchError((error) {
      print("Error fetching rentals: $error");
      return [];
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            const SizedBox(width: 14),
            Image.asset(
              'assets/images/logo.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 8),
            const Text('Lockbox',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: userRentals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No lockers rented.'),
            );
          } else {
            if (activeRentals.isEmpty) {
              return const Center(
                child: Text('No active lockers rented.'),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Your Rented Locker',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activeRentals.length,
                    itemBuilder: (context, index) {
                      final rental = activeRentals[index];
                      final remainingTime = rental['remaining_seconds'] as int;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xffE3F0AF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lock,
                              color: Colors.green.shade400,
                              size: 50,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Locker ID: ${rental['locker_id'] ?? 'N/A'}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Duration Left: ${formatDuration(remainingTime)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Access Code: ${rental['code'] ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
