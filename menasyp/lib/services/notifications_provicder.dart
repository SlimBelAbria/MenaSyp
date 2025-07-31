import 'package:gsheets/gsheets.dart';

class NotificationsProvider {
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
  static Worksheet? notificationsSheet;

  /// Initialize the spreadsheet and notifications worksheet
  static Future<void> init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(csvId);
      notificationsSheet = await _getWorksheet(spreadsheet, title: 'notifications');
    } catch (e) {
      print('Failed to initialize NotificationsProvider: $e');
      // Don't throw the error, just log it and continue
      // This prevents the app from crashing when Google Sheets is unavailable
    }
  }

  /// Get or create worksheet by title
  static Future<Worksheet> _getWorksheet(Spreadsheet spreadsheet, {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  /// Insert notifications into the worksheet
  static Future<void> insert(List<Map<String, dynamic>> rowList) async {
    if (notificationsSheet == null) return;
    for (var row in rowList) {
      await notificationsSheet!.values.map.appendRow(row);
    }
  }

  /// Get the total number of rows
  static Future<int> getRowCount() async {
    if (notificationsSheet == null) return 0;
    final allRows = await notificationsSheet!.values.allRows();
    return allRows.length;
  }

  /// Delete a notification row safely (1-indexed)
  static Future<void> deleteNotification(int rowIndex) async {
    if (notificationsSheet == null) return;

    final rows = await notificationsSheet!.values.allRows();
    final totalRows = rows.length;

    if (rowIndex < 1 || rowIndex > totalRows) {
      print('⚠️ Cannot delete. Row index $rowIndex is out of bounds (1–$totalRows).');
      return;
    }

    await notificationsSheet!.deleteRow(rowIndex);
  }

  /// Initialize header row if empty
  static Future<void> initSheet(Worksheet? sheet, List<String> headers) async {
    if (sheet == null) return;
    final firstRow = await sheet.values.row(1);
    if (firstRow.isEmpty) {
      await sheet.values.insertRow(1, headers);
    }
  }
  static Future<List<Map<String, dynamic>>> fetchNotificationsWithIndex() async {
    try {
      await init();
      if (notificationsSheet == null) {
        print('Notifications sheet not available');
        return [];
      }
      final rows = await notificationsSheet!.values.allRows();
      if (rows.length <= 1) return [];
      return List.generate(rows.length - 1, (i) {
        final row = rows[i + 1];
        return {
          'id': i + 2, // row index starting from 2 (after header)
          'title': row[0],
          'message': row[1],
          'type': row[2],
        };
      });
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }
}
