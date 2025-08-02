import 'package:flutter/material.dart';
import "package:menasyp/core/theme.dart";
import 'package:menasyp/services/google_sheet_api.dart';
import 'package:menasyp/services/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

// Category definitions with icons and colors
class GuideCategory {
  final String name;
  final IconData icon;
  final Color color;
  final String description;

  const GuideCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
  });
}

class TunisiaGuidePage extends StatefulWidget {
  const TunisiaGuidePage({super.key});

  @override
  State<TunisiaGuidePage> createState() => _TunisiaGuidePageState();
}

class _TunisiaGuidePageState extends State<TunisiaGuidePage> with TickerProviderStateMixin {
  List<Map<String, dynamic>> guideItems = [];
  bool isLoading = true;
  bool _isDisposed = false;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Predefined categories
  static const List<GuideCategory> categories = [
    GuideCategory(
      name: 'Cultural Tips',
      icon: Icons.people,
      color: Colors.orange,
      description: 'Important cultural information and etiquette',
    ),
    GuideCategory(
      name: 'Essential Phrases',
      icon: Icons.translate,
      color: Color(0xffFF2057),
      description: 'Useful Arabic and French phrases',
    ),
    GuideCategory(
      name: 'Emergency Numbers',
      icon: Icons.emergency,
      color: Colors.red,
      description: 'Important emergency contact numbers',
    ),
    GuideCategory(
      name: 'Transportation',
      icon: Icons.directions_bus,
      color: Colors.blue,
      description: 'Getting around Tunisia',
    ),
    GuideCategory(
      name: 'Food & Dining',
      icon: Icons.restaurant,
      color: Colors.green,
      description: 'Local cuisine and dining tips',
    ),
    GuideCategory(
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: Colors.purple,
      description: 'Shopping tips and recommendations',
    ),
    GuideCategory(
      name: 'Weather & Climate',
      icon: Icons.wb_sunny,
      color: Colors.amber,
      description: 'Weather information and best times to visit',
    ),
    GuideCategory(
      name: 'Historical Sites',
      icon: Icons.history_edu,
      color: Colors.brown,
      description: 'Must-visit historical locations',
    ),
    GuideCategory(
      name: 'Safety Tips',
      icon: Icons.security,
      color: Colors.indigo,
      description: 'Important safety information',
    ),
    GuideCategory(
      name: 'General',
      icon: Icons.info_outline,
      color: Colors.grey,
      description: 'General information and tips',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    
    _loadGuideItems();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  GuideCategory getCategoryInfo(String categoryName) {
    return categories.firstWhere(
      (cat) => cat.name.toLowerCase() == categoryName.toLowerCase(),
      orElse: () => categories.last,
    );
  }

  Future<void> _loadGuideItems() async {
    if (_isDisposed) return;
    
    try {
      final items = await GoogleSheetApi.getGuideItems();
      if (!_isDisposed && mounted) {
        setState(() {
          guideItems = items;
          isLoading = false;
        });
        _fadeController.forward();
        _slideController.forward();
        
        // Check if emergency numbers exist, if not add them
        await _ensureEmergencyNumbersExist();
      }
    } catch (e) {
      if (!_isDisposed && mounted) {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog(e.toString());
      }
    }
  }

  /// Ensure emergency numbers are added to the guide
  Future<void> _ensureEmergencyNumbersExist() async {
    try {
      final emergencyItems = guideItems.where((item) => 
        item['category']?.toString().toLowerCase() == 'emergency numbers'
      ).toList();
      
      // If no emergency numbers exist, add them
      if (emergencyItems.isEmpty) {
        await _addDefaultEmergencyNumbers();
      }
    } catch (e) {
      print('Error ensuring emergency numbers: $e');
    }
  }

  /// Add default emergency numbers to the guide
  Future<void> _addDefaultEmergencyNumbers() async {
    try {
      final emergencyNumbers = [
        {
          'category': 'Emergency Numbers',
          'title': 'Police (Police Nationale)',
          'description': 'Emergency: 197\nGeneral: 717-800-00\nFor immediate police assistance and emergency situations.',
        },
        {
          'category': 'Emergency Numbers',
          'title': 'National Guard (Garde Nationale)',
          'description': 'Emergency: 198\nGeneral: 717-800-00\nFor security and border control emergencies.',
        },
        {
          'category': 'Emergency Numbers',
          'title': 'Firefighters (Pompiers)',
          'description': 'Emergency: 198\nGeneral: 717-800-00\nFor fire emergencies and rescue operations.',
        },
        {
          'category': 'Emergency Numbers',
          'title': 'Medical Emergency (SAMU)',
          'description': 'Emergency: 190\nFor medical emergencies and ambulance services.',
        },
        {
          'category': 'Emergency Numbers',
          'title': 'Tourist Police',
          'description': 'Emergency: 197\nSpecialized assistance for tourists in Tunisia.',
        },
      ];

      for (final number in emergencyNumbers) {
        await GoogleSheetApi.addGuideItem(
          category: number['category']!,
          title: number['title']!,
          description: number['description']!,
        );
      }

      // Reload items to show the new emergency numbers
      await _loadGuideItems();
    } catch (e) {
      print('Error adding emergency numbers: $e');
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!_isDisposed && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? const Color(0xffFF2057) : Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.sentiment_dissatisfied_outlined,
                  color: Colors.red[400],
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Something Went Wrong',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'We couldn\'t load the guide right now.',
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Please check your connection and try again.',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _loadGuideItems();
                    },
                    icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
                    label: const Text(
                      'Try Again',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF101010),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final isAdmin = user?['role'] == 'admin';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title:const Row(
          children: [
           
             SizedBox(width: 8),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      'Tunisia Guide',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                 
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (isAdmin)
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: const Color(0xffFF2057).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Color(0xffFF2057)),
                onPressed: () => _showAddGuideItemDialog(context),
                tooltip: 'Add new guide item',
              ),
            ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white70),
              onPressed: _loadGuideItems,
              tooltip: 'Refresh guide',
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitFadingCircle(
                        color: Color(0xffFF2057),
                        size: 50.0,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading Tunisia Guide...',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : guideItems.isEmpty
                  ? _buildEmptyState(isAdmin)
                  : _buildGuideContent(isAdmin),
        ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: const Color(0xffFF2057),
              onPressed: () => _showAddGuideItemDialog(context),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : FloatingActionButton.extended(
              backgroundColor: Colors.red,
              onPressed: () => _showEmergencyNumbersQuickAccess(),
              icon: const Icon(Icons.emergency, color: Colors.white),
              label: const Text('Emergency', style: TextStyle(color: Colors.white)),
            ),
    );
  }

  Widget _buildEmptyState(bool isAdmin) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.explore_off,
              size: 80,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isAdmin 
              ? 'No guide items yet'
              : 'No guide items available',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isAdmin
              ? 'Tap the "+" button to add useful tips for Tunisia'
              : 'Check back later for helpful information',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _loadGuideItems,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffFF2057),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideContent(bool isAdmin) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: _groupedItems().length,
      itemBuilder: (context, index) {
        final category = _groupedItems().keys.elementAt(index);
        final items = _groupedItems()[category]!;
        return AnimatedBuilder(
          animation: _fadeController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(category),
                    ...items.asMap().entries.map((entry) {
                      final itemIndex = entry.key;
                      final item = entry.value;
                      return AnimatedBuilder(
                        animation: _fadeController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, 15 * (1 - _fadeAnimation.value) * (itemIndex + 1)),
                            child: Opacity(
                              opacity: _fadeAnimation.value,
                              child: _buildGuideCard(item, isAdmin),
                            ),
                          );
                        },
                      );
                    }),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupedItems() {
    final map = <String, List<Map<String, dynamic>>>{};
    for (var item in guideItems) {
      final category = item['category'] ?? 'General';
      map.putIfAbsent(category, () => []).add(item);
    }
    return map;
  }

  Widget _buildGuideCard(Map<String, dynamic> item, bool isAdmin) {
    final categoryInfo = getCategoryInfo(item['category'] ?? 'General');

    return isAdmin
        ? Dismissible(
            key: Key(item['id']),
            direction: DismissDirection.endToStart,
            background: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.delete, color: Colors.white, size: 28),
                  SizedBox(width: 20),
                ],
              ),
            ),
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  backgroundColor: const Color(0xFF2C2C2E),
                  title: const Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange, size: 28),
                      SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          'Confirm Delete',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  content: const Text(
                    'Are you sure you want to delete this item?',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) => _deleteItem(item['id']),
            child: _buildInfoCard(categoryInfo, item['title'] ?? '', item['description'] ?? ''),
          )
        : _buildInfoCard(categoryInfo, item['title'] ?? '', item['description'] ?? '');
  }

  Future<void> _deleteItem(String id) async {
    try {
      final success = await GoogleSheetApi.deleteGuideItem(id);
      if (success) {
        if (!_isDisposed && mounted) {
          setState(() {
            guideItems.removeWhere((item) => item['id'] == id);
          });
          _showSnackBar('Item deleted successfully');
        }
      } else {
        _showSnackBar('Failed to delete item', isError: true);
        await _loadGuideItems();
      }
    } catch (e) {
      _showSnackBar('Error deleting item: $e', isError: true);
      await _loadGuideItems();
    }
  }

  Future<void> _showAddGuideItemDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'Cultural Tips';

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFF2C2C2E),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Icon(Icons.add_circle, color: Color(0xffFF2057), size: 28),
                  SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'Add New Guide Item',
                      style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffFF2057)),
                  ),
                ),
                dropdownColor: const Color(0xFF2C2C2E),
                style: const TextStyle(color: Colors.white),
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.name,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: category.color.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            category.icon,
                            color: category.color,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            category.name,
                            style: const TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => selectedCategory = value!,
              ),
              const SizedBox(height: 16),
              _buildTextField(titleController, 'Title', 'e.g., Dress Modestly'),
              const SizedBox(height: 16),
              _buildTextField(
                descriptionController, 
                'Description',
                'e.g., Especially when visiting religious places...', 
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Please fill all fields'),
                            backgroundColor: const Color(0xffFF2057),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                        return;
                      }

                      final success = await GoogleSheetApi.addGuideItem(
                        category: selectedCategory,
                        title: titleController.text,
                        description: descriptionController.text,
                      );

                      if (success) {
                        Navigator.pop(context);
                        await _loadGuideItems();
                        if (!_isDisposed && mounted) {
                          _showSnackBar('Item added successfully');
                        }
                      } else {
                        if (!_isDisposed && mounted) {
                          _showSnackBar('Failed to add item', isError: true);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFF2057),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffFF2057), width: 2),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final categoryInfo = getCategoryInfo(title);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            categoryInfo.color.withOpacity(0.2),
            Colors.transparent,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: categoryInfo.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: categoryInfo.color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              categoryInfo.icon,
              color: categoryInfo.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryInfo.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  categoryInfo.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(GuideCategory categoryInfo, String title, String description) {
    // Check if this is an emergency number item
    final isEmergencyNumber = categoryInfo.name == 'Emergency Numbers';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E1E1E),
            Color(0xFF2E2E2E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: categoryInfo.color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: categoryInfo.color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: categoryInfo.color.withOpacity(0.2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: categoryInfo.color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(categoryInfo.icon, size: 24, color: categoryInfo.color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  if (isEmergencyNumber)
                    _buildEmergencyNumberContent(description)
                  else
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                        height: 1.4,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyNumberContent(String description) {
    final lines = description.split('\n');
    final emergencyLine = lines.firstWhere(
      (line) => line.toLowerCase().contains('emergency:'),
      orElse: () => '',
    );
    final generalLine = lines.firstWhere(
      (line) => line.toLowerCase().contains('general:'),
      orElse: () => '',
    );
    final infoLine = lines.lastWhere(
      (line) => !line.toLowerCase().contains('emergency:') && 
                !line.toLowerCase().contains('general:'),
      orElse: () => '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (emergencyLine.isNotEmpty)
          GestureDetector(
            onTap: () => _callEmergencyNumber(emergencyLine.split(':').last.trim()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emergency, color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    emergencyLine,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.phone, color: Colors.red, size: 14),
                ],
              ),
            ),
          ),
        if (generalLine.isNotEmpty) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _callEmergencyNumber(generalLine.split(':').last.trim()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.phone, color: Colors.blue, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    generalLine,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (infoLine.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            infoLine,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  void _callEmergencyNumber(String number) async {
    // Remove any non-digit characters except + for international numbers
    final cleanNumber = number.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleanNumber.isNotEmpty) {
      final phoneUrl = 'tel:$cleanNumber';
      try {
        if (await canLaunchUrl(Uri.parse(phoneUrl))) {
          await launchUrl(Uri.parse(phoneUrl));
        } else {
          _showSnackBar('Could not launch phone dialer', isError: true);
        }
      } catch (e) {
        _showSnackBar('Error making phone call: $e', isError: true);
      }
    }
  }

  void _showEmergencyNumbersQuickAccess() {
    final emergencyItems = guideItems.where((item) => 
      item['category']?.toString().toLowerCase() == 'emergency numbers'
    ).toList();

    if (emergencyItems.isEmpty) {
      _showSnackBar('No emergency numbers found in the guide.', isError: true);
      return;
    }

         showDialog(
       context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Row(
          children: [
            Icon(Icons.emergency, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Flexible(
              child: Text(
                'Emergency Numbers',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: emergencyItems.map((item) {
              final lines = item['description']?.split('\n') ?? [];
              final emergencyLine = lines.firstWhere(
                (line) => line.toLowerCase().contains('emergency:'),
                orElse: () => '',
              );
              final generalLine = lines.firstWhere(
                (line) => line.toLowerCase().contains('general:'),
                orElse: () => '',
              );
              final infoLine = lines.lastWhere(
                (line) => !line.toLowerCase().contains('emergency:') && 
                          !line.toLowerCase().contains('general:'),
                orElse: () => '',
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (emergencyLine.isNotEmpty) ...[
                    GestureDetector(
                      onTap: () => _callEmergencyNumber(emergencyLine.split(':').last.trim()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.emergency, color: Colors.red, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              emergencyLine,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.phone, color: Colors.red, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (generalLine.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _callEmergencyNumber(generalLine.split(':').last.trim()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.phone, color: Colors.blue, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              generalLine,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (infoLine.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      infoLine,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}