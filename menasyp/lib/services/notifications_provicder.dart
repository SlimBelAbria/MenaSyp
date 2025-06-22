import 'package:gsheets/gsheets.dart';

class NotificationsProvider {
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
  static Worksheet? notificationsSheet;

  /// Initialize the spreadsheet and notifications worksheet
  static Future<void> init() async {
    final spreadsheet = await _gsheets.spreadsheet(csvId);
    notificationsSheet = await _getWorksheet(spreadsheet, title: 'notifications');
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
  await init();
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
}
}
