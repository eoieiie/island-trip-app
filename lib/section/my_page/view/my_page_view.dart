import 'dart:math'; // Random 클래스를 사용하기 위해 math 패키지 가져오기
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 라이브러리를 가져오기
import 'package:get/get.dart'; // GetX 라이브러리 가져오기

import 'package:project_island/section/my_page/view/profile_edit_view.dart'; // 프로필 편집 화면 가져오기
import 'package:project_island/section/my_page/view/setting_view.dart'; // 설정 화면 가져오기
import 'package:project_island/section/feed/view/photo_detail_view.dart'; // 사진 상세보기 화면 가져오기

import 'package:project_island/section/my_travel/view/travel_schedule_view.dart'; // 여행 일정 화면 가져오기
import 'package:project_island/section/my_travel/view/island_selection_view.dart'; // 섬 선택 화면 가져오기

import 'package:project_island/section/my_travel/viewmodel/my_travel_viewmodel.dart'; // 여행 뷰모델 가져오기

import 'package:intl/intl.dart'; // 날짜 포맷 라이브러리 가져오기
import 'package:project_island/section/my_travel/model/my_travel_model.dart'; // 여행 모델 가져오기

// MyPageView 위젯의 상태를 관리하는 StatefulWidget입니다.
class MyPageView extends StatefulWidget {
  @override
  _MyPageViewState createState() => _MyPageViewState();
}

// _MyPageViewState 클래스는 MyPageView의 상태를 관리
class _MyPageViewState extends State<MyPageView> {
  List<List<int>> groupBox = [[], [], []]; // 3개의 빈 리스트로 이루어진 groupBox 리스트 생성
  List<int> groupIndex = [0, 0, 0]; // 3개의 0으로 초기화된 groupIndex 리스트 생성

  int _selectedIndex = 0; // 선택된 페이지 인덱스를 저장
  PageController _pageController = PageController(); // 페이지 전환을 위한 컨트롤러

  @override
  void initState() { // 상태 초기화 메서드
    super.initState();

    if (groupIndex.isNotEmpty) { // groupIndex가 비어있지 않으면
      for (var i = 0; i < 100; i++) { // 100번 반복
        var minIndex = groupIndex.indexOf(groupIndex.reduce((value, element) => value < element ? value : element)); // 가장 작은 값을 가진 인덱스 찾기
        var size = 1; // 기본 크기 1로 설정
        if (minIndex != 1) { // 인덱스가 1이 아니면
          size = Random().nextInt(100) % 2 == 0 ? 1 : 2; // 랜덤으로 1 또는 2 할당
        }
        groupBox[minIndex].add(size); // 해당 인덱스에 크기 추가
        groupIndex[minIndex] += size; // 해당 인덱스 크기 업데이트
      }
    }
  }

  // 하단 네비게이션 아이템이 탭될 때 호출되는 함수
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 선택된 인덱스를 업데이트
    });
    _pageController.jumpToPage(index); // 해당 페이지로 이동
  }

  // 프로필 편집 페이지로 이동하는 함수입니다.
  void _goToProfileEditPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileEditView()), // 프로필 편집 페이지로 이동
    );
  }

  // 설정 페이지로 이동하는 함수입니다.
  void _goToSettingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingView()), // 설정 페이지로 이동
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0), // 상하 패딩 설정
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 끝에 정렬
                children: [
                  GestureDetector(
                    onTap: _goToProfileEditPage, // 프로필 편집 페이지로 이동
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0), // 여백 설정
                          child: CircleAvatar(
                            radius: 30, // 원형 아바타 반지름 설정
                            backgroundColor: Colors.grey, // 배경색 설정
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                          children: [
                            Text(
                              '불금엔제주턱시도', // 사용자 이름
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // 텍스트 스타일 설정
                            ),
                            Text(
                              '한 줄 소개', // 사용자 소개
                              style: TextStyle(fontSize: 14, color: Colors.grey), // 텍스트 스타일 설정
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios), // 오른쪽 화살표 아이콘
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.settings), // 설정 아이콘
                    onPressed: _goToSettingPage, // 설정 페이지로 이동
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white, // 배경색 설정
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, // 공간을 균등하게 배분
                children: [
                  IconButton(
                    icon: Icon(Icons.photo, color: _selectedIndex == 0 ? Colors.blue : Colors.black), // 선택된 상태에 따른 색상 변경
                    onPressed: () {
                      _onItemTapped(0); // 첫 번째 아이템 선택
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.card_giftcard, color: _selectedIndex == 1 ? Colors.blue : Colors.black), // 선택된 상태에 따른 색상 변경
                    onPressed: () {
                      _onItemTapped(1); // 두 번째 아이템 선택
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 2, // 높이 설정
              color: Colors.grey[200], // 배경색 설정
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: _selectedIndex == 0 ? Colors.blue : Colors.transparent, // 선택된 상태에 따른 색상 변경
                      height: 2, // 높이 설정
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: _selectedIndex == 1 ? Colors.blue : Colors.transparent, // 선택된 상태에 따른 색상 변경
                      height: 2, // 높이 설정
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController, // 페이지 컨트롤러 설정
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index; // 페이지 변경 시 인덱스 업데이트
                  });
                },
                children: [
                  LeftPage(groupBox: groupBox), // groupBox를 전달
                  RightPage(), // RightPage 추가
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// LeftPage 위젯입니다.
class LeftPage extends StatelessWidget {
  final List<List<int>> groupBox; // groupBox 리스트를 받아옴

  const LeftPage({Key? key, required this.groupBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // 시작 위치에서 정렬
        children: List.generate( // 3개의 그룹 생성
          groupBox.length,
              (index) => Expanded(
            child: Column(
              children: List.generate(
                groupBox[index].length,
                    (jndex) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoDetailView(
                          // 여기에서 PhotoDetailView로 전달할 인자 설정
                          // 예를 들어, 이미지 URL 또는 ID를 전달할 수 있습니다.
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.33 * groupBox[index][jndex], // 크기 설정
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white), // 경계선 설정
                      color: Colors.primaries[
                      Random().nextInt(Colors.primaries.length)], // 랜덤 색상 설정
                    ),
                  ),
                ),
              ).toList(),
            ),
          ),
        ).toList(),
      ),
    );
  }
}

