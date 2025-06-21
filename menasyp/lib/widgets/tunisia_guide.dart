import 'package:flutter/material.dart';
import "package:menasyp/core/theme.dart";

class TunisiaGuidePage extends StatelessWidget {
  const TunisiaGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  backgroundColor,
      appBar: AppBar(
        backgroundColor:  backgroundColor,
        elevation: 0,
        title: const Text('Tunisia Guide 🇹🇳'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          _buildSectionTitle('Essential Phrases'),
          _buildInfoCard(Icons.translate, 'Hello', '"Aslema" (السلام)'),
          _buildInfoCard(Icons.translate, 'Thank you', '"Shukran" (شكرا)'),
          _buildInfoCard(Icons.translate, 'How much?', '"Bch’hal?" (بشحال)'),
          const SizedBox(height: 24),

          _buildSectionTitle('Cultural Tips'),
          _buildInfoCard(Icons.info_outline, 'Dress Modestly', 'Especially when visiting religious or traditional places.'),
          _buildInfoCard(Icons.info_outline, 'Greetings', 'Use “Salam” or handshakes with the right hand.'),
          _buildInfoCard(Icons.info_outline, 'Bargaining', 'It’s normal in souks! Don’t be afraid to negotiate.'),
          const SizedBox(height: 24),

          _buildSectionTitle('Emergency Numbers'),
          _buildInfoCard(Icons.local_police, 'Police', '197'),
          _buildInfoCard(Icons.local_hospital, 'Ambulance', '190'),
          _buildInfoCard(Icons.fire_truck, 'Firefighters', '198'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: const Color(0xffFF2057)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Text(description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[400])),
              ],
            ),
          )
        ],
      ),
    );
  }
}
