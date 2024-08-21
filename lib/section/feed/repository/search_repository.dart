import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore 가져오기

class SearchRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore 인스턴스 생성

  static Future<List<String>> getSearchResults(String query) async {
    // Firestore에서 검색어와 일치하는 데이터를 가져오는 로직
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('searchData')
          .where('query', isEqualTo: query)
          .get();

      // 결과가 없으면 빈 리스트를 반환///////////////////
      if (snapshot.docs.isEmpty) {
        return [];
      }

      // 결과를 리스트로 반환
      return snapshot.docs.map((doc) => doc['query'] as String).toList();
    } catch (e) {
      // Firebase 연동 오류 발생 시 더미 데이터를 반환
      List<String> dummyData = ['울릉도 맛집', '울릉도', '제주도 맛집'];
      return dummyData.where((item) => item.contains(query)).toList();
    }
  }

  static Future<void> saveSearchHistory(List<String> history) async {
    try {
      await _firestore.collection('searchHistory').doc('userHistory').set({
        'history': history,
      });
    } catch (e) {
      // 예외 처리 (로그 저장 등)
    }
  }

  static Future<List<String>> loadSearchHistory() async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('searchHistory').doc('userHistory').get();
      if (doc.exists) {
        return List<String>.from(doc['history'] as List<dynamic>);
      } else {
        return [];
      }
    } catch (e) {
      // Firebase 연동 오류 발생 시 빈 리스트 반환
      return [];
    }
  }

  static Future<void> clearSearchHistory() async {
    try {
      await _firestore.collection('searchHistory').doc('userHistory').delete();
    } catch (e) {
      // 예외 처리 (로그 저장 등)
    }
  }
}
