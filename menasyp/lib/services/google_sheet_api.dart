import 'package:gsheets/gsheets.dart';

class GoogleSheetApi {
  static const csvId = '1f83qoxLMt9wOHtMx_wCS7Nwmx-2RgQtsURNgtknr3bk';
  static const _credentials = r'''
  {
    "type": "service_account",
    "project_id": "menasyp",
    "private_key_id": "f6d8d379991d4e6557055be6cdbceba764fb0e91",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCcqFW11OLDEhSJ\ndb7U6YNt/8vY/08d7beK6+25d0byVUUauJGTj6G6zwvLUTodj0l8c/N15sMmROYN\n9I1mWiAl8OeznunsC3TCzUz25mocwTyHEUMxWMOxV9NXuIcduefS48EpElcZaKCV\nyDzAw0t79uyz18pfqIc/NX+YIqPH0ku8Rq/Qan1AYUw/DJ+4TEG6JVNCkFUH1kP7\nnqBEcDBX+8smHSGmNfbvTW4SNdU06qt0f/Cy9bxprEA0OKGq8aO9k42RxDqZWPa5\nc0e55UX+N0l41ZykuoKyKgGlrrRl8ob2SzYIap6nmrypVTCeIPKYVcJP99JLo5OE\nJ1PjXlmPAgMBAAECggEAN0jQtpKiU+UVik0bQ1gFIdSbw8CV0yIJG+WWx1TonKyq\n7nskJMcTdDGNH/tSXwwqCtmAmaMOS3sVFOew3uX/YmRZ4HG8a6i/U9/PwXIfEHbB\nPYlCBTAmH3e3BcYBKORqg2oMyMnIIxdhVHqNthk1klHZxr3olUmMMSpYFQBkfCeV\nZTiO0lozpXWtE5YRCQfpvB/a39KplIRHUxKRbbuo7zOqRe3IAR1e7FohcQbqSsgv\nVrLjZ8TwNS4Z99Qug+p7ncUrupEcdc0PMbtRSJzxAGtJ1RjF1GyBleHgh5b/ntuk\nVfO3bv11nxkOOKVhKU4EOHXaS+AxtMc/8dcIKFDXQQKBgQDLjncfqSQiLZYljzFj\nworeebR9hy82M9f7BXt+KT+BwWw6k8wxrrUslQk70EEROb8P26lMxbkfhySjqSHV\nHY3xX+pvv8ifieEd/v4bKjb1PVrO682leI9QdxRYOm/fGHjP+aYRtXYAw7ZD5P0m\nLOIdhdWQsrmHjN1RG98f1R2Q7QKBgQDFBKhKV+C4w4asYm2lWGPvpf2kPFYf5ljU\nb5uZ0sm2WVJFdoK5yThbBnxco3JLLeHpAK8I7wEEuztg+Lw64qcWx476OcyYl9HC\nP/beD9VZMeSZt2sFddEphsHSZtK4uXid6M8k00zDHp2/2rUWaUj0WPbSOdyluGNi\nc1y5mOmQ6wKBgGjt5Hw+nXC83RQ5bzVEmH88b4zxvaWMLf6pAdK0ApeplFfRzkWi\nEKSNovfhT1lI0jOjgO8hUV9uM7Xlvpn0JTJSxi+axhlvYssqoeRw62mZmhDmPtjY\nf8/zwloErZxsKgLTZwbj6pNUT8VJ6jDenCSp08BGURsNwxxHaMoo+pe1AoGAP+vN\n6iju2SNe+2kH6ABwlB1H2NRWoQzsPyhi1JqGJWp/fdgAe+SkKyxEhw3klC2zwRQe\ntghNTUqt7j1lXLmSuppOcjL0hYGkZaC5KLz8XG8KmzDeQSxDi3SUR/5iWdqbHqid\nJHaFzjyNs+Ryom3QZK7EjdqGEyJq5FNHf1P0W7cCgYEAxieezb2EIv6G06U7OOUs\n7CagiKjoSojD/SGX/gvBxKzvC6GGOmEgmvDJSrjzPan1HTSV3c8R8C0gYeN2vgA0\nULdNPrjaxqQLua/shXM5L0fbii+MAl3pzcy6dIP2LTUNdzg4u1pAVglhr2FAWsCG\nCZkHnAkz3FntAcshZGp1Ibs=\n-----END PRIVATE KEY-----\n",
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

  /// === INIT ALL SHEETS ===
  static Future<void> init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(csvId);
      _notificationsSheet = await _getWorksheet(spreadsheet, title: 'notifications');
      _scheduleSheet = await _getWorksheet(spreadsheet, title: 'schedule');
      _feedbackSheet = await _getWorksheet(spreadsheet, title: 'feedback');
      _guideSheet = await _getWorksheet(spreadsheet, title: 'guide');

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
}