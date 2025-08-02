import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:menasyp/screens/notifications_screen.dart';
import 'package:menasyp/services/google_sheet_api.dart';
import 'package:menasyp/services/user_provider.dart';
import 'package:menasyp/widgets/tunisia_guide.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // <-- new import


import 'package:menasyp/core/theme.dart';
import 'package:menasyp/services/notifications_provicder.dart';
import 'package:menasyp/widgets/terms_and_conditions.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _selectedDay = 0;
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = true;
  bool _isDisposed = false;

  int _unreadNotificationsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _loadUnreadNotificationCount();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _loadEvents() async {
    if (!mounted || _isDisposed) return;
    setState(() => _isLoading = true);
    try {
      await GoogleSheetApi.init();
      final events = await GoogleSheetApi.getEvents();
      if (!mounted || _isDisposed) return;
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted || _isDisposed) return;
      setState(() => _isLoading = false);
      if (mounted) {
        _showErrorDialog(e.toString());
      }
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
                'We couldn\'t load the schedule right now.',
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
                      _loadEvents();
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
                      backgroundColor: const Color(0xFF00629B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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

  Future<void> _loadUnreadNotificationCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSeenId = prefs.getInt('last_seen_notification_id') ?? 0;

      final notifications = await NotificationsProvider.fetchNotificationsWithIndex();
      final unreadCount = notifications.where((n) => (n['id'] as int) > lastSeenId).length;

      if (mounted) {
        setState(() {
          _unreadNotificationsCount = unreadCount;
        });
      }
    } catch (e) {
      print('Error loading unread notification count: $e');
      // Set count to 0 if there's an error
      if (mounted) {
        setState(() {
          _unreadNotificationsCount = 0;
        });
      }
    }
  }

  void _markNotificationsAsSeen(int lastId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_seen_notification_id', lastId);
    if (mounted) {
      setState(() {
        _unreadNotificationsCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final isAdmin = user?['role'] == 'admin';
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isLargeScreen = screenSize.width > 900;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(isAdmin, isTablet),
              SizedBox(height: isTablet ? 24.0 : 20.0),
              Text(
                'MENASYP 2025 Schedule',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 28.0 : 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isTablet ? 12.0 : 8.0),
              Text(
                'August 27-29, 2025 • Tunis, Tunisia',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: isTablet ? 16.0 : 14.0,
                ),
              ),
              SizedBox(height: isTablet ? 24.0 : 20.0),
              _buildDaySelector(isTablet),
              SizedBox(height: isTablet ? 24.0 : 20.0),
              _isLoading
                  ? const Expanded(
                      child: Center(
                        child: SpinKitFadingCircle(
                          color: Color(0xffFF2057),
                          size: 50.0,
                        ),
                      ),
                    )
                  : Expanded(child: _buildDayContent(_selectedDay, isTablet)),
            ],
          ),
        ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: const Color(0xffFF2057),
              onPressed: () => _showAddEventDialog(context),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildAppBar(bool isAdmin, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/logo_horizontal.png', height: isTablet ? 48 : 40),
        Row(
          children: [

                          IconButton(
                icon: Icon(Icons.info_outline, color: Colors.white70, size: isTablet ? 32 : 26),
                onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const TunisiaGuidePage()),
                );
              },
            ),
            const SizedBox(width: 8),
            Stack(
              children: [
                                  IconButton(
                    icon: Icon(Iconsax.notification, color: Colors.white70, size: isTablet ? 32 : 26),
                    onPressed: () async {
                    try {
                      final userRole = Provider.of<UserProvider>(context, listen: false).user?['role'];
                      final notifications = await NotificationsProvider.fetchNotificationsWithIndex();
                      final maxId = notifications.isNotEmpty
                          ? notifications.map((n) => n['id'] as int).reduce((a, b) => a > b ? a : b)
                          : 0;

                      _markNotificationsAsSeen(maxId);
                      await _loadUnreadNotificationCount();

                      if (mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NotificationsWidget(
                              csvUrl:
                                  "https://docs.google.com/spreadsheets/d/e/2PACX-1vSEAEDhje20E1rev37xZE8xytcj7o4TqC-dqd99o4vQSk_VYLF92oQry6mtatdtPhKoJcd5dXhqutJi/pub?gid=1334086914&single=true&output=csv",
                              userRole: userRole,
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      print('Error loading notifications: $e');
                      // Show a snackbar to inform the user
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Unable to load notifications. Please try again later.'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    }
                  },
                ),
                if (_unreadNotificationsCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xffFF2057),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '$_unreadNotificationsCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDaySelector(bool isTablet) {
    return SizedBox(
      height: isTablet ? 100 : 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _DayChip(day: "Day 1", date: "27 Aug", isActive: _selectedDay == 0, onTap: () => setState(() => _selectedDay = 0), isTablet: isTablet),
          _DayChip(day: "Day 2", date: "28 Aug", isActive: _selectedDay == 1, onTap: () => setState(() => _selectedDay = 1), isTablet: isTablet),
          _DayChip(day: "Day 3", date: "29 Aug", isActive: _selectedDay == 2, onTap: () => setState(() => _selectedDay = 2), isTablet: isTablet),
        ],
      ),
    );
  }

  Widget _buildDayContent(int dayIndex, bool isTablet) {
    final dayEvents = _events.where((e) => e['day'] == (dayIndex + 1).toString()).toList();
    dayEvents.sort((a, b) => _compareTime(a['time'], b['time']));

    return ListView.builder(
      itemCount: dayEvents.length,
      itemBuilder: (context, index) {
        final event = dayEvents[index];
        return _ScheduleItem(
          event: event,
          onDelete: () => _deleteEvent(event['id']),
          isAdmin: Provider.of<UserProvider>(context).user?['role'] == 'admin',
          isTablet: isTablet,
        );
      },
    );
  }

  int _compareTime(String a, String b) {
    try {
      // Handle different time formats
      String startTimeA, startTimeB;
      
      if (a.contains(' - ')) {
        startTimeA = a.split(' - ')[0];
      } else if (a.contains('-')) {
        startTimeA = a.split('-')[0];
      } else {
        startTimeA = a;
      }
      
      if (b.contains(' - ')) {
        startTimeB = b.split(' - ')[0];
      } else if (b.contains('-')) {
        startTimeB = b.split('-')[0];
      } else {
        startTimeB = b;
      }
      
      // Parse hours and minutes
      int hourA, hourB, minuteA, minuteB;
      
      if (startTimeA.contains(':')) {
        final partsA = startTimeA.split(':');
        hourA = int.parse(partsA[0]);
        minuteA = int.parse(partsA[1]);
      } else {
        // Handle format like "00-10" where it might be "00" hours and "10" minutes
        hourA = int.parse(startTimeA);
        minuteA = 0;
      }
      
      if (startTimeB.contains(':')) {
        final partsB = startTimeB.split(':');
        hourB = int.parse(partsB[0]);
        minuteB = int.parse(partsB[1]);
      } else {
        // Handle format like "00-10" where it might be "00" hours and "10" minutes
        hourB = int.parse(startTimeB);
        minuteB = 0;
      }

      if (hourA != hourB) return hourA.compareTo(hourB);
      return minuteA.compareTo(minuteB);
    } catch (e) {
      // If parsing fails, return 0 to maintain order
      print('Error parsing time: $a or $b - $e');
      return 0;
    }
  }

  Future<void> _deleteEvent(String id) async {
    try {
      await GoogleSheetApi.deleteEvent(id);
      if (mounted) await _loadEvents();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete event: $e')),
        );
      }
    }
  }

  Future<void> _showAddEventDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final timeController = TextEditingController();
    String selectedType = 'general';
    String selectedDay = '1';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add New Event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                  hintText: 'e.g., Opening Ceremony',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Event description...',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  hintText: 'e.g., 09:00 - 10:30',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: 'general', child: Text('General')),
                  DropdownMenuItem(value: 'food', child: Text('Food')),
                  DropdownMenuItem(value: 'transport', child: Text('Transport')),
                  DropdownMenuItem(value: 'workshop', child: Text('Workshop')),
                  DropdownMenuItem(value: 'ceremony', child: Text('Ceremony')),
                ],
                onChanged: (value) => selectedType = value!,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedDay,
                decoration: const InputDecoration(labelText: 'Day'),
                items: const [
                  DropdownMenuItem(value: '1', child: Text('Day 1 (27 Aug)')),
                  DropdownMenuItem(value: '2', child: Text('Day 2 (28 Aug)')),
                  DropdownMenuItem(value: '3', child: Text('Day 3 (29 Aug)')),
                ],
                onChanged: (value) => selectedDay = value!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isEmpty || timeController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all required fields')),
                );
                return;
              }

              final event = {
                'name': nameController.text,
                'description': descriptionController.text,
                'type': selectedType,
                'time': timeController.text,
                'day': selectedDay,
              };

              final success = await GoogleSheetApi.addEvent(event);
              if (success) {
                Navigator.pop(context);
                if (mounted) {
                  await _loadEvents();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Event added successfully')),
                  );
                }
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to add event')),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }


}

