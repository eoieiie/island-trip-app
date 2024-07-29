/* import 'package:flutter/material.dart';
import '../model/user_profile.dart';
import '../repository/user_profile_repository.dart';

class UserProfileViewModel extends ChangeNotifier {
  final UserProfileRepository _repository = UserProfileRepository();
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserProfile(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _userProfile = await _repository.fetchUserProfile(userId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUserProfile(UserProfile userProfile) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.updateUserProfile(userProfile);
      _userProfile = userProfile;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> uploadProfileImage(String userId, String imagePath) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.uploadProfileImage(userId, imagePath);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
*/