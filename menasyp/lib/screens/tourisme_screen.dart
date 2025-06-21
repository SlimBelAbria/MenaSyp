import 'package:flutter/material.dart';
import "package:menasyp/core/theme.dart";
class TravelHomePage extends StatefulWidget {
  const TravelHomePage({Key? key}) : super(key: key);

  @override
  State<TravelHomePage> createState() => _TravelHomePageState();
}

class _TravelHomePageState extends State<TravelHomePage> {
  String selectedCategory = 'Show All';

  final List<Map<String, String>> destinations = [
    {
      'title': 'Bardo Museum',
      'location': 'Tunis',
      'image': 'assets/mb.jpg',
      'category': 'Museums'
    },
    {
      'title': 'Military Museum',
      'location': 'Tunis',
      'image': 'assets/mm.jpg',
      'category': 'Museums'
    },
    {
      'title': 'Archeologic site of Carthage',
      'location': 'Carthage',
      'image': 'assets/sa.jpg',
      'category': 'Sights'
    },
  ];

  List<Map<String, String>> get filteredDestinations {
    if (selectedCategory == 'Show All') return destinations;
    return destinations.where((d) => d['category'] == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  backgroundColor,
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
            return _buildDestinationCard(
              title: dest['title']!,
              location: dest['location']!,
              imagePath: dest['image']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildDestinationCard({required String title, required String location, required String imagePath}) {
    return Container(
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
              imagePath,
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
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(location, style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopDestinationsHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Top Destinations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        Text('See all', style: TextStyle(fontSize: 14, color: Color(0xffFF2057), fontWeight: FontWeight.w500)),
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
          children: const [
            SmallDestinationCard(title: 'Sidi Bou Said', location: 'Tunis', icon: Icons.landscape, color: Color(0xFF1E1E1E), iconColor: Color(0xffFF2057)),
            SizedBox(width: 16),
            SmallDestinationCard(title: 'Djerba', location: 'South', icon: Icons.beach_access, color: Color(0xFF1E1E1E), iconColor: Color(0xffFF2057)),
            SizedBox(width: 16),
            SmallDestinationCard(title: 'Dougga', location: 'North West', icon: Icons.history, color: Color(0xFF1E1E1E), iconColor: Color(0xffFF2057)),
            SizedBox(width: 16),
            SmallDestinationCard(title: 'Tozeur', location: 'South West', icon: Icons.palette, color: Color(0xFF1E1E1E), iconColor: Color(0xffFF2057)),
          ],
        ),
      ),
    );
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
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white), textAlign: TextAlign.center),
          Text(location, style: TextStyle(fontSize: 10, color: Colors.grey[400]), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