class _DayChip extends StatelessWidget {
  final String day;
  final String date;
  final bool isActive;
  final VoidCallback onTap;
  final bool isTablet;

  const _DayChip({
    required this.day,
    required this.date,
    this.isActive = false,
    required this.onTap,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isTablet ? 110 : 90,
        margin: EdgeInsets.only(right: isTablet ? 16 : 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xffFF2057) : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[400],
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 18 : 16,
              ),
            ),
            SizedBox(height: isTablet ? 6 : 4),
            Text(
              date,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[400],
                fontSize: isTablet ? 14 : 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback? onDelete;
  final bool isAdmin;
  final bool isTablet;

  const _ScheduleItem({
    required this.event,
    this.onDelete,
    required this.isAdmin,
    required this.isTablet,
  });

  IconData _getIconForType(String type) {
    switch (type) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_bus;
      case 'workshop':
        return Icons.workspaces;
      case 'ceremony':
        return Icons.celebration;
      default:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: isTablet ? 60 : 50,
              height: isTablet ? 60 : 50,
              decoration: BoxDecoration(
                color: const Color(0xffFF2057).withOpacity(0.2),
                borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              ),
              child: Icon(
                _getIconForType(event['type'] ?? 'general'),
                color: const Color(0xffFF2057),
                size: isTablet ? 28 : 24,
              ),
            ),
            SizedBox(width: isTablet ? 20 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['time'] ?? '',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: isTablet ? 14 : 12,
                    ),
                  ),
                  SizedBox(height: isTablet ? 6 : 4),
                  Text(
                    event['name'] ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (event['description']?.isNotEmpty ?? false) ...[
                    SizedBox(height: isTablet ? 6 : 4),
                    Text(
                      event['description'] ?? '',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: isTablet ? 14 : 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isAdmin)
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red, size: isTablet ? 28 : 24),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
