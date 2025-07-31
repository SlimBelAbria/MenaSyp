import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:menasyp/core/theme.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);
  @override
  ContactsScreenState createState() => ContactsScreenState();
}

class ContactsScreenState extends State<ContactsScreen> {
  List<Map<String, dynamic>> contacts = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadContacts();
    });
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final contactsJson = prefs.getString('contacts');

      if (contactsJson == null || contactsJson.isEmpty) {
        contacts = _getDefaultContacts();
        await _saveContacts();
      } else {
        contacts = (json.decode(contactsJson) as List)
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }
    } catch (e) {
      contacts = _getDefaultContacts();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> _getDefaultContacts() {
    return [
      {'name': 'Slim Belabria', 'role': 'Mobile App Developer', 'image': '', 'starred': false, 'phone': '25820430'},
    ];
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('contacts', json.encode(contacts));
  }

  void _addNewContact() {
    _nameController.clear();
    _roleController.clear();
    _phoneController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Add New Contact', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogTextField(_nameController, 'Name'),
            const SizedBox(height: 10),
            _buildDialogTextField(_roleController, 'Role'),
            const SizedBox(height: 10),
            _buildDialogTextField(_phoneController, 'Phone Number'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xffFF2057))),
          ),
          TextButton(
            onPressed: () async {
              final name = _nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Name cannot be empty')),
                );
                return;
              }
              setState(() {
                contacts.insert(0, {
                  'name': name,
                  'role': _roleController.text.trim(),
                  'phone': _phoneController.text.trim(),
                  'image': '',
                  'starred': false
                });
              });
              await _saveContacts();
              Navigator.pop(context);
            },
            child: const Text('Add', style: TextStyle(color: Color(0xffFF2057))),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[400]),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Future<bool?> _showDeleteDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Delete Contact', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this contact?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Color(0xffFF2057))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _navigateToContactDetails(int index) {
    final contact = contacts[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor:  backgroundColor,
          appBar: AppBar(
            backgroundColor:  backgroundColor,
            title: const Text('Contact Details'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: _getAvatarColor(contact['name']),
                  child: Text(
                    _getAvatarText(contact['name']),
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Text(contact['name'], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildDetailRow(Icons.badge, contact['role'], Colors.grey[400]!),
                const SizedBox(height: 10),
                _buildDetailRow(
                  Icons.phone,
                  contact['phone'],
                  Colors.white,
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: contact['phone']));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Phone number copied to clipboard')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, Color color, {VoidCallback? onTap}) {
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(color: color, fontSize: 18)),
      ],
    );
    return onTap != null ? InkWell(onTap: onTap, child: row) : row;
  }

  String _getAvatarText(String name) => name.length == 1 ? name[0].toUpperCase() : name.substring(0, 2).toUpperCase();

  Color _getAvatarColor(String name) {
    final colors = [
      const Color(0xffFF2057).withOpacity(0.8),
      Colors.blueAccent.withOpacity(0.8),
      Colors.purpleAccent.withOpacity(0.8),
      Colors.tealAccent.withOpacity(0.8),
      Colors.orangeAccent.withOpacity(0.8),
    ];
    return colors[name.hashCode % colors.length];
  }

  List<Map<String, dynamic>> get filteredContacts {
    if (_searchController.text.isEmpty) return contacts;
    final query = _searchController.text.toLowerCase();
    return contacts.where((contact) =>
      contact['name'].toString().toLowerCase().contains(query) ||
      contact['role'].toString().toLowerCase().contains(query)).toList();
  }

  Widget _buildContactTile(Map<String, dynamic> contact) {
    final index = contacts.indexWhere((c) => c['name'] == contact['name']);
    final name = contact['name'];
    final role = contact['role'];
    final phone = contact['phone'];
    final starred = contact['starred'] == true;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFF1E1E1E),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: _getAvatarColor(name),
            child: Text(
              _getAvatarText(name),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          subtitle: GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: phone));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Phone number copied to clipboard')),
              );
            },
            child: Text(role, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(starred ? Icons.star : Icons.star_border, color: starred ? const Color(0xffFF2057) : Colors.grey[600]),
                onPressed: () => _toggleStar(index),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => _deleteContact(index),
              ),
            ],
          ),
          onTap: () => _navigateToContactDetails(index),
        ),
      ),
    );
  }

  void _toggleStar(int index) {
    setState(() {
      contacts[index]['starred'] = !contacts[index]['starred'];
      _saveContacts();
    });
  }

  Future<void> _deleteContact(int index) async {
    final shouldDelete = await _showDeleteDialog();
    if (shouldDelete == true && mounted) {
      setState(() {
        contacts.removeAt(index);
      });
      await _saveContacts();
    }
  }

  Future<void> _showEmergencyNumbersDialog() async {
    final emergencyContacts = [
      {'name': 'Police (Police Nationale)', 'phone': '197'},
      {'name': 'National Guard (Garde Nationale)', 'phone': '198'},
      {'name': 'Firefighters (Pompiers)', 'phone': '198'},
      {'name': 'Medical Emergency (SAMU)', 'phone': '190'},
      {'name': 'Tourist Police', 'phone': '197'},
    ];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Row(
            children: [
              const Icon(Icons.emergency, color: Colors.red, size: 28),
              const SizedBox(width: 8),
              const Text(
                'Emergency Numbers',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: emergencyContacts.map((contact) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.emergency,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      contact['name']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        contact['phone']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    onTap: () => _callEmergencyNumber(contact['phone']!),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  void _callEmergencyNumber(String number) async {
    final phoneUrl = 'tel:$number';
    try {
      if (await canLaunchUrl(Uri.parse(phoneUrl))) {
        await launchUrl(Uri.parse(phoneUrl));
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch phone dialer')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error making phone call: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _phoneController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(backgroundColor: backgroundColor, body: Center(child: SpinKitFadingCircle(color: Color(0xffFF2057), size: 50.0)))
        : Scaffold(
            backgroundColor:  backgroundColor,
            appBar: AppBar(
              title: const Text('Contacts', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600)),
              backgroundColor:  backgroundColor,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.emergency, color: Colors.red, size: 28),
                  onPressed: _showEmergencyNumbersDialog,
                  tooltip: 'Emergency Numbers',
                ),
                IconButton(icon: const Icon(Icons.add, color: Color(0xffFF2057)), onPressed: _addNewContact),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF2A2A2A)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                        hintText: 'Search contacts...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    children: [
                      if (filteredContacts.any((c) => c['starred'] == true)) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                          child: Text('Favorites', style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        ...filteredContacts.where((c) => c['starred'] == true).map(_buildContactTile).toList(),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                          child: Divider(color: Colors.white24),
                        ),
                      ],
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                        child: Text('All Contacts', style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      ...filteredContacts.where((c) => c['starred'] != true).map(_buildContactTile).toList(),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xffFF2057),
              onPressed: _addNewContact,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          );
  }
}
