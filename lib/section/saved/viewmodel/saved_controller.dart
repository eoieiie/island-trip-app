import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:project_island/section/saved/model/saved_model.dart';

class SavedController extends GetxController {
  var savedItems = <SavedItem>[].obs;

  // 저장된 항목을 SharedPreferences에서 불러오는 메서드
  Future<List<SavedItem>> getSavedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final savedItemsJson = prefs.getStringList('savedItems') ?? [];

    // JSON 문자열 리스트를 SavedItem 객체로 변환
    savedItems.assignAll(
      savedItemsJson.map((itemJson) => SavedItem.fromJson(jsonDecode(itemJson))).toList(), // String을 Map으로 변환
    );

    return savedItems;
  }

  // 항목을 저장하는 메서드
  Future<void> saveItem(SavedItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final savedItemsJson = prefs.getStringList('savedItems') ?? [];

    // 새 항목을 JSON으로 변환하여 리스트에 추가
    savedItemsJson.add(jsonEncode(item.toJson()));
    await prefs.setStringList('savedItems', savedItemsJson);

    // UI 업데이트
    savedItems.add(item);
  }

  // 북마크 토글 및 업데이트 메서드
  void toggleBookmark(SavedItem item) {
    item.isBookmarked = !item.isBookmarked;
    saveItem(item); // 북마크 상태 저장
    update(); // UI 업데이트
  }
}
