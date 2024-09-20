import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/my_travel_viewmodel.dart';
import 'travel_schedule_view.dart';
import 'package:project_island/section/common/google_api/views/google_search_page.dart';


class ScheduleAddView extends StatefulWidget {
  final String travelId;
  final DateTime selectedDate;
  final MyTravelViewModel travelViewModel;
  final String? title;
  final String? startTime;
  final String? endTime;
  final String? memo;

  ScheduleAddView({
    required this.travelId,
    required this.selectedDate,
    required this.travelViewModel,
    this.title, // 기존 일정 제목
    this.startTime, // 기존 일정 시작 시간
    this.endTime, // 기존 일정 종료 시간
    this.memo, // 기존 메모
  });

  @override
  _ScheduleAddViewState createState() => _ScheduleAddViewState();
}

class _ScheduleAddViewState extends State<ScheduleAddView> {
  FixedExtentScrollController _hoursController = FixedExtentScrollController();
  FixedExtentScrollController _minutesController = FixedExtentScrollController();
  int _selectedHour = 12;
  int _selectedMinute = 0;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _memoController = TextEditingController();

  bool _isTitleValid = true;  // 제목 유효성 확인 변수
  final ScrollController _scrollController = ScrollController(); // 화면 스크롤을 위한 컨트롤러

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title ?? '');
    _memoController = TextEditingController(text: widget.memo ?? '');
    _hoursController = FixedExtentScrollController(initialItem: _selectedHour);
    _minutesController = FixedExtentScrollController(initialItem: _selectedMinute);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    _titleController.dispose();
    _memoController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          '일정 추가',
          style: TextStyle(
            fontFamily: 'Pretendard',
            inherit: true,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Color(0xFF222222),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 1.5,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationInput(),
              SizedBox(height: 20),
              _makeline(),
              SizedBox(height: 20),
              _buildTimePicker(),
              SizedBox(height: 20),
              _makeline(),
              SizedBox(height: 20),
              _buildTitleInput(),
              SizedBox(height: 20),
              SizedBox(height: 20),
              _buildMemoInput(),
              SizedBox(height: 20),
              _makeline(),
              //SizedBox(height: 20),
              //_buildPhotoSection(),
              SizedBox(height: 50),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _makeline() {
    return Column(
      children: [
        Container(
          width: 375,
          height: 1,
          decoration: BoxDecoration(color: Color(0xFFF7F7F7)),
        ),
      ],
    );
  }

  Widget _buildLocationInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // "장소 입력" 텍스트 왼쪽 정렬
      children: [
        Text(
          '장소 입력',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GoogleSearchPage()), // GoogleSearchPage로 이동
            );
          },
          child: AbsorbPointer( // TextField의 입력을 막고, 클릭만 가능하게 함
            child: TextField(
              decoration: InputDecoration(
                hintText: '위치 검색',
                contentPadding: EdgeInsets.symmetric(horizontal: 20), // 텍스트와 아이콘에 좌우 패딩 추가
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Color(0xFFC8C8C8), width: 1), // 테두리 색 변경
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Color(0xFFC8C8C8), width: 1), // 활성화 시 테두리 색상
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 12.0), // 아이콘에 오른쪽 패딩 추가
                  child: Icon(
                    Icons.search,
                    color: Color(0xFF1BB874), // 하단 버튼과 동일한 초록색
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16), // 칸 사이 여백 설정
        Center( // 버튼 가운데 정렬
          child: ElevatedButton(
            onPressed: () {
              // 관심 리스트에서 불러오는 기능 추가 가능
            },
            child: Text(
              '관심 리스트에서 불러오기',
              style: TextStyle(
                fontWeight: FontWeight.w100,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF222222),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }




  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // 텍스트와 별표가 같은 줄에 배치
              children: [
                Text(
                  '시간 선택 ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '*', // 별표 기호
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.red, // 별표는 빨간색
                  ),
                ),
              ],
            ),
            Text(
              "${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1BB874),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHourPicker(),
            Text(':', style: TextStyle(fontSize: 24, color: Colors.grey)),
            _buildMinutePicker(),
          ],
        ),
      ],
    );
  }

  Widget _buildHourPicker() {
    return SizedBox(
      height: 150,
      width: 60,
      child: ListWheelScrollView.useDelegate(
        controller: _hoursController,
        itemExtent: 50,
        physics: FixedExtentScrollPhysics(), // 딱딱 멈추게 하는 설정
        onSelectedItemChanged: (index) {
          setState(() {
            _selectedHour = index;
          });
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            return Center(
              child: Text(
                index.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: 24,
                  color: index == _selectedHour ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
                  fontWeight: index == _selectedHour ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            );
          },
          childCount: 24,
        ),
      ),
    );
  }

  Widget _buildMinutePicker() {
    return SizedBox(
      height: 150,
      width: 60,
      child: ListWheelScrollView.useDelegate(
        controller: _minutesController,
        itemExtent: 50,
        physics: FixedExtentScrollPhysics(), // 딱딱 멈추게 하는 설정
        onSelectedItemChanged: (index) {
          setState(() {
            _selectedMinute = index;
          });
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            return Center(
              child: Text(
                index.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: 24,
                  color: index == _selectedMinute ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
                  fontWeight: index == _selectedMinute ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            );
          },
          childCount: 60,
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('사진 등록', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 90,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFC8C8C8)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: TextButton.icon(
              onPressed: () {
                // 사진 선택 기능 구현
              },
              icon: Icon(Icons.camera_alt, size: 24, color: Colors.black),
              label: Text('사진 선택', style: TextStyle(color: Colors.black)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // 텍스트와 별표가 같은 줄에 배치
          children: [
            Text(
              '일정 제목 ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            Text(
              '*', // 별표 기호
              style: TextStyle(
                fontSize: 15,
                color: Colors.red, // 별표는 빨간색
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: '간단한 제목을 작성해주세요',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFFC8C8C8), width: 1), // 테두리 색 변경 (초록색)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFFC8C8C8), width: 2), // 활성화 시 테두리 색상
            ),
          ),
        ),
        if (!_isTitleValid) // 제목이 유효하지 않을 경우 경고 메시지 출력
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '*일정 제목을 입력해주세요.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildMemoInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('메모 작성', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
        SizedBox(height: 8),
        TextField(
          controller: _memoController,
          maxLength: 100,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: '간단한 메모를 작성해주세요',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFFC8C8C8), width: 1), // 테두리 색 변경 (초록색)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFFC8C8C8), width: 2), // 활성화 시 테두리 색상
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _submitSchedule,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          child: Text('추가하기', style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF1BB874),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

void _submitSchedule() {
  setState(() {
    // 제목이 비어있으면 경고 처리
      if (_titleController.text.isEmpty) {
        _isTitleValid = false;
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        return;
      } else {
        _isTitleValid = true;
      }

      final DateTime selectedDateTime = DateTime(
        widget.selectedDate.year,
        widget.selectedDate.month,
        widget.selectedDate.day,
        _selectedHour,
        _selectedMinute,
      );

      widget.travelViewModel.addSchedule(
        travelId: widget.travelId,
        date: selectedDateTime,
        title: _titleController.text,
        startTime: "${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}",
        endTime: "23:59",
        memo: _memoController.text,
      );

      Navigator.pop(context, true);  // result로 true를 반환
    });
  }
}