// lib/section/my_travel/view/my_travel_view.dart

import 'package:flutter/material.dart'; // Flutter의 Material 디자인 라이브러리를 가져옵니다.
import 'package:get/get.dart'; // 상태 관리 및 의존성 주입을 위한 GetX 라이브러리를 가져옵니다.
import 'package:intl/intl.dart'; // 날짜 형식 처리를 위한 intl 라이브러리를 가져옵니다.
import '../model/my_travel_model.dart'; // TravelModel 클래스를 가져옵니다.
import '../viewmodel/my_travel_viewmodel.dart'; // MyTravelViewModel 클래스를 가져옵니다.
import 'island_selection_view.dart'; // IslandSelectionView 페이지를 가져옵니다.

class MyTravelView extends StatelessWidget {
  final MyTravelViewModel travelViewModel = Get.put(MyTravelViewModel()); // MyTravelViewModel을 GetX로 주입합니다.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 일정', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), // 앱바 제목 설정
        centerTitle: true, // 앱바 제목을 가운데로 정렬
      ),
      body: Obx(() {
        if (travelViewModel.isLoading.value) {
          return Center(child: CircularProgressIndicator()); // 로딩 중일 때 로딩 인디케이터를 표시

        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: travelViewModel.travels.length, // 여행 목록의 개수 설정
                  itemBuilder: (context, index) {
                    final travel = travelViewModel.travels[index]; // 각 여행 항목 설정
                    return TravelCard(
                      travel: travel,
                      onSave: (updatedTravel) {
                        travelViewModel.updateTravel(index, updatedTravel); // 여행 정보 업데이트
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0), // 버튼 패딩 설정
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IslandSelectionView()), // IslandSelectionView 페이지로 이동
                    );
                  },
                  child: Text('새로운 섬캉스 떠나기!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)), // 버튼 텍스트 설정
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48), // 버튼 크기 설정
                    backgroundColor: Colors.blueAccent, // 버튼 배경 색상 설정
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}

class TravelCard extends StatelessWidget {
  final TravelModel travel; // 여행 정보를 저장하는 변수
  final Function(TravelModel) onSave; // 여행 정보를 저장하는 함수

  TravelCard({
    required this.travel, // 여행 정보를 전달 받음
    required this.onSave, // 저장 함수 전달 받음
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // 카드 패딩 설정
      child: Card(
        child: ListTile(
          title: Text(
            travel.title, // 여행 제목 표시
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('여행 가기 ${travel.daysUntilTravel}일 전!', style: TextStyle(color: Colors.grey)), // 여행 남은 일수 표시
              SizedBox(height: 8.0),
              Text(travel.island, style: TextStyle(fontSize: 16)), // 섬 이름 표시
              Text('${travel.startDate} ~ ${travel.endDate}', style: TextStyle(color: Colors.grey)), // 여행 날짜 표시
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit), // 수정 아이콘
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return EditTravelDialog(
                    travel: travel, // 여행 정보 전달
                    onSave: onSave, // 저장 함수 전달
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class EditTravelDialog extends StatefulWidget {
  final TravelModel travel; // 여행 정보를 저장하는 변수
  final Function(TravelModel) onSave; // 여행 정보를 저장하는 함수

  EditTravelDialog({
    required this.travel, // 여행 정보를 전달 받음
    required this.onSave, // 저장 함수 전달 받음
  });

  @override
  _EditTravelDialogState createState() => _EditTravelDialogState(); // 상태 생성
}

class _EditTravelDialogState extends State<EditTravelDialog> {
  late TextEditingController _titleController; // 여행 제목을 입력받는 컨트롤러
  late DateTime _startDate; // 시작 날짜
  late DateTime _endDate; // 종료 날짜

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.travel.title); // 초기 제목 설정
    _startDate = widget.travel.startDate; // 초기 시작 날짜 설정
    _endDate = widget.travel.endDate; // 초기 종료 날짜 설정
  }

  @override
  void dispose() {
    _titleController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate), // 초기 날짜 범위 설정
      firstDate: DateTime(2020), // 선택 가능한 첫 날짜
      lastDate: DateTime(2100), // 선택 가능한 마지막 날짜
    );
    if (picked != null && picked != DateTimeRange(start: _startDate, end: _endDate)) {
      setState(() {
        _startDate = picked.start; // 선택된 시작 날짜 업데이트
        _endDate = picked.end; // 선택된 종료 날짜 업데이트
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
            controller: _titleController, // 여행 제목 입력 필드
            decoration: InputDecoration(labelText: '여행 이름'), // 입력 필드 라벨
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              _selectDateRange(context); // 날짜 범위 선택 함수 호출
            },
            child: AbsorbPointer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('출발', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // 출발 날짜 라벨
                  Text(DateFormat('yyyy-MM-dd').format(_startDate)), // 시작 날짜 표시
                  Text('도착', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // 도착 날짜 라벨
                  Text(DateFormat('yyyy-MM-dd').format(_endDate)), // 종료 날짜 표시
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
          child: Text('취소'), // 취소 버튼 텍스트
        ),
        ElevatedButton(
          onPressed: () {
            final updatedTravel = TravelModel(
              title: _titleController.text, // 수정된 제목
              island: widget.travel.island, // 기존 섬 이름
              startDate: _startDate, // 수정된 시작 날짜
              endDate: _endDate, // 수정된 종료 날짜
            );
            widget.onSave(updatedTravel); // 저장 함수 호출
            Navigator.of(context).pop(); // 다이얼로그 닫기
          },
          child: Text('저장'), // 저장 버튼 텍스트
        ),
      ],
    );
  }
}
