import 'package:flutter/material.dart';
import 'package:lockboxx/theme.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  PrimaryButton({required this.buttonText, required Null Function() onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.08,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: const Color(0xFF1B383A)),
      child: Text(
        buttonText,
        style: textButton.copyWith(color: kWhiteColor),
      ),
    );
  }
}

