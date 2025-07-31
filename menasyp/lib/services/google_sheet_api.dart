import 'package:gsheets/gsheets.dart';

class GoogleSheetApi {
  static const csvId = '1f83qoxLMt9wOHtMx_wCS7Nwmx-2RgQtsURNgtknr3bk';
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "menasyp",
  "private_key_id": "4d5647e9278a99545a2ca5ee67447c6ba18cbd61",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDppjC+PNkhrnQ+\nOai8cB/+2WCfUpIS7I+ai+M8OtXKyvNiL8Q9OeqPSywXcMpSLuGgoDMFF+X3JMyy\nDL74sNMuDmWEs3fbT9V0q29hKJ338IeDJaRb2+E/h+GkqO5Y8a4RbftLHEx+b68V\nUiUdXLaB8f9A2+CYSjfiv72LJYAyCfjnsk0nYJWnNC5tv67ocbtYDk2fzIVj6KK/\nssfS4CJdhyK3D1bdiWXsEwp27F2DDXReAcbZRkrqb12vOH/ytF4HpRvbC5VcIDiZ\nKqLrRH+tIeatHzfHJ/oJeespL+pQWzQjE4LMbywtfObJlnmoGQG1AQz6o0oBpJ7t\nMKqfG/sJAgMBAAECggEABev1Xkzyf90JCy6w7R22YeImhcM0+o/OT+9tsfAXzQz5\nwCpPwfF+1WTlWC6+ofiYNVb6FA34ARyIp5aVHH52y7sHraZSylcqpMtXhlHeNxN8\ni8FfegiHm/GYsXCqocx2SfDMpqmv8qBoApVTZXwdEAwPGRi5h4KSCggsCKPJrPrx\nUT+choOlkcM8+sIVgiIZdpH7Fdx3O2xhg/lcVxFhQdvGXiGLFvlYtkCZPraC6MVt\nGNaa7qvuMnUfHLBOVFQ85bsS6tbyFeWM2DElJRIpyX1rdaeUr2c99WLIarF1XgzU\nh9uAQt7AqXVINlFiJONcMm2LE2lRQq5P5yjgIyPCRQKBgQD9o/HC4BWPcvNHTJr9\nDA5rfG4wLIRYLIycyE9g3NnGpBACJxrQuyxmQfpmKyC6kyT2O+8SrzQC+TPWZ0vn\nsbSleDirXKZYrssw1tyh4PkD8d7+IWdW5uqj5LB4iVi5ZHoHSpK8BPYQhuupzJ6M\nWpQPlkrofxhi9vO+8yiD24udBwKBgQDr0qLUPRgmgc68l4A0D+0BxJew+KscICV5\nCtO1znVHCP0GrxoYoF6WnRobO1d8NV3NKHAjZjNwG+AzAR3pYR+W906/ayasmG1r\n+rc4B3kgPDs1wB09WlEpqMHFn7SocXmDqmpBjw/CYV/Qs1wJT8DjDGkoMET7FAEV\nYo/jkEGzbwKBgQDL9nMqT4Jm+XwSoNKdnH1YCBafnJzMPv7P8PCMJuzlJPdOk92n\nbmy0ymeukw3dmwgFDosgzk0X+wepaSWL6sYmrfd8LaQC+oShAJcpgb0dY/n7CCeO\npWCYbQVP2LrFUrwicuBuW9r3zVdjEw2INiqMIkKYleOpaYb2zZiN+BVcLwKBgBZl\nWrFtW+3MRiYC/Vn0aT3RvdZAx39UTjrAnHqXsOueHumTl5bfJByJrwEHEbfqGY5y\nWLQD8L6k5xXw9TZE0wszUXc8Zd/eWgX3OY9Ipmg5UCY6qIw7F5otPLnYAQA+RpwK\ngyzWuVhshvz7C7KWsGrfstzuOJ7ft3qgcana+WJhAoGBAMmLl6Z4FMuW8P/XYS9r\ndS5iTyQZR1aeX4J3SWIrC/rIkXVeCKULcnCcl0Ba7AbwPzQgMxVswGn1dy4cayjj\n252cz8i4/f04QS4WW4zbmTREY2qpJSok8kVQhJsTIPslIi7CD4DXypLtVagnGvat\nwCCOlYGmaPuSi/XEU5KduJHc\n-----END PRIVATE KEY-----\n",
  "client_email": "menasyp@menasyp.iam.gserviceaccount.com",
  "client_id": "109349994561861527005",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/menasyp%40menasyp.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

