import 'package:gsheets/gsheets.dart';

class NotificationsProvider {
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
  static Worksheet? notificationsSheet;

  /// Initialize the spreadsheet and notifications worksheet
  static Future<void> init() async {
    try {
      // Test the credentials first
      print('Testing Google Sheets credentials...');
      final spreadsheet = await _gsheets.spreadsheet(csvId);
      print('Successfully connected to spreadsheet: ${spreadsheet.data.properties.title}');
      
      notificationsSheet = await _getWorksheet(spreadsheet, title: 'notifications');
      print('Successfully initialized notifications sheet');
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
