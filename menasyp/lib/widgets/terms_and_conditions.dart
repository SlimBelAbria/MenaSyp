import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menasyp/core/theme.dart';
     // Dark background
const Color accentColor = Color(0xffFF2057);        // Pink-red highlight
const Color textColor = Color.fromARGB(255, 255, 255, 255); // Pure white text

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: textColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.gavel_rounded, size: 40, color: accentColor),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'MenaSyp Terms of Service',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ),
           const Divider(color: Colors.white24, height: 40),
            Text(
              'Last Updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 24),

            _buildTermItem(
              number: '1',
              title: 'Acceptance of Terms',
              content:
                  'By accessing or using MenaSyp, you agree to be bound by these Terms. If you disagree, please refrain from using our services.',
            ),
            _buildTermItem(
              number: '2',
              title: 'Account Responsibility',
              content:
                  'You are responsible for maintaining the confidentiality of your account credentials and for all activities under your account.',
            ),
            _buildTermItem(
              number: '3',
              title: 'Data Privacy',
              content:
                  'We collect necessary data to provide and improve our services. Your information is protected as outlined in our Privacy Policy.',
            ),
            _buildTermItem(
              number: '4',
              title: 'Proper Use',
              content:
                  'MenaSyp is intended for industrial and monitoring purposes only. Any misuse or unauthorized access is strictly prohibited.',
            ),
            _buildTermItem(
              number: '5',
              title: 'Intellectual Property',
              content:
                  'All content, features, and functionality are the exclusive property of MenaSyp and protected by copyright laws.',
            ),
            _buildTermItem(
              number: '6',
              title: 'Service Modifications',
              content:
                  'We reserve the right to modify or discontinue services at any time without prior notice.',
            ),
            _buildTermItem(
              number: '7',
              title: 'Termination',
              content:
                  'We may suspend or terminate accounts that violate these Terms or engage in harmful activities.',
            ),

            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'By continuing to use MenaSyp, you acknowledge that you have read, understood, and agreed to these Terms and our Privacy Policy.',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  height: 1.5,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '© ${DateTime.now().year} MenaSyp. All rights reserved.',
                style:const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  color: Colors.white60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermItem({
    required String number,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
