import 'dart:math'; // Random 클래스를 사용하기 위해 math 패키지 가져오기
import 'package:get/get.dart'; // GetX 패키지 가져오기

class FeedController extends GetxController { // GetxController를 상속받는 FeedController 클래스
  var groupBox = <List<int>>[[], [], []].obs; // 3개의 빈 리스트로 이루어진 groupBox 리스트 생성 및 Observable로 선언
  var groupIndex = [0, 0, 0].obs; // 3개의 0으로 초기화된 groupIndex 리스트 생성 및 Observable로 선언
  var isLoading = false.obs; // 로딩 상태를 나타내는 변수, 초기값은 false

  @override
  void onInit() {
    super.onInit();
    initializeGroupBox(); // groupBox 초기화
  }

  void initializeGroupBox() {
    if (groupIndex.isNotEmpty) {
      for (var i = 0; i < 100; i++) {
        var minIndex =
        groupIndex.indexOf(groupIndex.reduce((a, b) => a < b ? a : b)); // 최소 인덱스 찾기
        var size = 1;
        if (minIndex != 1) {
          size = Random().nextInt(100) % 2 == 0 ? 1 : 2; // 랜덤 사이즈 결정
        }
        groupBox[minIndex].add(size); // groupBox에 추가
        groupIndex[minIndex] += size; // groupIndex 업데이트
      }
    }
  }
}
