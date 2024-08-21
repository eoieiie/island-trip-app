import 'package:flutter/material.dart'; // Flutter의 기본 위젯과 Material 디자인을 사용하기 위한 패키지
import 'package:get/get.dart'; // GetX 패키지를 사용하기 위한 패키지
import 'package:project_island/section/my_page/viewmodel/settings_controller.dart'; // ViewModel인 SettingsController를 가져옴

// SettingView 클래스는 StatelessWidget을 상속받아 상태가 없는 위젯을 생성
class SettingView extends StatelessWidget {
  // SettingsController를 인스턴스화하고 Get.put을 사용하여 DI(의존성 주입)
  final SettingsController controller = Get.put(SettingsController());

  // build 메서드는 위젯 트리를 생성하여 화면에 표시
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar는 상단에 표시되는 앱 바
        centerTitle: true, // 타이틀을 가운데로 정렬
        backgroundColor: Colors.white, // AppBar 배경색 흰색
        elevation: 0, // 그림자 없애기
        title: Text("환경설정", style: TextStyle(fontWeight: FontWeight.bold)), // 앱 바의 제목 텍스트
        leading: Padding(
          // leading은 AppBar의 왼쪽에 표시되는 위젯
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Container(
            // Container는 레이아웃을 위한 위젯으로, 내부 위젯을 감싸서 스타일을 적용할 수 있음
            decoration: BoxDecoration(
              // BoxDecoration을 사용해 스타일 적용
              color: Colors.white, // 배경색 흰색
              borderRadius: BorderRadius.circular(12), // 모서리를 둥글게
              boxShadow: [
                BoxShadow(
                  color: Colors.black26, // 그림자 색상
                  blurRadius: 3, // 그림자 흐림 정도
                  offset: Offset(0, 0), // 그림자의 위치 설정
                ),
              ],
            ),
            child: IconButton(
              // IconButton은 버튼 형태로 아이콘을 표시
              icon: Icon(Icons.close, color: Colors.black), // 닫기 아이콘
              onPressed: () {
                Navigator.pop(context); // 닫기 버튼을 누르면 화면을 닫음
              },
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white, // Scaffold 배경색 흰색
      body: SingleChildScrollView(
        // 스크롤 가능하게 설정
        padding: const EdgeInsets.all(16.0), // 화면 여백 설정
        child: Column(
          // Column 위젯은 수직으로 위젯을 나열
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            // 서비스 전체 알림 섹션 호출
            ServiceNotificationWidget(controller: controller),
            SizedBox(height: 16), // 섹션 간의 간격 추가
            // 서비스 알림 섹션 호출
            SpecificServiceNotificationWidget(controller: controller),
            SizedBox(height: 16), // 섹션 간의 간격 추가
            // 피드 알림 섹션 호출
            FeedNotificationWidget(controller: controller),
            SizedBox(height: 16), // 섹션 간의 간격 추가
            // 이용약관 및 개인정보 처리 방침 섹션 호출
            PolicyWidget(),
            SizedBox(height: 20), // 하단 여백 추가
            Obx(() => ElevatedButton(
              // Obx는 GetX의 상태 관리 기능, 버튼 상태를 동적으로 변경
              onPressed: controller.isChanged.value
                  ? () => controller.saveSettings() // 변경 사항이 있을 때만 저장
                  : null, // 변경 사항이 없으면 버튼 비활성화
              child: Text('저장'), // 버튼 텍스트
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // 버튼 크기 설정
                backgroundColor: controller.isChanged.value
                    ? Colors.green
                    : Colors.grey[300], // 버튼 색상 설정
                foregroundColor: Colors.white, // 텍스트 색상 흰색
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// CustomSwitchListTile 위젯을 생성하여 중복된 코드를 줄임
class CustomSwitchListTile extends StatelessWidget {
  final String title; // SwitchListTile의 제목
  final bool value; // 스위치 상태 값
  final Function(bool) onChanged; // 스위치 변경 시 호출되는 함수

  CustomSwitchListTile({
    required this.title, // 생성자에서 제목 초기화
    required this.value, // 생성자에서 스위치 상태 값 초기화
    required this.onChanged, // 생성자에서 함수 초기화
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      // SwitchListTile은 스위치와 텍스트를 하나로 묶은 위젯
      title: Text(title), // 전달받은 제목을 텍스트로 설정
      value: value, // 전달받은 스위치 상태 값 설정
      onChanged: onChanged, // 전달받은 함수로 스위치 변경 시 동작 설정
      activeColor: Colors.green, // 스위치가 활성화되었을 때의 색상 설정
      activeTrackColor: Colors.green.withOpacity(0.3), // 활성화된 스위치의 트랙 색상
      inactiveThumbColor: Colors.grey, // 비활성화된 스위치의 썸 색상
      inactiveTrackColor: Colors.grey.withOpacity(0.3), // 비활성화된 스위치의 트랙 색상
    );
  }
}

// 서비스 전체 알림 위젯
class ServiceNotificationWidget extends StatelessWidget {
  final SettingsController controller; // ViewModel 컨트롤러를 받아옴

  ServiceNotificationWidget({required this.controller}); // 컨트롤러를 생성자에서 초기화

  @override
  Widget build(BuildContext context) {
    return Container(
      // 각 섹션을 감싸는 컨테이너
      padding: const EdgeInsets.all(16), // 내부 여백 설정
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!), // 테두리 색상 설정
        borderRadius: BorderRadius.circular(10), // 모서리를 둥글게 설정
      ),
      child: CustomSwitchListTile(
        title: '서비스 전체 알림', // 제목 설정
        value: controller.isServiceNotificationEnabled.value, // 스위치 상태 값 설정
        onChanged: (value) => controller.toggleServiceNotification(value), // 스위치 변경 시 호출되는 함수 설정
      ),
    );
  }
}

// 서비스 알림 위젯
class SpecificServiceNotificationWidget extends StatelessWidget {
  final SettingsController controller; // ViewModel 컨트롤러를 받아옴

  SpecificServiceNotificationWidget({required this.controller}); // 컨트롤러를 생성자에서 초기화

  @override
  Widget build(BuildContext context) {
    return Container(
      // 각 섹션을 감싸는 컨테이너
      padding: const EdgeInsets.all(16), // 내부 여백 설정
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!), // 테두리 색상 설정
        borderRadius: BorderRadius.circular(10), // 모서리를 둥글게 설정
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: [
          Text(
            '서비스 알림',
            style: TextStyle(fontWeight: FontWeight.bold), // 텍스트를 굵게 설정
          ),
          CustomSwitchListTile(
            title: '출발 일주일 전 알림', // 제목 설정
            value: controller.isOneWeekBeforeAlertEnabled.value, // 스위치 상태 값 설정
            onChanged: (value) => controller.toggleOneWeekBeforeAlert(value), // 스위치 변경 시 호출되는 함수 설정
          ),
          CustomSwitchListTile(
            title: '출발 하루 전 알림', // 제목 설정
            value: controller.isOneDayBeforeAlertEnabled.value, // 스위치 상태 값 설정
            onChanged: (value) => controller.toggleOneDayBeforeAlert(value), // 스위치 변경 시 호출되는 함수 설정
          ),
          CustomSwitchListTile(
            title: '세부 일정 시작 10분 전 알림', // 제목 설정
            value: controller.isTenMinutesBeforeAlertEnabled.value, // 스위치 상태 값 설정
            onChanged: (value) => controller.toggleTenMinutesBeforeAlert(value), // 스위치 변경 시 호출되는 함수 설정
          ),
        ],
      ),
    );
  }
}

// 피드 알림 위젯
class FeedNotificationWidget extends StatelessWidget {
  final SettingsController controller; // ViewModel 컨트롤러를 받아옴

  FeedNotificationWidget({required this.controller}); // 컨트롤러를 생성자에서 초기화

  @override
  Widget build(BuildContext context) {
    return Container(
      // 각 섹션을 감싸는 컨테이너
      padding: const EdgeInsets.all(16), // 내부 여백 설정
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!), // 테두리 색상 설정
        borderRadius: BorderRadius.circular(10), // 모서리를 둥글게 설정
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: [
          Text(
            '피드 알림',
            style: TextStyle(fontWeight: FontWeight.bold), // 텍스트를 굵게 설정
          ),
          CustomSwitchListTile(
            title: '댓글 알림', // 제목 설정
            value: controller.isCommentNotificationEnabled.value, // 스위치 상태 값 설정
            onChanged: (value) => controller.toggleCommentNotification(value), // 스위치 변경 시 호출되는 함수 설정
          ),
          CustomSwitchListTile(
            title: '좋아요 알림', // 제목 설정
            value: controller.isLikeNotificationEnabled.value, // 스위치 상태 값 설정
            onChanged: (value) => controller.toggleLikeNotification(value), // 스위치 변경 시 호출되는 함수 설정
          ),
        ],
      ),
    );
  }
}

// 이용약관 및 개인정보 처리 방침 위젯
class PolicyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // 각 섹션을 감싸는 컨테이너
      padding: const EdgeInsets.all(16), // 내부 여백 설정
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!), // 테두리 색상 설정
        borderRadius: BorderRadius.circular(10), // 모서리를 둥글게 설정
      ),
      child: ListTile(
        title: const Text(
          '이용약관 및 개인정보 처리 방침',
          style: TextStyle(fontWeight: FontWeight.bold), // 텍스트를 굵게 설정
        ),
        trailing: Icon(Icons.arrow_forward_ios), // 오른쪽에 화살표 아이콘 추가
        onTap: () {
          // 이용약관 페이지로 이동하는 함수
        },
      ),
    );
  }
}
