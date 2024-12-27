import 'package:flutter/material.dart';
import 'package:lockboxx/model/user_model.dart';
import 'package:lockboxx/services/api_services.dart';
import 'package:lockboxx/theme.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({super.key, required this.user});

  User user;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  final bool _isLoading = false;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
  onPressed: _isLoading
      ? null
      : () async {
          // Simulasikan pemanggilan API untuk memperbarui profil
          final response = await apiService.updateProfile(
            userId: widget.user.userId,
            name: _nameController.text,
            number: _phoneController.text,
          );

          if (response["success"] == true) { // Asumsikan respons berhasil
            // Perbarui data pengguna dan kembali ke halaman ProfilePage
            widget.user.name = _nameController.text;
            widget.user.phone = _phoneController.text;
            Navigator.of(context).pop(widget.user);
          } else {
            // Tampilkan pesan error jika diperlukan
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to update profile.'),
              ),
            );
          }
        },
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: kPrimaryColor,
    minimumSize: const Size(350, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  child: _isLoading
      ? const CircularProgressIndicator(
          color: Colors.white,
        )
      : const Text(
          "Save",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
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
