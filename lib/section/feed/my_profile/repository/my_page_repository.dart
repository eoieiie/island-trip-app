/* import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_profile.dart';

class UserProfileRepository {
  final String apiUrl = 'https://your-api-url.com';

  Future<UserProfile> fetchUserProfile(String userId) async {
    final response = await http.get(Uri.parse('$apiUrl/user/$userId'));

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  Future<void> updateUserProfile(UserProfile userProfile) async {
    final response = await http.put(
      Uri.parse('$apiUrl/user/${userProfile.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userProfile.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user profile');
    }
  }

  Future<void> uploadProfileImage(String userId, String imagePath) async {
    var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/user/$userId/profile-image'));
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to upload profile image');
    }
  }
}
*/