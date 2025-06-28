import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:menasyp/core/theme.dart";


class TravelHomePage extends StatefulWidget {
  const TravelHomePage({Key? key}) : super(key: key);

  @override
  State<TravelHomePage> createState() => _TravelHomePageState();
}

class _TravelHomePageState extends State<TravelHomePage> {
  String selectedCategory = 'Show All';

  final List<Map<String, dynamic>> destinations = [
    {
      'title': 'Bardo Museum',
      'location': 'Tunis',
      'image': 'assets/mb.jpg',
      'category': 'Museums',
      'description': 'The Bardo National Museum is the largest archaeological museum in Tunisia, housing one of the world\'s most extensive collections of Roman mosaics.',
      'longDescription': 'The Bardo National Museum is a jewel of Tunisian cultural heritage. Originally a 13th-century Hafsid palace, it was converted into a museum in 1888. The museum\'s collection includes Roman mosaics from Carthage, Dougga, and other ancient sites, Islamic art and artifacts, Punic and Numidian collections, Greek and Roman sculptures, and Islamic ceramics and textiles.',
      'coordinates': LatLng(36.8095, 10.1332),
      'address': 'P7, Tunis 2000, Tunisia',
      'openingHours': '9:00 AM - 5:00 PM',
      'entranceFee': '12 TND',
      'website': 'https://www.bardomuseum.tn',
      'phone': '+216 71 513 650',
      'highlights': ['Roman Mosaics', 'Islamic Art', 'Ancient Sculptures', 'Historical Architecture'],
      'tips': ['Visit early morning to avoid crowds', 'Allow 2-3 hours for a complete tour', 'Photography is allowed', 'Guided tours available'],
    },
    {
      'title': 'Military Museum',
      'location': 'Tunis',
      'image': 'assets/mm.jpg',
      'category': 'Museums',
      'description': 'The Military Museum of Tunisia showcases the country\'s military history from ancient times to the modern era.',
      'longDescription': 'The Military Museum offers a comprehensive view of Tunisia\'s military heritage. The museum displays ancient weapons and armor, Ottoman period military equipment, French colonial era artifacts, independence movement memorabilia, modern military technology, and historical documents and maps.',
      'coordinates': LatLng(36.8065, 10.1815),
      'address': 'Avenue de la République, Tunis',
      'openingHours': '9:00 AM - 4:00 PM',
      'entranceFee': 'Free',
      'website': '',
      'phone': '+216 71 234 567',
      'highlights': ['Ancient Weapons', 'Military History', 'Historical Artifacts', 'Strategic Maps'],
      'tips': ['Free admission', 'Photography restrictions apply', 'Military ID may be required', 'Visit during weekdays'],
    },
    {
      'title': 'Archeologic site of Carthage',
      'location': 'Carthage',
      'image': 'assets/sa.jpg',
      'category': 'Sights',
      'description': 'The ancient city of Carthage, a UNESCO World Heritage site, was once the center of a powerful empire.',
      'longDescription': 'Carthage, founded by the Phoenicians in the 9th century BC, was one of the most powerful cities of the ancient world. The archaeological site includes the Antonine Baths, the Punic Ports, the Tophet, Roman villas and mosaics, the Carthage Museum, and the Acropolium.',
      'coordinates': LatLng(36.8529, 10.3233),
      'address': 'Carthage, Tunisia',
      'openingHours': '8:30 AM - 6:00 PM',
      'entranceFee': '15 TND',
      'website': 'https://whc.unesco.org/en/list/37',
      'phone': '+216 71 730 036',
      'highlights': ['Ancient Ruins', 'Roman Baths', 'Punic Ports', 'UNESCO Site', 'Historical Significance'],
      'tips': ['Wear comfortable walking shoes', 'Bring water and sun protection', 'Allow 3-4 hours for exploration', 'Visit the museum first for context'],
    },
  ];

