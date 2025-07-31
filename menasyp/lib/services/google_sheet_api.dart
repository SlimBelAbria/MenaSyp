import 'package:gsheets/gsheets.dart';

class GoogleSheetApi {
  static const csvId = '1f83qoxLMt9wOHtMx_wCS7Nwmx-2RgQtsURNgtknr3bk';
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "menasyp",
  "private_key_id": "562be57798c017218f02ad815117c997e9df0501",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDZEKd0825OW6lO\nbEH4LQyj1hu/aX1njlMYiH2oCDI0TzAYN+ACJQQLlamTdZnqF2KHqVpnj3EvIJ/x\n1Nfx3+D8NceiaDngod8gqOVkRqJVDUXYFask8bUryf8v/t5IWINZ3/aK7d+kN2MN\nyd/lNlSWTJHyhVSCpZLKxqqR3URQmq8ToJXGivGtroWqdLfW/SJhWQkIefwtfnrw\nM6aaHPci5I6MVJnho7Xq5EldnxfRDW7aSoDBCoLG8jHP7eaMTphNs1GB49n8iV8T\nQ2Q2sxp3onOym8QoR0dtB6TbB6r0ZG/5FDN9ySARz6fN9U6o/tYvs0Tf0qQuQSxB\nk4z4z/+BAgMBAAECggEAA9jwWOm0LbIg+f1//VfCErjZsM68POzIQwXvUT5E8omp\nSPKblzoj/FcUpIMX/W7Y7Z3mNvHzUAIoZ5tN0REWbi3/Wfz2Mqm32F66Aykf2TlV\nILeAmzToEMzBp86BDt/3wwzt1ChTd5gOOsk2XVwVS30ztIxhszefVpYHIbL98h5F\nasMz4RGFl/RwnEj+vfiRZydCoNYXUWFebneIyHvaJH1R4Ex1HI1spT37jiAhKD5s\nru/3LiCH3Q3EVhjLGcu8YwoFoMvuz4bFPUM7sIUvyovD9z2eWuJKpKsvXJBt0k9L\nR2q5i6sBcXxPjtV417lZ0WmABEhy8a+MSi1G1cA82QKBgQDwBKADqXk04IB0j9O2\naB8e37KkTrMwmtlFzvlhNwiolePdZESaIjhlvehf9wFHGjJBd82d017W5VpHW4cW\nU+Mf/vSeETJbqev3+5OFPrvFQUhsb8S60xkWrlZo/W3qJ1PVONw7rDrutF73Bawm\nGqWXr5bGlLax8BWd6G5163yA+QKBgQDnhMT7SSPF5beuKJKCci/wx8cc8V/X5JX8\n1MNSBwNPRj29VX9k0VhC/7Hvmk9oVjN7wrTWWKWHxnUz2BFfSHYCCkgZYPpOQtb5\nR8qML/FQXiU+mlcVkDXQquVY5qeigEqu0GpxjC3jrsKGYdtsxp0Ag/P1fBGe9tnh\n/QLRde+cyQKBgEs7R+Sd9E3sqJbglh2wmUCWIWp6+JOdlcjZzTT5iQ8+nEPCr/YY\nD9FkKzgZNh9RSLtYj+yOWkXFcfy35anL9X8L7SS2gzBUHJCIHH9BYJ29jrPefK2K\niWygjJkwBonEdfR5dB6IJ5i2lKWc846l/42CDiKEbpdrh3sNZcI0Y7wRAoGAI5Z7\nGQ1jHFZ1Z6YA72BSEjcDWmWYD/2pOJYT+BXv4k2vy9zKmlq7sIDRfz0/G5C0lT+W\nwKQbvcU52uBJu1XOHf4qmwwXLdSEawkoD2iHNY1jOD5NSJlETHEYlBPQjOAfmsOa\nuR2NKESCzllYe14EYEHoTEHoC4FyeJSFzGDOllECgYBMAzJ1qT2FgrQjwWH3kbeZ\nKJw0IG6ivkCLUbYRxn+9CLLwM4qhFVrTQMKYnDKT7egWweux5G4oX8kQDl+diSCA\n+1cIIY+2BWigwCm4TKrEAHfoWIbbiApOKXyGon8QvmHwiTh2/bU1wHDvF2wZX4g7\nTmLxQGZBqtSkxyMLiHfPXg==\n-----END PRIVATE KEY-----\n",
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
        await _complaintsSheet?.values.insertRow(1, ['id', 'message', 'title', 'type', 'timestamp']);
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
      final row = [id, message, title, type, DateTime.now().toIso8601String()];
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
}