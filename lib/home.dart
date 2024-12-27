import 'package:flutter/material.dart';
import 'package:lockboxx/controller/locker_controller.dart';
import 'package:lockboxx/model/locker_model.dart';
import 'package:lockboxx/model/rental_controller.dart';
import 'package:lockboxx/model/user_model.dart';
import 'package:lockboxx/navigation.dart';
import 'package:lockboxx/rent.dart';
import 'package:lockboxx/theme.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key, required this.user});

  final LockerController lockerController = LockerController();
  final RentalController rentalController = RentalController();
  final User user;

  Future<List<Locker>> _fetchLockers() async {
    try {
      final response = await lockerController.getLockers(); // Fetch data
      print("Response dari HomePage: $response");
      if (response['success'] == true) {
        List<dynamic> data = response['data'];
        return data.map((json) => Locker.fromJson(json)).toList();
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      print(Exception("Gagal load lockers: $e"));
      throw Exception("Failed to load lockers: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 8),
            const Text(
              'Lockbox',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Locker>>(
        future: _fetchLockers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No lockers available.'));
          }

          final lockers = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  "Hi, ${user.name}, ${user.membershipType}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pilih Box Kamu!',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 30),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 230,
                  ),
                  itemCount: lockers.length,
                  itemBuilder: (context, index) {
                    final locker = lockers[index];
                    final isAvailable = locker.status == "AVAILABLE";
                    // Fuzzy From Flask
                    const int premiumPrice = 500;
                    const int basicPrice = 1500;
                    return GestureDetector(
                      onTap: () {
                        if (isAvailable) {
                          // Bottom sheet for available box
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            builder: (context) {
                              int selectedDuration =
                                  1; // Default duration (1 hour)
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Container(
                                    padding: const EdgeInsets.all(25),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Locker ${locker.lockerId}',
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Basic',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  'Rp$basicPrice/jam',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                const Text(
                                                  'Premium',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: kPrimaryColor,
                                                  ),
                                                ),
                                                const Text(
                                                  'Rp$premiumPrice/jam',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: const Text(
                                                    'Best Value!',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          'Select Duration',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1B383A),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Styled Dropdown
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: kPrimaryColor),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<int>(
                                              value: selectedDuration,
                                              items: List.generate(
                                                5,
                                                (index) => DropdownMenuItem(
                                                  value: index + 1,
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.access_time,
                                                          color: kPrimaryColor),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                          '${index + 1} hour${index + 1 > 1 ? 's' : ''}'),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                if (value != null) {
                                                  setState(() {
                                                    selectedDuration = value;
                                                  });
                                                }
                                              },
                                              isExpanded: true,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (user.membershipType == "BASIC") ...[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Align(
                                              alignment: Alignment
                                                  .centerRight, // Aligns the text to the right
                                              child: Text(
                                                'Totals: ${selectedDuration * basicPrice}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ] else ...[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Align(
                                              alignment: Alignment
                                                  .centerRight, // Aligns the text to the right
                                              child: Text(
                                                'Totals: ${selectedDuration * premiumPrice}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],

                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (user.membershipType ==
                                                "BASIC") {
                                              final rent =
                                                  await rentalController
                                                      .rentLocker(
                                                          lockerId:
                                                              locker.lockerId,
                                                          userId: user.userId,
                                                          durationTime:
                                                              selectedDuration,
                                                          price:
                                                              selectedDuration *
                                                                  basicPrice);
                                              if (rent['success'] == true) {
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Berhasil! Durasi $selectedDuration jam untuk Locker ${locker.lockerId} harga ${selectedDuration * basicPrice} (BASIC) '),
                                                  ),
                                                );
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MainPage(user: user, index: 1,),
                                                  ),
                                                );
                                                print(
                                                    'Print dari home.dart data dari api rent: $rent');
                                              } else {
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    backgroundColor: Colors.red,
                                                    content: Text('Gagal!   '),
                                                  ),
                                                );
                                                print(
                                                    'Print dari home.dart data dari api rent: $rent');
                                              }
                                            } else if (user.membershipType ==
                                                "PREMIUM") {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Durasi $selectedDuration jam untuk Locker ${locker.lockerId} harga: ${selectedDuration * premiumPrice} (PREMIUM) '),
                                                ),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kPrimaryColor,
                                            minimumSize:
                                                const Size(double.infinity, 60),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 32,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: const Text(
                                            'Rent Now',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          // Dialog for unavailable box
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  'Locker Already Rented',
                                  style: TextStyle(fontSize: 20),
                                ),
                                content: Text(
                                  'Locker ${locker.number} has been rented.',
                                  style: const TextStyle(color: kPrimaryColor),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isAvailable
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${locker.number}',
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  isAvailable ? Icons.lock_open : Icons.lock,
                                  size: 24,
                                  color: isAvailable
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isAvailable ? 'Available' : 'Occupied',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
