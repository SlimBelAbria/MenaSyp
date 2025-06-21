import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class BardoMuseumScreen extends StatelessWidget {
  const BardoMuseumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The National Bardo Museum'),
        centerTitle: true,
      ),
      body:const SingleChildScrollView(
        child: MuseumCard(
          title: 'The National Bardo Museum',
          mainImagePath: 'assets/images/bardo_main.jpg',
          thumbnailPaths: [
            'assets/images/bardo_thumb1.jpg',
            'assets/images/bardo_thumb2.jpg',
            'assets/images/bardo_thumb3.jpg',
          ],
          description: "The main draw at the Tunisia's top museum is its magnificent collection of Roman mosaics. "
              "These provide a vibrant and fascinating portrait of ancient North African life. Also here is some "
              "equally magnificent Hellenistic and Punic statuary. The massive collection is housed in an imposing "
              "palace complex built under the Hafsids (1228–1574), and fortified and extended by the Ottomans in the "
              "18th century. The original palace buildings now connect with a dramatic contemporary annexe, which has "
              "doubled the exhibition space.",
          openHours: '09:00 → 17:00',
          fees: '8dt - 2.53€ for Tunisian and Arab Maghreb residents\n'
              '13dt - 4.12\$ for non-residents',
          location:  LatLng(36.8098, 10.1356),
          googleMapsUrl: 'https://goo.gl/maps/your-actual-url',
        ),
      ),
    );
  }
}

class MuseumCard extends StatelessWidget {
  final String title;
  final String mainImagePath;
  final List<String> thumbnailPaths;
  final String description;
  final String openHours;
  final String fees;
  final LatLng location;
  final String googleMapsUrl;

  const MuseumCard({
    super.key,
    required this.title,
    required this.mainImagePath,
    required this.thumbnailPaths,
    required this.description,
    required this.openHours,
    required this.fees,
    required this.location,
    required this.googleMapsUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero image with gradient overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  mainImagePath,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 4,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail gallery
                if (thumbnailPaths.isNotEmpty)
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: thumbnailPaths.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          thumbnailPaths[index],
                          width: 120,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                if (thumbnailPaths.isNotEmpty) const SizedBox(height: 16),

                // Description
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 20),

                // Info sections
                _buildInfoRow(
                  icon: Icons.access_time,
                  label: 'Open Hours',
                  value: openHours,
                ),
                const SizedBox(height: 12),

                _buildInfoRow(
                  icon: Icons.attach_money,
                  label: 'Fees',
                  value: fees,
                ),
                const SizedBox(height: 20),

                // Interactive map
                _buildMapSection(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 35, color: Colors.blue.shade700),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMapSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, size: 20, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            Text(
              'Location:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _launchGoogleMaps(googleMapsUrl),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  SizedBox(
                    height: 180,
                    child: FlutterMap(
                      options: MapOptions(
                        center: location,
                        zoom: 15,
                        interactiveFlags: InteractiveFlag.none,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: location,
                              width: 80,
                              height: 80,
                              child: const Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black.withOpacity(0.01),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => _launchGoogleMaps(googleMapsUrl),
            child: Text(
              'Open in Google Maps →',
              style: TextStyle(
                color: Colors.blue.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchGoogleMaps(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}