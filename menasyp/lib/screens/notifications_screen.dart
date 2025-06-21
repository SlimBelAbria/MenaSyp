import 'package:flutter/material.dart';
import 'dart:async';
import 'package:menasyp/services/notifications_provicder.dart';
import 'package:iconsax/iconsax.dart';

import "package:menasyp/core/theme.dart";

class NotificationsWidget extends StatefulWidget {
  final String csvUrl;
  final String? userRole;

  const NotificationsWidget({Key? key, required this.csvUrl, this.userRole}) : super(key: key);

  @override
  NotificationsWidgetState createState() => NotificationsWidgetState();
}

class NotificationsWidgetState extends State<NotificationsWidget> {
  late Future<List<Map<String, String>>> notificationsFuture;
  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();
    notificationsFuture = _fetchNotifications();
    _startSearchTimer();
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }

  void _startSearchTimer() {
    _searchTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      try {
        final newNotifications = await _fetchNotifications();
        setState(() {
          notificationsFuture = Future.value(newNotifications);
        });
      } catch (_) {}
    });
  }

  Future<List<Map<String, String>>> _fetchNotifications() async {
    await NotificationsProvider.init();
    final rows = await NotificationsProvider.usersheet!.values.allRows();
    if (rows.length <= 1) return [];
    return rows.sublist(1).map((row) => {
      "type": row[2],
      "title": row[0],
      "message": row[1],
    }).toList();
  }

  Future<void> _deleteNotification(int index) async {
    await NotificationsProvider.deleteRow(index + 2);
    setState(() {
      notificationsFuture = _fetchNotifications();
    });
  }

  Widget _getNotificationIcon(String type) {
    IconData iconData;

    switch (type) {
      case 'System':
        iconData = Iconsax.setting_2;
        break;
      case 'Reminder':
        iconData = Iconsax.clock;
        break;
      case 'Event':
        iconData = Iconsax.calendar;
        break;
      default:
        iconData = Iconsax.info_circle;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xffFF2057).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(iconData, color: const Color(0xffFF2057)),
    );
  }

  Future<void> _addNotification() async {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    String? selectedType;

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Add Notification", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Title", Icons.title),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Message", Icons.message),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  dropdownColor: const Color(0xFF2A2A2A),
                  style: const TextStyle(color: Colors.white),
                  value: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                  decoration: _inputDecoration("Type", null),
                  items: ['System', 'Reminder', 'Event'].map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await NotificationsProvider.insert([
                          {
                            "type": selectedType,
                            "title": titleController.text,
                            "message": messageController.text,
                          }
                        ]);
                        setState(() {
                          notificationsFuture = _fetchNotifications();
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFF2057),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Add"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label, IconData? icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: icon != null ? Icon(icon, color: Colors.white54) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xffFF2057)),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, String> notification, int index) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: _getNotificationIcon(notification["type"] ?? 'default'),
        title: Text(
          notification["title"] ?? "N/A",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          notification["message"] ?? "N/A",
          style: const TextStyle(color: Colors.white60),
        ),
        trailing: widget.userRole?.toLowerCase() == 'admin'
            ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteNotification(index),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  backgroundColor,
      appBar: AppBar(
        backgroundColor:  backgroundColor,
        title: const Text("Notifications", style: TextStyle(color: Colors.white)),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xffFF2057)));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No notifications available", style: TextStyle(color: Colors.white70)));
          }

          final notifications = snapshot.data!;
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) => _buildNotificationCard(notifications[index], index),
          );
        },
      ),
      floatingActionButton: widget.userRole?.toLowerCase() == 'admin'
          ? FloatingActionButton.extended(
              onPressed: _addNotification,
              label: const Text("Add Notification"),
              icon: const Icon(Icons.add),
              backgroundColor: const Color(0xffFF2057),
            )
          : null,
    );
  }
}