  ''';

  static final _gsheets = GSheets(_credentials);

  static Worksheet? _notificationsSheet;
  static Worksheet? _scheduleSheet;
  static Worksheet? _feedbackSheet;
  static Worksheet? _guideSheet;
  static Worksheet? _complaintsSheet;

  /// === INIT ALL SHEETS ===
  static Future<void> init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(csvId);
      _notificationsSheet = await _getWorksheet(spreadsheet, title: 'notifications');
      _scheduleSheet = await _getWorksheet(spreadsheet, title: 'schedule');
      _feedbackSheet = await _getWorksheet(spreadsheet, title: 'feedback');
      _guideSheet = await _getWorksheet(spreadsheet, title: 'guide');
      _complaintsSheet = await _getWorksheet(spreadsheet, title: 'complaints');

      // Initialize headers if empty
      final feedbackFirstRow = await _feedbackSheet?.values.row(1);
      if (feedbackFirstRow == null || feedbackFirstRow.isEmpty) {
        await _feedbackSheet?.values.insertRow(1, ['message', 'timestamp']);
      }

      final scheduleFirstRow = await _scheduleSheet?.values.row(1);
      if (scheduleFirstRow == null || scheduleFirstRow.isEmpty) {
        await _scheduleSheet?.values.insertRow(1, ['ID', 'Name', 'Description', 'Type', 'Time', 'Day']);
      }

      final guideFirstRow = await _guideSheet?.values.row(1);
      if (guideFirstRow == null || guideFirstRow.isEmpty) {
        await _guideSheet?.values.insertRow(1, ['id', 'category', 'title', 'description']);
      }

      final complaintsFirstRow = await _complaintsSheet?.values.row(1);
      if (complaintsFirstRow == null || complaintsFirstRow.isEmpty) {
        await _complaintsSheet?.values.insertRow(1, ['id', 'message', 'title', 'type', 'timestamp', 'status']);
      }
    } catch (e) {
      throw Exception('Failed to initialize Google Sheets: $e');
    }
  }

  static Future<Worksheet> _getWorksheet(Spreadsheet spreadsheet, {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  // ========== GUIDE ==========
  static Future<List<Map<String, dynamic>>> getGuideItems() async {
    if (_guideSheet == null) await init();
    final data = await _guideSheet!.values.allRows();
    if (data.isEmpty) return [];

    final headers = data[0];
    final items = <Map<String, dynamic>>[];
    for (var i = 1; i < data.length; i++) {
      final row = data[i];
      if (row.length >= headers.length) {
        final item = <String, dynamic>{};
        for (var j = 0; j < headers.length; j++) {
          item[headers[j].toLowerCase()] = row[j];
        }
        items.add(item);
      }
    }
    return items;
  }

  static Future<bool> addGuideItem({
    required String category,
    required String title,
    required String description,
  }) async {
    try {
      if (_guideSheet == null) await init();
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final row = [id, category, title, description];
      await _guideSheet!.values.appendRow(row);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteGuideItem(String id) async {
    try {
      if (_guideSheet == null) await init();
      final data = await _guideSheet!.values.allRows();
      if (data.isEmpty) return false;

      final headers = data[0];
      final idIndex = headers.indexWhere((h) => h.toLowerCase() == 'id');
      if (idIndex == -1) return false;

      for (var i = 1; i < data.length; i++) {
        if (data[i][idIndex] == id) {
          await _guideSheet!.deleteRow(i + 1);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ========== FEEDBACK ==========
  static Future<bool> addFeedback(String userId, String message) async {
    try {
      if (_feedbackSheet == null) await init();
      final row = {
        'id': userId,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      };
      await _feedbackSheet!.values.map.appendRow(row);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getFeedbackData() async {
    if (_feedbackSheet == null) await init();
    final data = await _feedbackSheet!.values.allRows();
    if (data.isEmpty) return [];

    final headers = data[0];
    final feedbackItems = <Map<String, dynamic>>[];
    for (var i = 1; i < data.length; i++) {
      final row = data[i];
      if (row.length >= headers.length) {
        final item = <String, dynamic>{};
        for (var j = 0; j < headers.length; j++) {
          item[headers[j].toLowerCase()] = row[j];
        }
        feedbackItems.add(item);
      }
    }
    return feedbackItems;
  }

  static Future<bool> deleteFeedback(String id) async {
    try {
      if (_feedbackSheet == null) await init();
      final data = await _feedbackSheet!.values.allRows();
      if (data.isEmpty) return false;

      final headers = data[0];
      final idIndex = headers.indexWhere((h) => h.toLowerCase() == 'id');
      if (idIndex == -1) return false;

      for (var i = 1; i < data.length; i++) {
        if (data[i][idIndex] == id) {
          await _feedbackSheet!.deleteRow(i + 1);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ========== NOTIFICATIONS ==========
  static Future<void> deleteNotification(int rowIndex) async {
    if (_notificationsSheet == null) return;
    final rowLength = await _notificationsSheet!.values.row(rowIndex).then((row) => row.length);
    if (rowLength == 0) return;
    await _notificationsSheet!.values.insertRow(rowIndex, List.filled(rowLength, ''));
  }

  static Future<int> getNotificationsCount() async {
    if (_notificationsSheet == null) return 0;
    final lastRow = await _notificationsSheet!.values.lastRow();
    return lastRow == null ? 0 : int.tryParse(lastRow.first) ?? 0;
  }

  static Future insertNotifications(List<Map<String, dynamic>> rowlist) async {
    if (_notificationsSheet == null) return;
    for (var row in rowlist) {
      await _notificationsSheet!.values.map.appendRow(row);
    }
  }

  // ========== SCHEDULE ==========
  static Future<List<Map<String, dynamic>>> getEvents() async {
    if (_scheduleSheet == null) await init();
    final data = await _scheduleSheet!.values.allRows();
    if (data.isEmpty) return [];

    final headers = data[0];
    final events = <Map<String, dynamic>>[];
    for (var i = 1; i < data.length; i++) {
      final row = data[i];
      if (row.length >= headers.length) {
        final event = <String, dynamic>{};
        for (var j = 0; j < headers.length; j++) {
          event[headers[j].toLowerCase()] = row[j];
        }
        events.add(event);
      }
    }
    return events;
  }

  static Future<bool> addEvent(Map<String, dynamic> event) async {
    try {
      if (_scheduleSheet == null) await init();
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final row = [
        id,
        event['name'],
        event['description'] ?? '',
        event['type'],
        event['time'],
        event['day'],
      ];
      await _scheduleSheet!.values.appendRow(row);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteEvent(String id) async {
    try {
      if (_scheduleSheet == null) await init();
      final data = await _scheduleSheet!.values.allRows();
      if (data.isEmpty) return false;

      final headers = data[0];
      final idIndex = headers.indexWhere((h) => h.toLowerCase() == 'id');
      if (idIndex == -1) return false;

      for (var i = 1; i < data.length; i++) {
        if (data[i][idIndex] == id) {
          await _scheduleSheet!.deleteRow(i + 1);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ========== NOTIFICATION METHODS from Code 2 ==========
  static Future<void> notificationInsert(List<Map<String, dynamic>> rowList) async {
    if (_notificationsSheet == null) return;
    for (var row in rowList) {
      await _notificationsSheet!.values.map.appendRow(row);
    }
  }

  static Future<int> notificationGetRowCount() async {
    if (_notificationsSheet == null) return 0;
    final allRows = await _notificationsSheet!.values.allRows();
    return allRows.length;
  }

  static Future<void> notificationDeleteRow(int rowIndex) async {
    if (_notificationsSheet == null) return;
    final rows = await _notificationsSheet!.values.allRows();
    final totalRows = rows.length;

    if (rowIndex < 1 || rowIndex > totalRows) {
      print('⚠️ Cannot delete. Row index $rowIndex is out of bounds (1–$totalRows).');
      return;
    }

    await _notificationsSheet!.deleteRow(rowIndex);
  }

  static Future<void> notificationInitSheet(Worksheet? sheet, List<String> headers) async {
    if (sheet == null) return;
    final firstRow = await sheet.values.row(1);
    if (firstRow.isEmpty) {
      await sheet.values.insertRow(1, headers);
    }
  }

  // ========== COMPLAINTS ==========
  static Future<List<Map<String, dynamic>>> getComplaints() async {
    if (_complaintsSheet == null) await init();
    final data = await _complaintsSheet!.values.allRows();
    if (data.isEmpty) return [];

    final headers = data[0];
    final complaints = <Map<String, dynamic>>[];
    for (var i = 1; i < data.length; i++) {
      final row = data[i];
      if (row.length >= headers.length) {
        final complaint = <String, dynamic>{};
        for (var j = 0; j < headers.length; j++) {
          complaint[headers[j].toLowerCase()] = row[j];
        }
        complaints.add(complaint);
      }
    }
    return complaints;
  }

  static Future<bool> addComplaint({
    required String message,
    required String title,
    required String type,
  }) async {
    try {
      if (_complaintsSheet == null) await init();
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final row = [id, message, title, type, DateTime.now().toIso8601String(), 'ongoing'];
      await _complaintsSheet!.values.appendRow(row);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteComplaint(String id) async {
    try {
      if (_complaintsSheet == null) await init();
      final data = await _complaintsSheet!.values.allRows();
      if (data.isEmpty) return false;

      final headers = data[0];
      final idIndex = headers.indexWhere((h) => h.toLowerCase() == 'id');
      if (idIndex == -1) return false;

      for (var i = 1; i < data.length; i++) {
        if (data[i][idIndex] == id) {
          await _complaintsSheet!.deleteRow(i + 1);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateComplaintStatus(String id, String status) async {
    try {
      if (_complaintsSheet == null) await init();
      final data = await _complaintsSheet!.values.allRows();
      if (data.isEmpty) return false;

      final headers = data[0];
      final idIndex = headers.indexWhere((h) => h.toLowerCase() == 'id');
      final statusIndex = headers.indexWhere((h) => h.toLowerCase() == 'status');
      
      if (idIndex == -1 || statusIndex == -1) return false;

      for (var i = 1; i < data.length; i++) {
        if (data[i][idIndex] == id) {
          // Update the status in the specific cell
          await _complaintsSheet!.values.insertValue(
            status,
            column: statusIndex + 1,
            row: i + 1,
          );
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}