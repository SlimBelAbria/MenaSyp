import 'package:http/http.dart' as http; // Import for HTTP requests
import 'package:csv/csv.dart'; // Import for CSV parsing
import 'package:logger/logger.dart'; // Import for logging
class GoogleSheetsService {
  final Logger _logger = Logger();

  // Fetch data from Google Sheets
  Future<List<List<String>>> fetchSheetData(String csvUrl) async {
    try {
      _logger.d("Fetching data from Google Sheets CSV...");
      final response = await http.get(Uri.parse(csvUrl)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _logger.d("Data fetched successfully");
        final csvData = const CsvToListConverter().convert(response.body);
        return csvData.map((row) => row.map((cell) => cell.toString()).toList()).toList();
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      _logger.e("Error fetching data: $e");
      rethrow;
    }
  }

  // Append a new row to Google Sheets
  Future<void> appendRowToSheet(List<String> rowData, String formUrl) async {
    try {
      _logger.d("Appending row to Google Sheets...");
      final url = Uri.parse(formUrl);

      // Ensure the rowData matches the number of form fields
      if (rowData.length != 5) {
        throw Exception("Invalid row data: Expected 5 fields, got ${rowData.length}");
      }

      final response = await http.post(
        url,
        body: {
          'entry.0': rowData[0], // Code
          'entry.1': rowData[1], // Product Name
          'entry.2': rowData[2], // Quantity
          'entry.3': rowData[3], // Scanned By
          'entry.4': rowData[4], // Timestamp
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _logger.d("Row appended successfully");
      } else {
        throw Exception("Failed to append row: ${response.statusCode}. Response: ${response.body}");
      }
    } catch (e) {
      _logger.e("Error appending row: $e");
      rethrow;
    }
  }

  // Save label data to Google Sheets
  Future<void> saveLabelData(List<String> rowData, String formUrl) async {
    await appendRowToSheet(rowData, formUrl);
  }
}