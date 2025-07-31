import 'package:flutter/material.dart';
import 'package:menasyp/services/google_sheet_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:menasyp/core/theme.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  String _selectedType = 'feedback'; // 'feedback' or 'complaints'
  List<Map<String, dynamic>> _feedbackData = [];
  List<Map<String, dynamic>> _complaintsData = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // Load both feedback and complaints data
      final feedbackData = await GoogleSheetApi.getFeedbackData();
      final complaintsData = await GoogleSheetApi.getComplaints();
      
      if (mounted) {
        setState(() {
          _feedbackData = feedbackData;
          _complaintsData = complaintsData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: $e')),
        );
      }
    }
  }

  Widget _buildTypeSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedType = 'feedback'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _selectedType == 'feedback' 
                    ? const Color(0xffFF2057) 
                    : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.feedback,
                      color: _selectedType == 'feedback' 
                        ? Colors.white 
                        : Colors.white70,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Feedback',
                      style: TextStyle(
                        color: _selectedType == 'feedback' 
                          ? Colors.white 
                          : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedType = 'complaints'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _selectedType == 'complaints' 
                    ? const Color(0xffFF2057) 
                    : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.report_problem,
                      color: _selectedType == 'complaints' 
                        ? Colors.white 
                        : Colors.white70,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Complaints',
                      style: TextStyle(
                        color: _selectedType == 'complaints' 
                          ? Colors.white 
                          : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackItem(Map<String, dynamic> feedback) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xffFF2057),
          child: const Icon(Icons.feedback, color: Colors.white),
        ),
        title: Text(
          feedback['message'] ?? 'No message',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (feedback['timestamp'] != null)
              Text(
                'Date: ${DateTime.parse(feedback['timestamp']).toString().split('.')[0]}',
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
              ),
            if (feedback['id'] != null)
              Text(
                'ID: ${feedback['id']}',
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteFeedback(feedback['id']),
        ),
      ),
    );
  }

  Widget _buildComplaintItem(Map<String, dynamic> complaint) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange,
          child: const Icon(Icons.report_problem, color: Colors.white),
        ),
        title: Text(
          complaint['title'] ?? 'No title',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              complaint['message'] ?? 'No message',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    complaint['type'] ?? 'Unknown',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: (complaint['status'] == 'finished' ? Colors.green : Colors.red).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    complaint['status'] ?? 'ongoing',
                    style: TextStyle(
                      color: complaint['status'] == 'finished' ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'ID: ${complaint['id']}',
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                ),
              ],
            ),
            if (complaint['timestamp'] != null) ...[
              const SizedBox(height: 4),
              Text(
                'Date: ${DateTime.parse(complaint['timestamp']).toString().split('.')[0]}',
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                (complaint['status'] == 'finished' ? Icons.refresh : Icons.check_circle),
                color: complaint['status'] == 'finished' ? Colors.orange : Colors.green,
              ),
              onPressed: () => _changeComplaintStatus(
                complaint['id'],
                complaint['status'] ?? 'ongoing',
              ),
              tooltip: complaint['status'] == 'finished' ? 'Mark as Ongoing' : 'Mark as Finished',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteComplaint(complaint['id']),
            ),
          ],
        ),
        onTap: () => _changeComplaintStatus(
          complaint['id'],
          complaint['status'] ?? 'ongoing',
        ),
      ),
    );
  }

  Future<void> _deleteFeedback(String? id) async {
    if (id == null) return;
    
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Delete Feedback', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this feedback?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await GoogleSheetApi.deleteFeedback(id);
        await _loadData(); // Reload data
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Feedback deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete feedback: $e')),
          );
        }
      }
    }
  }

  Future<void> _deleteComplaint(String? id) async {
    if (id == null) return;
    
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Delete Complaint', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this complaint?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await GoogleSheetApi.deleteComplaint(id);
        await _loadData(); // Reload data
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Complaint deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete complaint: $e')),
          );
        }
      }
    }
  }

  Future<void> _changeComplaintStatus(String? id, String currentStatus) async {
    if (id == null) return;
    
    final newStatus = currentStatus == 'ongoing' ? 'finished' : 'ongoing';
    
    try {
      final success = await GoogleSheetApi.updateComplaintStatus(id, newStatus);
      if (success) {
        await _loadData(); // Reload data
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Status changed to $newStatus'),
              backgroundColor: newStatus == 'finished' ? Colors.green : Colors.orange,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update status'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Inbox', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600)),
        backgroundColor: backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTypeSelector(),
          Expanded(
            child: _isLoading
                ? const Center(child: SpinKitFadingCircle(color: Color(0xffFF2057), size: 50.0))
                : _selectedType == 'feedback'
                    ? _feedbackData.isEmpty
                        ? const Center(
                            child: Text(
                              'No feedback available',
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _feedbackData.length,
                            itemBuilder: (context, index) => _buildFeedbackItem(_feedbackData[index]),
                          )
                    : _complaintsData.isEmpty
                        ? const Center(
                            child: Text(
                              'No complaints available',
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _complaintsData.length,
                            itemBuilder: (context, index) => _buildComplaintItem(_complaintsData[index]),
                          ),
          ),
        ],
      ),
    );
  }
} 