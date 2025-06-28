import 'package:flutter/material.dart';
import 'package:menasyp/services/google_sheet_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final GoogleSheetsService _googleSheetsService = GoogleSheetsService();
  final String _feedbackSheetUrl =
      'https://docs.google.com/spreadsheets/d/e/2PACX-1vSEAEDhje20E1rev37xZE8xytcj7o4TqC-dqd99o4vQSk_VYLF92oQry6mtatdtPhKoJcd5dXhqutJi/pub?gid=1845174341&single=true&output=csv';

  List<List<String>> _feedbackData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeedbackData();
  }

  Future<void> _loadFeedbackData() async {
    try {
      final data = await _googleSheetsService.fetchSheetData(_feedbackSheetUrl);
      if (mounted) {
        setState(() {
          _feedbackData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec du chargement des retours : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Users Feedback'),
        backgroundColor: const Color(0xFF1F1F1F),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: SpinKitFadingCircle(color: Color(0xffFF2057), size: 50.0))
          : _feedbackData.length <= 1
              ? const Center(
                  child: Text(
                    'Aucun retour disponible.',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _feedbackData.length,
                  itemBuilder: (context, index) {
                    if (index == 0) return const SizedBox(); // Skip header
                    final feedback = _feedbackData[index];
                    final user = feedback.isNotEmpty ? feedback[0] : 'Utilisateur inconnu';
                    final comment = feedback.length > 1 ? feedback[1] : 'Aucun commentaire.';
                    final date = feedback.length > 2 ? feedback[2] : 'Date inconnue';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          user,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                date,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
