/* import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/feed.dart';

class FeedRepository {
  final String apiUrl = 'https://your-api-url.com';

  Future<List<Feed>> fetchFeeds() async {
    final response = await http.get(Uri.parse('$apiUrl/feeds'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Feed.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load feeds');
    }
  }

  Future<void> uploadFeed(Feed feed) async {
    final response = await http.post(
      Uri.parse('$apiUrl/feeds'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(feed.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to upload feed');
    }
  }
}
*/