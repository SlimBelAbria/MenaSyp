import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:menasyp/widgets/terms_and_conditions.dart';
import 'package:menasyp/services/auth_service_gs.dart';
import 'package:menasyp/services/auth_wrapper.dart';
import 'package:menasyp/services/user_provider.dart';
import 'package:menasyp/services/google_sheet_api.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final GlobalKey _qrKey = GlobalKey();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
Future<void> _shareApp() async {
  // Early return if widget is disposed
  if (!mounted) return;

  final user = Provider.of<UserProvider>(context, listen: false).user;
  final fullName = '${user?['name'] ?? ''} ${user?['lastname'] ?? ''}'.trim();
  const appLink = 'https://example.com/download-app';
  
  final shareText = 'Check out this app recommended by $fullName!\n\nDownload it here: $appLink';

  try {
    // Check again in case widget was disposed during async gap
    if (!mounted) return;

    // Get boundary and image
    final renderObject = _qrKey.currentContext?.findRenderObject();
    if (renderObject == null || !mounted) return;

    final boundary = renderObject as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    
    if (byteData == null || !mounted) return;
    
    // Create temp file
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png')
      .writeAsBytes(byteData.buffer.asUint8List());

    // Final mounted check before sharing
    if (mounted) {
      await Share.shareXFiles(
        [XFile(file.path)],
        text: shareText,
        subject: 'Check out this app!',
      );
    }
  } catch (e) {
    // Fallback to text-only sharing if image sharing fails
    if (mounted) {
      await Share.share(shareText);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final fullName = '${user?['name'] ?? ''} ${user?['lastname'] ?? ''}'.trim();
    final avatarImage = user?['sex'] == 'F' ? 'assets/women.png' : 'assets/men.png';
    final branch = user?['Branch'] ?? 'Not specified';
    final country = user?['Country'] ?? 'Not specified';

    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar and Name Section
                      Center(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage(avatarImage),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xffFF2057),
                                      border: Border.all(color: Colors.white, width: 1.5),
                                    ),
                                    child: const Icon(Icons.edit, size: 16, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              fullName.isNotEmpty ? fullName : 'User Name',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Account Information Section
                      _buildSectionTitle('Account Information'),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: const Color(0xFF1E1E1E),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                            _buildInfoRow(Icons.business, 'Branch', branch),
const Divider(height: 20, color: Color(0xFF2A2A2A)),
Row(
  children: [
   Image.asset(
      'assets/${country.toLowerCase()}.png', // e.g., 'tunisia.png'
      width: 35,
      height: 35,
    ),
    const SizedBox(width: 15),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Country',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            country,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  ],
),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // App Information Section
                      _buildSectionTitle('App Information'),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: const Color(0xFF1E1E1E),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _buildClickableRow(
                                Icons.description,
                                'Terms and Conditions / Privacy Policy',
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const TermsAndConditionsPage(),
                                    ),
                                  );
                                },
                              ),
                              const Divider(height: 20, color: Color(0xFF2A2A2A)),
                              _buildClickableRow(
                                Icons.share,
                                'Share with Friends',
                                () => _showQRCodeDialog(context),
                              ),
                              const Divider(height: 20, color: Color(0xFF2A2A2A)),
                              _buildClickableRow(
                                Icons.feedback,
                                'Send Feedback',
                                () => _showFeedbackDialog(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Logout Button
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _showLogoutConfirmation(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            backgroundColor: const Color(0xFF1E1E1E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Color(0xFF2A2A2A), width: 1),
                            ),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xffFF2057)),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClickableRow(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: const Color(0xffFF2057)),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          'Confirm Logout',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final authService = AuthService();
              await authService.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const AuthWrapper()),
                  (route) => false,
                );
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    bool isSubmitting = false;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?['id'] ?? 'anonymous';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              title: const Text(
                'Send Feedback',
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _feedbackController,
                    maxLines: 5,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter your feedback here...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xffFF2057)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (isSubmitting)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: CircularProgressIndicator(color: Color(0xffFF2057)),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                ),
                ElevatedButton(
                  onPressed: isSubmitting ? null : () async {
                    if (_feedbackController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your feedback'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    setState(() => isSubmitting = true);

                    try {
                      final success = await GoogleSheetApi.addFeedback(
                        userId,
                        _feedbackController.text
                      );
                      
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success 
                                ? 'Thank you for your feedback!'
                                : 'Failed to submit feedback'
                            ),
                            backgroundColor: success 
                              ? const Color(0xffFF2057)
                              : Colors.red,
                          ),
                        );
                        _feedbackController.clear();
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } finally {
                      if (context.mounted) {
                        setState(() => isSubmitting = false);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFF2057),
                    disabledBackgroundColor: const Color(0xffFF2057).withOpacity(0.5),
                  ),
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showQRCodeDialog(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final fullName = '${user?['name'] ?? ''} ${user?['lastname'] ?? ''}'.trim();
    final shareData = 'https://menasyp.ieee.tn/';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Share with Friends',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Scan this QR code to get recommended by $fullName',
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              RepaintBoundary(
                key: _qrKey,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: QrImageView(
                    data: shareData,
                    version: QrVersions.auto,
                    size: 180,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Or share this link:',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              SelectableText(
                shareData,
                style: const TextStyle(
                  color: Color(0xffFF2057),
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: _shareApp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffFF2057),
              ),
              child: const Text('Share'),
            ),
          ],
        );
      },
    );
  }
}