// RightPage 위젯입니다.
class RightPage extends StatelessWidget {
  final MyTravelViewModel travelViewModel = Get.put(MyTravelViewModel()); // 뷰모델 인스턴스 생성

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (travelViewModel.isLoading.value) {
        return Center(child: CircularProgressIndicator()); // 로딩 중일 때 로딩 인디케이터 표시
      } else if (travelViewModel.travels.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('여행 리스트가 없습니다.'), // 여행 리스트가 없을 때 메시지 표시
              SizedBox(height: 16), // 간격 조정
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IslandSelectionView()), // 섬 선택 페이지로 이동
                  );
                },
                child: Text('새로운 섬캉스 떠나기!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)), // 버튼 텍스트 스타일 설정
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48), // 버튼 크기 설정
                  backgroundColor: Colors.blueAccent, // 버튼 배경색 설정
                ),
              ),
            ],
          ),
        );
      } else {
        travelViewModel.travels.sort((a, b) => b.updatedAt.compareTo(a.updatedAt)); // 수정 시간 순으로 정렬
        return ListView.builder(
          itemCount: travelViewModel.travels.length, // 여행 리스트 길이만큼 항목 생성
          itemBuilder: (context, index) {
            final travel = travelViewModel.travels[index]; // 현재 인덱스의 여행 가져오기
            return Dismissible(
              key: Key(travel.id), // Dismissible 위젯의 키 설정
              direction: DismissDirection.endToStart, // 스와이프 방향 설정
              background: Container(
                color: Colors.red, // 배경색 설정
                padding: EdgeInsets.symmetric(horizontal: 20), // 좌우 패딩 설정
                alignment: Alignment.centerRight, // 오른쪽 정렬
                child: Icon(Icons.delete, color: Colors.white), // 삭제 아이콘
              ),
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('삭제 확인'), // 다이얼로그 제목
                      content: Text('정말로 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.'), // 다이얼로그 내용
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false), // 취소 버튼
                          child: Text('취소'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true), // 삭제 버튼
                          child: Text('삭제'),
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) {
                travelViewModel.deleteTravel(travel.id); // 스와이프 후 항목 삭제
              },
              child: TravelCard(
                travel: travel, // 현재 여행 데이터를 전달
                onSave: (updatedTravel) {
                  travelViewModel.updateTravel(index, updatedTravel); // 여행 데이터 업데이트
                },
              ),
            );
          },
        );
      }
    });
  }
}

// TravelCard 위젯입니다.
class TravelCard extends StatelessWidget {
  final TravelModel travel; // 여행 데이터
  final Function(TravelModel) onSave; // 저장 함수

