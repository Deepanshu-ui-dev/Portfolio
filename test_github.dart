import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  try {
    final heatmapRes = await http.get(Uri.parse('https://github-contributions.vercel.app/api/v1/Deepanshu-ui-dev'));
    if (heatmapRes.statusCode == 200) {
      final heatmapData = jsonDecode(heatmapRes.body) as Map<String, dynamic>;
      final daysList = heatmapData['contributions'] as List<dynamic>;
      // We process only last 365 days
      final lastYear = daysList.take(365).toList().reversed.toList();
      print('Parsed ${lastYear.length} days.');
      if (lastYear.isNotEmpty) {
        print('First: ${lastYear.first}');
        print('Last: ${lastYear.last}');
      }
    } else {
      print('Failed with status: ${heatmapRes.statusCode}');
    }
  } catch (e) {
    print('Exception: $e');
  }
}
