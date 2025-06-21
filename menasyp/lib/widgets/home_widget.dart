import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:menasyp/screens/notifications_screen.dart';
import 'package:menasyp/services/google_sheet_api.dart';
import 'package:menasyp/services/user_provider.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _selectedDay = 0;
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = true;
  bool _isDisposed = false; // Track if widget is disposed

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  void dispose() {
    _isDisposed = true; // Mark as disposed
    super.dispose();
  }

  Future<void> _loadEvents() async {
    if (!mounted || _isDisposed) return; // Check before proceeding
    
    setState(() => _isLoading = true);
    try {
      await GoogleSheetApi.init();
      final events = await GoogleSheetApi.getEvents();
      
      if (!mounted || _isDisposed) return; // Check again before setState
      
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted || _isDisposed) return;
      
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load events: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final isAdmin = user?['role'] == 'admin';

    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(isAdmin),
              const SizedBox(height: 20),
              const Text(
                'MENASYP 2025 Schedule',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'August 27-30, 2025 • Tunis, Tunisia',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              _buildDaySelector(),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(child: _buildDayContent(_selectedDay)),
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

  Widget _buildAppBar(bool isAdmin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/logo_horizontal.png', height: 40),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white70, size: 26),
              onPressed: () => _showInfoDialog(context),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Iconsax.notification, color: Colors.white70, size: 26),
              onPressed: () {
                final userRole = Provider.of<UserProvider>(context, listen: false).user?['role'];
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NotificationsWidget(
                      csvUrl: "https://docs.google.com/spreadsheets/d/e/2PACX-1vSEAEDhje20E1rev37xZE8xytcj7o4TqC-dqd99o4vQSk_VYLF92oQry6mtatdtPhKoJcd5dXhqutJi/pub?gid=1334086914&single=true&output=csv",
                      userRole: userRole,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDaySelector() {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _DayChip(
            day: "Day 1",
            date: "27 Aug",
            isActive: _selectedDay == 0,
            onTap: () => setState(() => _selectedDay = 0),
          ),
          _DayChip(
            day: "Day 2",
            date: "28 Aug",
            isActive: _selectedDay == 1,
            onTap: () => setState(() => _selectedDay = 1),
          ),
          _DayChip(
            day: "Day 3",
            date: "29 Aug",
            isActive: _selectedDay == 2,
            onTap: () => setState(() => _selectedDay = 2),
          ),
          _DayChip(
            day: "Day 4",
            date: "30 Aug",
            isActive: _selectedDay == 3,
            onTap: () => setState(() => _selectedDay = 3),
          ),
        ],
      ),
    );
  }

  Widget _buildDayContent(int dayIndex) {
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
        );
      },
    );
  }

  int _compareTime(String a, String b) {
    final startTimeA = a.split(' - ')[0];
    final startTimeB = b.split(' - ')[0];
    final hourA = int.parse(startTimeA.split(':')[0]);
    final hourB = int.parse(startTimeB.split(':')[0]);
    
    if (hourA != hourB) return hourA.compareTo(hourB);
    
    final minuteA = int.parse(startTimeA.split(':')[1]);
    final minuteB = int.parse(startTimeB.split(':')[1]);
    return minuteA.compareTo(minuteB);
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
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final timeController = TextEditingController();
  String selectedType = 'general';
  String selectedDay = '1';

  final eventTypes = [
    {'value': 'general', 'label': 'General', 'icon': Icons.event},
    {'value': 'Arriavls & check-in', 'label': 'Arriavls & check-in', 'icon': Icons.flight_land},
    {'value': 'food', 'label': 'Food', 'icon': Icons.restaurant},
    {'value': 'transport', 'label': 'Transport', 'icon': Icons.directions_bus},
    {'value': 'workshop', 'label': 'Workshop', 'icon': Icons.workspaces},
    {'value': 'ceremony', 'label': 'Ceremony', 'icon': Icons.celebration},
    {'value': 'breakfast', 'label': 'Breakfast', 'icon': Icons.breakfast_dining},
    {'value': 'lunch', 'label': 'Lunch', 'icon': Icons.lunch_dining},
    {'value': 'dinner', 'label': 'Dinner', 'icon': Icons.dinner_dining},
    {'value': 'tour', 'label': 'Tour', 'icon': Icons.landscape},
    {'value': 'meetup', 'label': 'Meetup', 'icon': Icons.people},
    {'value': 'party', 'label': 'Party', 'icon': Icons.music_note},
    {'value': 'outing', 'label': 'Outing', 'icon': Icons.photo_camera},
    {'value': 'activity', 'label': 'Activity', 'icon': Icons.beach_access},
  ];

  await showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add New Event',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.grey[700]),
                const SizedBox(height: 16),

                // Event Name
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    prefixIcon: const Icon(Icons.title, color: Colors.grey),
                    labelText: 'Event Name',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),

                // Description
                TextFormField(
                  controller: descController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    prefixIcon: const Icon(Icons.description, color: Colors.grey),
                    labelText: 'Description',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),

                // Event Type
                DropdownButtonFormField<String>(
                  value: selectedType,
                  dropdownColor: const Color(0xFF2A2A2A),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    labelText: 'Type',
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.category, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: eventTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type['value'] as String,
                      child: Row(
                        children: [
                          Icon(type['icon'] as IconData, color: const Color(0xffFF2057), size: 20),
                          const SizedBox(width: 10),
                          Text(type['label'] as String),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) => selectedType = value!,
                ),
                const SizedBox(height: 12),

                // Time
                TextFormField(
                  controller: timeController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    prefixIcon: const Icon(Icons.access_time, color: Colors.grey),
                    labelText: 'Time (e.g., 08:00 - 15:00)',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),

                // Day
                DropdownButtonFormField<String>(
                  value: selectedDay,
                  dropdownColor: const Color(0xFF2A2A2A),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    labelText: 'Day',
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: const [
                    DropdownMenuItem(value: '1', child: Text('Day 1 (27 Aug)')),
                    DropdownMenuItem(value: '2', child: Text('Day 2 (28 Aug)')),
                    DropdownMenuItem(value: '3', child: Text('Day 3 (29 Aug)')),
                    DropdownMenuItem(value: '4', child: Text('Day 4 (30 Aug)')),
                  ],
                  onChanged: (value) => selectedDay = value!,
                ),

                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFF2057),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          try {
                            final newEvent = {
                              'name': nameController.text,
                              'description': descController.text,
                              'type': selectedType,
                              'time': timeController.text,
                              'day': selectedDay,
                            };
                            await GoogleSheetApi.addEvent(newEvent);
                            if (mounted) {
                              await _loadEvents();
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to add event: $e')),
                              );
                            }
                          }
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
  
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('About MENASYP 2025', style: TextStyle(color: Colors.white)),
          content: const Text(
            'The IEEE MENASYP 2025 is the annual conference for Young Professionals in the Middle East and North Africa region.',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              child: const Text('OK', style: TextStyle(color: Color(0xffFF2057))),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }


class _DayChip extends StatelessWidget {
  final String day;
  final String date;
  final bool isActive;
  final VoidCallback onTap;

  const _DayChip({
    required this.day,
    required this.date,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xffFF2057) : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[400],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[400],
                fontSize: 12,
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

  const _ScheduleItem({
    required this.event,
    this.onDelete,
    required this.isAdmin,
  });

  IconData _getIconForType(String type) {
    switch (type) {
      case 'food': return Icons.restaurant;
      case 'transport': return Icons.directions_bus;
      case 'workshop': return Icons.workspaces;
      case 'ceremony': return Icons.celebration;
      default: return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xffFF2057).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIconForType(event['type'] ?? 'general'),
                color: const Color(0xffFF2057),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['time'] ?? '',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event['name'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (event['description']?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 4),
                    Text(
                      event['description'] ?? '',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isAdmin)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}