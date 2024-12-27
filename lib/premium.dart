import 'package:flutter/material.dart';
import 'package:lockboxx/theme.dart';

class PremiumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('Premium', style: TextStyle(fontWeight: FontWeight.bold, color: kWhiteColor)),
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: kWhiteColor), // Menambahkan ini untuk mengubah warna ikon
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Payment Options
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.credit_card, color: kPrimaryColor),
              title: const Text('Credit Card', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Logic to handle payment (e.g., navigate to payment screen) 
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Credit Card selected')),
                );
              },
            ),
            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.payment, color: kPrimaryColor),
              title: const Text('Dana', style: TextStyle(fontSize: 18)),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PayPal selected')),
                );
              },
            ),
            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.money, color: kPrimaryColor),
              title: const Text('Bank Transfer', style: TextStyle(fontSize: 18)),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bank Transfer selected')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