  final List<Map<String, dynamic>> topDestinations = [
    {
      'title': 'Sidi Bou Said',
      'location': 'Tunis',
      'image': 'assets/sbs.jpg',
      'category': 'Sights',
      'description': 'A picturesque coastal village known for its white and blue architecture and stunning views of the Mediterranean.',
      'longDescription': 'Sidi Bou Said is a charming village perched on a cliff overlooking the Mediterranean Sea. Known for its distinctive white and blue architecture, it has inspired artists and writers for centuries. Highlights include the iconic blue and white buildings, panoramic sea views, traditional cafes and restaurants, art galleries and craft shops.',
      'coordinates': LatLng(36.8711, 10.3414),
      'address': 'Sidi Bou Said, Tunisia',
      'openingHours': 'Always open',
      'entranceFee': 'Free',
      'website': '',
      'phone': '',
      'highlights': ['Blue & White Architecture', 'Mediterranean Views', 'Art Galleries', 'Traditional Cafes', 'Coastal Beauty'],
      'tips': ['Visit during sunset for best photos', 'Try traditional mint tea', 'Explore on foot', 'Visit local art galleries'],
    },
    {
      'title': 'Djerba',
      'location': 'South',
      'image': 'assets/jerba.jpg',
      'category': 'Sights',
      'description': 'The largest island in North Africa, known for its beautiful beaches and unique culture.',
      'longDescription': 'Djerba is a magical island that combines natural beauty with rich cultural heritage. The island features pristine beaches with crystal-clear waters, the historic El Ghriba synagogue, traditional Berber villages, olive groves and palm trees, traditional crafts and pottery, fresh seafood restaurants, and the Houmt Souk market.',
      'coordinates': LatLng(33.8075, 10.8451),
      'address': 'Djerba Island, Tunisia',
      'openingHours': 'Always open',
      'entranceFee': 'Free',
      'website': '',
      'phone': '',
      'highlights': ['Beautiful Beaches', 'El Ghriba Synagogue', 'Berber Culture', 'Olive Groves', 'Traditional Crafts'],
      'tips': ['Visit in spring or fall for best weather', 'Try local seafood', 'Explore traditional villages', 'Visit the synagogue'],
    },
    {
      'title': 'Dougga',
      'location': 'North West',
      'image': 'assets/dougga.jpg',
      'category': 'Sights',
      'description': 'One of the best-preserved Roman cities in North Africa, featuring impressive ruins and stunning countryside views.',
      'longDescription': 'Dougga is a UNESCO World Heritage site and one of the most impressive Roman archaeological sites in Africa. The site includes a well-preserved Roman theater, the Capitol temple, ancient Roman baths, residential areas with mosaics, the forum and market, temples and religious buildings, and stunning countryside views.',
      'coordinates': LatLng(36.4228, 9.2183),
      'address': 'Dougga, Tunisia',
      'openingHours': '8:00 AM - 6:00 PM',
      'entranceFee': '10 TND',
      'website': 'https://whc.unesco.org/en/list/794',
      'phone': '+216 78 234 567',
      'highlights': ['Roman Theater', 'Capitol Temple', 'Ancient Baths', 'UNESCO Site', 'Countryside Views'],
      'tips': ['Wear comfortable shoes', 'Bring water and snacks', 'Allow 2-3 hours', 'Visit early morning'],
    },
    {
      'title': 'Tozeur',
      'location': 'South West',
      'image': 'assets/tozeur.png',
      'category': 'Sights',
      'description': 'A desert oasis city known for its palm groves, traditional architecture, and proximity to the Sahara Desert.',
      'longDescription': 'Tozeur is a magical desert oasis that offers a unique blend of natural beauty and cultural heritage. The city features extensive palm groves with over 200,000 trees, traditional brick architecture, the Dar Cherait Museum, the medina, desert excursions and camel rides, traditional crafts and dates, and the Chott el-Jerid salt lake nearby.',
      'coordinates': LatLng(33.9197, 8.1335),
      'address': 'Tozeur, Tunisia',
      'openingHours': 'Always open',
      'entranceFee': 'Free',
      'website': '',
      'phone': '',
      'highlights': ['Palm Groves', 'Desert Oasis', 'Traditional Architecture', 'Sahara Access', 'Date Production'],
      'tips': ['Visit in winter for pleasant weather', 'Try local dates', 'Take a desert tour', 'Explore the palm groves'],
    },
  ];