  TravelCard({
    required this.travel, // 여행 데이터를 필수 인자로 받음
    required this.onSave, // 저장 함수를 필수 인자로 받음
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // 전체 패딩 설정
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // 카드 모서리를 둥글게 설정
        child: ListTile(
          title: Text(
            travel.title, // 여행 제목
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // 텍스트 스타일 설정
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: [
              Text(travel.travelStatus, style: TextStyle(color: Colors.grey)), // 여행 상태 표시
              SizedBox(height: 8.0), // 간격 조정
              Text(travel.island, style: TextStyle(fontSize: 16)), // 섬 이름 표시
              Text('${DateFormat('yyyy-MM-dd').format(travel.startDate)} ~ ${DateFormat('yyyy-MM-dd').format(travel.endDate)}', style: TextStyle(color: Colors.grey)), // 여행 날짜 표시
              Text('최근 수정: ${DateFormat('yyyy-MM-dd HH:mm').format(travel.updatedAt)}', style: TextStyle(color: Colors.grey)), // 최근 수정 시간 표시
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit), // 수정 아이콘
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return EditTravelDialog(
                    travel: travel, // 현재 여행 데이터를 전달
                    onSave: onSave, // 저장 함수 전달
                  );
                },
              );
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TravelScheduleView(travelId: travel.id), // 여행 일정 페이지로 이동
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatUpdatedAt(DateTime updatedAt) {
    final now = DateTime.now(); // 현재 시간
    final difference = now.difference(updatedAt); // 수정 시간과 현재 시간의 차이 계산

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전 편집됨'; // 60분 이내
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전 편집됨'; // 24시간 이내
    } else {
      return '${difference.inDays}일 전 편집됨'; // 그 이상
    }
  }
}

// EditTravelDialog 위젯입니다.
class EditTravelDialog extends StatefulWidget {
  final TravelModel travel; // 여행 데이터
  final Function(TravelModel) onSave; // 저장 함수

  EditTravelDialog({
    required this.travel, // 여행 데이터를 필수 인자로 받음
    required this.onSave, // 저장 함수를 필수 인자로 받음
  });

  @override
  _EditTravelDialogState createState() => _EditTravelDialogState();
}

class _EditTravelDialogState extends State<EditTravelDialog> {
  late TextEditingController _titleController; // 제목 컨트롤러
  late DateTime _startDate; // 시작 날짜
  late DateTime _endDate; // 종료 날짜

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.travel.title); // 제목 초기화
    _startDate = widget.travel.startDate; // 시작 날짜 초기화
    _endDate = widget.travel.endDate; // 종료 날짜 초기화
  }

  @override
  void dispose() {
    _titleController.dispose(); // 제목 컨트롤러 해제
    super.dispose();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate), // 초기 날짜 범위 설정
      firstDate: DateTime(2020), // 선택할 수 있는 첫 번째 날짜
      lastDate: DateTime(2100), // 선택할 수 있는 마지막 날짜
    );
    if (picked != null && picked != DateTimeRange(start: _startDate, end: _endDate)) {
      setState(() {
        _startDate = picked.start; // 선택한 시작 날짜로 설정
        _endDate = picked.end; // 선택한 종료 날짜로 설정
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('여행 정보 수정'), // 다이얼로그 제목
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController, // 제목 입력 필드
            decoration: InputDecoration(labelText: '여행 이름'), // 라벨 설정
          ),
          SizedBox(height: 20), // 간격 조정
          GestureDetector(
            onTap: () {
              _selectDateRange(context); // 날짜 선택 다이얼로그 열기
            },
            child: AbsorbPointer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                children: [
                  Text('출발', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // 출발 라벨
                  Text(DateFormat('yyyy-MM-dd').format(_startDate)), // 선택한 출발 날짜 표시
                  Text('도착', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // 도착 라벨
                  Text(DateFormat('yyyy-MM-dd').format(_endDate)), // 선택한 도착 날짜 표시
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // 다이얼로그 닫기
          },
          child: Text('취소'), // 취소 버튼
        ),
        ElevatedButton(
          onPressed: () {
            final updatedTravel = TravelModel(
              id: widget.travel.id, // 여행 ID
              title: _titleController.text, // 수정된 제목
              island: widget.travel.island, // 섬 이름
              startDate: _startDate, // 수정된 시작 날짜
              endDate: _endDate, // 수정된 종료 날짜
              updatedAt: DateTime.now(), // 수정 시간 업데이트
            );
            widget.onSave(updatedTravel); // 수정된 여행 데이터 저장
            Navigator.of(context).pop(); // 다이얼로그 닫기
          },
          child: Text('저장'), // 저장 버튼
        ),
      ],
    );
  }
}
