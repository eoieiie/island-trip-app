import 'package:flutter/material.dart';
import '../viewmodels/google_place_view_model.dart'; // ViewModel 임포트
import 'google_place_detail_page.dart'; // 장소 상세 정보 페이지 임포트
import '../models/google_place_model.dart'; // 데이터 모델 임포트

class GoogleSearchPage extends StatefulWidget {
  @override
  _GoogleSearchPageState createState() => _GoogleSearchPageState(); // 상태 생성
}

class _GoogleSearchPageState extends State<GoogleSearchPage> {
  final TextEditingController _controller = TextEditingController(); // 텍스트 필드 컨트롤러
  final GooglePlaceViewModel _viewModel = GooglePlaceViewModel(); // ViewModel 인스턴스 생성
  List<GooglePlaceModel> _places = []; // 검색 결과 저장용 리스트

  // 장소 검색 메서드
  Future<void> _searchPlaces() async {
    final query = _controller.text; // 검색어 가져옴
    if (query.isNotEmpty) {
      try {
        final places = await _viewModel.searchPlaces(query); // 검색 실행
        setState(() {
          _places = places; // 결과를 상태에 저장
        });
      } catch (e) {
        print('Error: $e'); // 오류 발생 시 출력
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Place Search'), // 앱바 제목
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // 패딩 적용
        child: Column(
          children: [
            TextField(
              controller: _controller, // 텍스트 필드 컨트롤러 연결
              decoration: InputDecoration(
                labelText: 'Enter search keyword', // 입력 필드 힌트 텍스트
                suffixIcon: IconButton(
                  icon: Icon(Icons.search), // 검색 아이콘
                  onPressed: _searchPlaces, // 검색 버튼 클릭 시 실행
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _places.length, // 검색 결과 항목 수
                itemBuilder: (context, index) {
                  final place = _places[index]; // 현재 인덱스의 장소 가져옴
                  final thumbnailUrl = place.photoUrls != null && place.photoUrls!.isNotEmpty
                      ? place.photoUrls!.first // 첫 번째 사진을 썸네일로 사용
                      : null;

                  return ListTile(
                    leading: thumbnailUrl != null
                        ? Image.network(
                      thumbnailUrl, // 썸네일 이미지 URL
                      width: 50, // 썸네일 너비
                      height: 50, // 썸네일 높이
                      fit: BoxFit.cover, // 이미지 크기에 맞게 조정
                    )
                        : Icon(Icons.image_not_supported), // 이미지가 없을 때 대체 아이콘
                    title: Text(place.name), // 장소 이름
                    subtitle: Text(place.address), // 장소 주소
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GooglePlaceDetailPage(place: place), // 상세 정보 페이지로 이동
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