  List<Map<String, dynamic>> get filteredDestinations {
    if (selectedCategory == 'Show All') return destinations;
    return destinations.where((d) => d['category'] == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  const SizedBox(height: 32),
                  _buildCategoryChips(),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
            _buildRecommendedSection(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 24),
                  _buildTopDestinationsHeader(),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
            _buildTopDestinationsList(),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 80),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, Menasypian!', style: TextStyle(fontSize: 18, color: Colors.grey[400])),
            const SizedBox(height: 4),
            const Text('Explore Tunisia with us', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search destination, activities...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = ['Show All', 'Sights', 'Museums', 'Entertainment', 'Night Clubs'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryChip(
            label: category,
            isActive: selectedCategory == category,
            accentColor: const Color(0xffFF2057),
            onTap: () => setState(() => selectedCategory = category),
          );
        },
      ),
    );
  }

  Widget _buildRecommendedSection() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 260,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: filteredDestinations.length,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final dest = filteredDestinations[index];
            return _buildDestinationCard(dest);
          },
        ),
      ),
    );
  }

  Widget _buildDestinationCard(Map<String, dynamic> destination) {
    return GestureDetector(
      onTap: () => _showDestinationDetail(destination),
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 8))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.asset(
                destination['image'],
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[800],
                  child: Icon(Icons.broken_image, color: Colors.grey[600]),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination['title'],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            destination['location'],
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopDestinationsHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Top Destinations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
       
      ],
    );
  }

  Widget _buildTopDestinationsList() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 110,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: topDestinations.map((destination) {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () => _showDestinationDetail(destination),
                child: SmallDestinationCard(
                  title: destination['title'],
                  location: destination['location'],
                  icon: _getIconForCategory(destination['category']),
                  color: const Color(0xFF1E1E1E),
                  iconColor: const Color(0xffFF2057),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Museums':
        return Icons.museum;
      case 'Sights':
        return Icons.landscape;
      case 'Entertainment':
        return Icons.music_note;
      case 'Night Clubs':
        return Icons.nightlife;
      default:
        return Icons.place;
    }
  }

  void _showDestinationDetail(Map<String, dynamic> destination) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DestinationDetailPage(destination: destination),
      ),
    );
  }
}

class DestinationDetailPage extends StatelessWidget {
  final Map<String, dynamic> destination;

  const DestinationDetailPage({Key? key, required this.destination}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: backgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    destination['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[800],
                      child: Icon(Icons.broken_image, color: Colors.grey[600], size: 50),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          destination['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              destination['location'],
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () => _shareDestination(context),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(),
                  const SizedBox(height: 24),
                  _buildDescriptionSection(),
                  const SizedBox(height: 24),
                  _buildHighlightsSection(),
                  const SizedBox(height: 24),
                  _buildTipsSection(),
                  const SizedBox(height: 24),
                  _buildMapSection(),
                  const SizedBox(height: 24),
                  _buildContactSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.access_time, 'Opening Hours', destination['openingHours']),
          const Divider(color: Color(0xFF2A2A2A), height: 20),
          _buildInfoRow(Icons.attach_money, 'Entrance Fee', destination['entranceFee']),
          const Divider(color: Color(0xFF2A2A2A), height: 20),
          _buildInfoRow(Icons.category, 'Category', destination['category']),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xffFF2057), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          destination['longDescription'],
          style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildHighlightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Highlights',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (destination['highlights'] as List<String>).map((highlight) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xffFF2057).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xffFF2057)),
              ),
              child: Text(
                highlight,
                style: const TextStyle(color: Color(0xffFF2057), fontSize: 14),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Travel Tips',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...(destination['tips'] as List<String>).map((tip) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline, color: Color(0xffFF2057), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tip,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildMapSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: // In the FlutterMap section:
FlutterMap(
  options: MapOptions(
    initialCenter: destination['coordinates'],
    initialZoom: 13,
    interactionOptions: const InteractionOptions(
      flags: InteractiveFlag.all,
    ),
  ),
  children: [
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.app',
    ),
    MarkerLayer(
      markers: [
        Marker(
          point: destination['coordinates'],
          width: 80,
          height: 80,
          child: const Icon(
            Icons.location_on,
            color: Color(0xffFF2057),
            size: 40,
          ),
        ),
      ],
    ),
  ],
),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          destination['address'],
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact & Information',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (destination['phone'].isNotEmpty)
          _buildContactRow(Icons.phone, 'Phone', destination['phone'], () => _launchUrl('tel:${destination['phone']}')),
        if (destination['website'].isNotEmpty)
          _buildContactRow(Icons.language, 'Website', destination['website'], () => _launchUrl(destination['website'])),
        _buildContactRow(Icons.directions, 'Get Directions', 'Open in Maps', () => _openInMaps()),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xffFF2057), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      value,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _shareDestination(BuildContext context) {
    final text = 'Check out ${destination['title']} in ${destination['location']}, Tunisia!';
    // Implement sharing functionality
  }

  void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _openInMaps() async {
    final lat = destination['coordinates'].latitude;
    final lng = destination['coordinates'].longitude;
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    _launchUrl(url);
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color accentColor;
  final VoidCallback? onTap;

  const CategoryChip({super.key, required this.label, this.isActive = false, required this.accentColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: isActive ? accentColor : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[400],
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SmallDestinationCard extends StatelessWidget {
  final String title;
  final String location;
  final IconData icon;
  final Color color;
  final Color iconColor;

  const SmallDestinationCard({super.key, required this.title, required this.location, required this.icon, required this.color, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            location,
            style: TextStyle(fontSize: 10, color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
