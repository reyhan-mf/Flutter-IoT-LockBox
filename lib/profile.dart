import 'package:flutter/material.dart';
import 'package:lockboxx/controller/user_controller.dart';
import 'package:lockboxx/edit_password.dart';
import 'package:lockboxx/login.dart';
import 'package:lockboxx/model/user_model.dart';
import 'package:lockboxx/services/api_services.dart';
import 'package:lockboxx/theme.dart';

import 'edit_profile.dart'; // Import EditProfilePage

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, required this.user});

  User user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserController userController = UserController();
  final ApiService apiService = ApiService();

  @override
  void initState() {
    // TODO: implement initState
    widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: 500,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/icon.png'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.user.name,
                      style: const TextStyle(
                        color: kWhiteColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 0),
                    Text(
                      widget.user.email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: kWhiteColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () async {
                        final updatedUser = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              user: widget.user,
                            ),
                          ),
                        );

                        // Periksa apakah data pengguna diperbarui
                        if (updatedUser != null) {
                          setState(() {
                            widget.user = updatedUser;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kWhiteColor,
                        foregroundColor: const Color(0xff414141),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Edit profile'),
                    ),
                  ],
                ),
              ),
            ),

            // premium Section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(25),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color(0xffF6EC72),
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.user.membershipType == "BASIC") ...[
                    const Text(
                      'Go Premium!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff414141),
                      ),
                    ),
                    const SizedBox(height: 0),
                    const Text(
                      'Rewards earned',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async {
                        final updatedMembership = await apiService
                            .updateMembership(userId: widget.user.userId);
                        if (updatedMembership["success"] == true) {
                          setState(() {
                            widget.user.membershipType = "PREMIUM";
                          });
                        }
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => PremiumPage(),
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: kWhiteColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Go to Premium'),
                    ),
                  ] else ...[
                    const Text(
                      'Welcome, Premium Member!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Thank you for being a Premium user.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Support Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Support',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.store, color: Colors.black),
                          title: const Text('Help Center'),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.support_agent,
                              color: Colors.black),
                          title: const Text('Support'),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.lock, color: Colors.black),
                          title: const Text('Password'),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditPasswordPage(user: widget.user,),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Logout Section
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: TextButton(
                  onPressed: () async {
                    // Add your logout logic here
                    final logout = await userController.logout();
                    if (logout) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logout successful'),
                        ),
                      );
                      // Redirect to login page
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LogInScreen()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 150, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  child: const Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
