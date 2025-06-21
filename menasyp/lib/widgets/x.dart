import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:menasyp/screens/notifications_screen.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  SchedulePageState createState() => SchedulePageState();
}

class SchedulePageState extends State<SchedulePage> {
  int _selectedDay = 0; // 0 for Day 1, 1 for Day 2, etc.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with logo, info, and notification
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/logo_horizontal.png', height: 40),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.info_outline, color: Colors.white70, size: 26),
                        onPressed: () {
                          // Add your info dialog or navigation here
                          _showInfoDialog(context);
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Iconsax.notification, color: Colors.white70, size: 26),
                        onPressed: () {
                           Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) =>const  NotificationsWidget( 
                              csvUrl: "https://docs.google.com/spreadsheets/d/e/2PACX-1vSEAEDhje20E1rev37xZE8xytcj7o4TqC-dqd99o4vQSk_VYLF92oQry6mtatdtPhKoJcd5dXhqutJi/pub?gid=1334086914&single=true&output=csv",
                            userRole: 'admin',))
                            
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              // Rest of your code remains the same...
              const SizedBox(height: 20),
              
              // Schedule title
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
              
              // Day selector
              SizedBox(
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
              ),
              const SizedBox(height: 20),
              
              // Schedule content
              Expanded(
                child: _buildDayContent(_selectedDay),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'About MENASYP 2025',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'The IEEE MENASYP 2025 is the annual conference for Young Professionals in the Middle East and North Africa region.',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xffFF2057)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Rest of your existing methods (_buildDayContent, _DayChip, _ScheduleItem) remain the same...
  Widget _buildDayContent(int dayIndex) {
    switch (dayIndex) {
      case 0: // Day 1
        return ListView(
          children: const [
            _ScheduleItem(
              time: "08:00 - 15:00",
              title: "Arrivals & Check-in",
              subtitle: "Welcome packs distribution",
              icon: Icons.flight_land,
            ),
            _ScheduleItem(
              time: "15:00 - 16:00",
              title: "Opening ceremony preparations",
              icon: Icons.settings,
            ),
            _ScheduleItem(
              time: "16:00 - 20:00",
              title: "Opening Ceremony",
              subtitle: "Municipal Theater of Tunis (+ Coffee Break)",
              icon: Icons.celebration,
              isHighlighted: true,
            ),
            _ScheduleItem(
              time: "20:00 - 21:00",
              title: "Transportation",
              icon: Icons.directions_bus,
            ),
            _ScheduleItem(
              time: "21:00 - 00:00",
              title: "Tunisian Dinner",
              subtitle: "Lmrabet, La medina de Tunis",
              icon: Icons.restaurant,
            ),
          ],
        );
      case 1: // Day 2
        return ListView(
          children: const [
            _ScheduleItem(
              time: "07:00 - 09:00",
              title: "Breakfast",
              icon: Icons.breakfast_dining,
            ),
            _ScheduleItem(
              time: "09:15 - 10:00",
              title: "Transportation",
              icon: Icons.directions_bus,
            ),
            _ScheduleItem(
              time: "10:00 - 12:00",
              title: "Touristic Tours",
              subtitle: "Choose one: Bardo Museum, Carthage Tour, or Military Museum",
              icon: Icons.landscape,
              isHighlighted: true,
            ),
            _ScheduleItem(
              time: "12:00 - 12:30",
              title: "Transportation",
              icon: Icons.directions_bus,
            ),
            _ScheduleItem(
              time: "12:30 - 14:00",
              title: "Lunch",
              icon: Icons.lunch_dining,
            ),
            _ScheduleItem(
              time: "14:15 - 15:15",
              title: "Poster Session",
              icon: Icons.article,
            ),
            _ScheduleItem(
              time: "15:30 - 16:45",
              title: "Workshops",
              subtitle: "Parallel sessions (4 options available)",
              icon: Icons.workspaces,
            ),
            _ScheduleItem(
              time: "16:45 - 17:00",
              title: "Coffee Break",
              icon: Icons.coffee,
            ),
            _ScheduleItem(
              time: "17:00 - 18:00",
              title: "Panel Discussion",
              icon: Icons.forum,
            ),
            _ScheduleItem(
              time: "18:15 - 19:30",
              title: "Workshops",
              subtitle: "Parallel sessions (4 options available)",
              icon: Icons.workspaces,
            ),
            _ScheduleItem(
              time: "20:30 - 00:00",
              title: "Multicultural Night",
              icon: Icons.music_note,
              isHighlighted: true,
            ),
          ],
        );
      case 2: // Day 3
        return ListView(
          children: const [
            _ScheduleItem(
              time: "07:00 - 09:00",
              title: "Breakfast",
              icon: Icons.breakfast_dining,
            ),
            _ScheduleItem(
              time: "09:15 - 09:45",
              title: "Transportation",
              icon: Icons.directions_bus,
            ),
            _ScheduleItem(
              time: "09:45 - 11:15",
              title: "Industrial Visits",
              icon: Icons.factory,
            ),
            _ScheduleItem(
              time: "11:30 - 12:00",
              title: "Transportation",
              icon: Icons.directions_bus,
            ),
            _ScheduleItem(
              time: "12:00 - 13:00",
              title: "Lunch",
              icon: Icons.lunch_dining,
            ),
            _ScheduleItem(
              time: "13:00 - 14:00",
              title: "Friday Prayer",
              subtitle: "Abidin Mosque (Unofficial)",
              icon: Icons.mosque,
            ),
            _ScheduleItem(
              time: "14:00 - 15:30",
              title: "YP Meet-up",
              icon: Icons.people,
            ),
            _ScheduleItem(
              time: "16:00 - 19:00",
              title: "Closing Ceremony",
              subtitle: "At the hotel",
              icon: Icons.celebration,
              isHighlighted: true,
            ),
            _ScheduleItem(
              time: "19:00 - 20:30",
              title: "Dinner",
              icon: Icons.dinner_dining,
            ),
            _ScheduleItem(
              time: "21:00 - 00:00",
              title: "Farewell Party",
              icon: Icons.nightlife,
            ),
          ],
        );
      case 3: // Day 4 (Optional)
        return ListView(
          children: const [
            _ScheduleItem(
              time: "07:00 - 09:00",
              title: "Breakfast",
              icon: Icons.breakfast_dining,
            ),
            _ScheduleItem(
              time: "09:15 - 09:45",
              title: "Transportation",
              icon: Icons.directions_bus,
            ),
            _ScheduleItem(
              time: "10:00 - 11:45",
              title: "Sidi Bou Said Outing",
              icon: Icons.photo_camera,
              isHighlighted: true,
            ),
            _ScheduleItem(
              time: "12:00 - 12:30",
              title: "Transportation",
              icon: Icons.directions_bus,
            ),
            _ScheduleItem(
              time: "12:30 - 14:00",
              title: "Lunch",
              icon: Icons.lunch_dining,
            ),
            _ScheduleItem(
              time: "15:00 - 17:00",
              title: "Beach Activities",
              icon: Icons.beach_access,
            ),
            _ScheduleItem(
              time: "15:00 - 17:00",
              title: "Non-technical Workshops",
              subtitle: "Parallel to beach activities",
              icon: Icons.workspaces,
            ),
          ],
        );
      default:
        return Container();
    }
  }
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
  final String time;
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool isHighlighted;

  const _ScheduleItem({
    required this.time,
    required this.title,
    this.subtitle,
    required this.icon,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFF1E1E1E) : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: isHighlighted
            ? Border.all(color: const Color(0xffFF2057), width: 1.5)
            : null,
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
              child: Icon(icon, color: const Color(0xffFF2057)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}