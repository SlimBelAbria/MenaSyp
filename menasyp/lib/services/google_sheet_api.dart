import 'package:gsheets/gsheets.dart';

class GoogleSheetApi {
  static const csvId = '1f83qoxLMt9wOHtMx_wCS7Nwmx-2RgQtsURNgtknr3bk';
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "menasyp",
  "private_key_id": "2307303c338b936fb5c3aa633faaba5d06360cb9",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDEUepRAeOCn3rr\nA5PVkdjWU8psTPDMjKKeq/AJw5gKOIYo4ShmXzdfX/7SKb/HoW8MY/V/ZssxvXaF\nRZN4tEnJNTK+nYPaVOe5NKC7QjDVHS8Ex8XI2VWB/EUFgb+npVKfkw4ro1Im0KpV\nEqGRjqju6oF3MZ1PEywvgh6Qf1inEqXqPTRUN9JC9BVia0MMf3AkyYBoqSgCfEWh\nESLptU4CcjyXJKdODeXu++Fdn87Fpfs1d0H/jGcFhnlY6CDspjVr4wx1tcdPkUKJ\nu+S413qF6UdzsClez3VOY9dhHeex/VTa2qZ73ulMhC6IpmPlorgr0+zMw0Njf9HN\nEMxqHwMvAgMBAAECggEAAqrvLr7Xtrc+hHdBbHb5AliUB0Ob8oK8f90IQv8JwYjp\nGOgAIqan6hTeo3khGCHsOvDDAyXZqpBdv9L6i7OveP8H9H7sH6W6KNI7eq/xdid1\n7HAmhHHZYUaxhk2FZDHqJBDA8fxqRl5O2x8W6dpw+lfsxcje7AgMG/7v4H/m8tRz\nl52tPx1Phzq7g8S/f35BrCLBA/LQOydaHA5X5SuxpOlBTPCw0DUhxo21CBmFP4V7\ncnLWnc3uCQRtJYz9MgRWChRCTdJOosMP19Uv/9By9OmANPQtrDcl4jczQRKtPlLC\nFjO2s0KGfLpIWIk+d6VvTHMJWp79TSMyv3oiU8dnIQKBgQD0x7F1nqVi+uhnkcQW\n1WJI84y8p2+WBVZWz1xMLTRMyCGqD9qEGck6IlUIXCExfFv990gPwa708GBG34JI\nfDvMaietPJbSCe8l+HDInAdr6XUoxRY5VGQPhhu0Om6X7T5guhk6mpI4qmTUcQko\nOYYX2PHd4zcPCt9I8sbx7ChGPwKBgQDNUZSJPNaBhg/vyXydoRDfV5IY3WnP5fOl\nt/3+5aIVhwgqy3PLXb4ENElRihp6XRsDrsl68bjzxlDq94Wy6GPAHahacN9UZteQ\nqw9uGjFI5NN9oxaEAHlLhNUEkd0eW3Bb4YHz21Nn/hy+X1eBv5+YuS/LCstfVUHt\n0Bn/4xFnEQKBgQCZv0RLqJYhEZAgXYJZBTZys+dWJ6UDCd8tL5m9jzcmcx4R/1s1\nViz6gs3+Lj/7IS1223c7zl/iIYmXepQOi1nUD2lUepYQ34SCyQWuO7K9qSmZrhFD\neSpQRd/o2DrW2oEvqDRohuYJCZ3DgixKQ7diCzYANNNEc4PEAhnLopW5aQKBgGEZ\nndexj/i9gDf04BxkGeimL4/W1r3dkHblJxgvXZI0xCYJBgA9mym92JbZa2BHPAln\n1h1wx/lx5r7YxMAxq0smO4JaMyRlZrkiTS/S70/7+BFI2dMfrj2K2ntIyHwc3mx1\nn9HF/hIGWW2nBWl1SHMf0XyC5F93oLBpZIJhzs8hAoGBANKjT+JINcT1ygNqoZoE\nZM7cWlh00HyXYcSv9slZkmt+7dMnYTvd51PKHybaPzYc0gzkubx6/1wez4/ODh0y\n+uvdy6wq1JKyAdn4ot5E3bEtFs2lmtuynOg/6BVNL/ciVllnt67oYoqHPUbQ8uve\nNMN/wUKAU9Ob33ghh4Ck8lz0\n-----END PRIVATE KEY-----\n",
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