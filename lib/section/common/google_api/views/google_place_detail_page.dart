import 'package:flutter/material.dart';
import '../models/google_place_model.dart'; // GooglePlaceModel 클래스 임포트

class GooglePlaceDetailPage extends StatelessWidget {
  final GooglePlaceModel place; // GooglePlaceModel 인스턴스 변수 선언

  GooglePlaceDetailPage({required this.place}); // 생성자에서 place 인스턴스 받음

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name), // 앱바에 장소 이름을 제목으로 표시
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 전체 패딩 16.0
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 컨텐츠 왼쪽 정렬
            children: [
              // 장소 정보 섹션 제목
              Text(
                '장소 정보',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // 섹션 제목 스타일
              ),
              SizedBox(height: 10), // 섹션과 다음 요소 사이에 간격 추가

              // 장소 이름
              Text('장소 이름: ${place.name}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10), // 이름과 다음 요소 사이에 간격 추가

              // 주소
              Text('주소: ${place.address}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              // 평점
              if (place.rating != null)
                Text('평점: ${place.rating}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),

              // 영업 상태 출력
              if (place.isOpenNow != null)
                Text(
                  '현재 영업 중: ${place.isOpenNow! ? "Yes" : "No"}', // 영업 중 여부 출력
                  style: TextStyle(fontSize: 16),
                ),
              SizedBox(height: 10),

              // 전화번호
              if (place.phoneNumber != null)
                Text('전화번호: ${place.phoneNumber}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),

              // 웹사이트
              if (place.website != null)
                Text('웹사이트: ${place.website}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),

              // 위도
              if (place.latitude != null)
                Text('위도: ${place.latitude}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),

              // 경도
              if (place.longitude != null)
                Text('경도: ${place.longitude}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),

              // 사진
              place.photoUrls != null && place.photoUrls!.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 사진 리스트를 왼쪽 정렬
                children: [
                  Text('사진:', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10), // 사진과 다음 요소 사이에 간격 추가
                  ListView.builder(
                    shrinkWrap: true, // 리스트뷰가 부모 위젯 크기를 벗어나지 않도록 설정
                    physics: NeverScrollableScrollPhysics(), // 리스트뷰 자체 스크롤 방지
                    itemCount: place.photoUrls?.length ?? 0, // 사진 개수만큼 리스트 아이템 생성
                    itemBuilder: (context, index) {
                      final photoUrl = place.photoUrls![index]; // 현재 인덱스의 사진 URL 가져옴
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0), // 각 사진 하단에 패딩 추가
                        child: Image.network(photoUrl), // 네트워크 이미지를 표시
                      );
                    },
                  ),
                ],
              )
                  : Text('사진이 없습니다.', style: TextStyle(fontSize: 16)), // 사진이 없을 경우 출력
            ],
          ),
        ),
      ),
    );
  }
}
