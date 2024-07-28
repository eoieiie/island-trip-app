import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/my_travel_viewmodel.dart';
import 'travel_schedule_view.dart';

class TravelDatePage extends StatefulWidget {
  final String selectedIsland;

  const TravelDatePage({required this.selectedIsland, Key? key}) : super(key: key);

  @override
  _TravelDatePageState createState() => _TravelDatePageState();
}

class _TravelDatePageState extends State<TravelDatePage> {
  DateTime _focusedDate = DateTime.now();
  DateTime? _startDate;
  DateTime? _endDate;

  List<String> _daysOfWeek = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = selectedDay;
        _endDate = null;
      } else if (_startDate != null && _endDate == null) {
        if (selectedDay.isBefore(_startDate!)) {
          _endDate = _startDate;
          _startDate = selectedDay;
        } else {
          _endDate = selectedDay;
        }
      }
    });
  }

  Widget _buildCalendar() {
    DateTime firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    int firstDayWeekday = firstDayOfMonth.weekday % 7;
    int daysInMonth = DateTime(_focusedDate.year, _focusedDate.month + 1, 0).day;
    DateTime today = DateTime.now();
    List<Widget> dayWidgets = [];

    for (int i = 0; i < firstDayWeekday; i++) {
      dayWidgets.add(Container()); // 첫 주의 공백을 채우기 위한 빈 컨테이너
    }

    for (int i = 1; i <= daysInMonth; i++) {
      DateTime day = DateTime(_focusedDate.year, _focusedDate.month, i);
      bool isStart = _startDate != null && _startDate!.isAtSameMomentAs(day);
      bool isEnd = _endDate != null && _endDate!.isAtSameMomentAs(day);
      bool isInRange = _startDate != null && _endDate != null && day.isAfter(_startDate!) && day.isBefore(_endDate!);
      bool isPast = day.isBefore(today);

      dayWidgets.add(
        GestureDetector(
          onTap: () => _onDaySelected(day),
          child: Container(
            margin: EdgeInsets.all(1),
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: isStart || isEnd
                  ? const Color(0xFF6699FF)
                  : isInRange
                  ? const Color(0xFFBBDDFF).withOpacity(0.3)
                  : Colors.transparent,
              shape: isStart || isEnd ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: isInRange ? BorderRadius.circular(10) : null,
            ),
            child: Center(
              child: Text(
                i.toString(),
                style: isStart || isEnd
                    ? const TextStyle(
                  color: Color(0xFFFAFAFA),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )
                    : isInRange
                    ? const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                )
                    : TextStyle(
                  color: isPast ? Colors.grey : Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1); // 이전 달로 이동
                });
              },
            ),
            Text(
              '${_focusedDate.year} ${_focusedDate.month}월',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                setState(() {
                  _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1); // 다음 달로 이동
                });
              },
            ),
          ],
        ),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 7,
          children: _daysOfWeek
              .map((day) => Center(child: Text(day, style: TextStyle(fontWeight: FontWeight.bold))))
              .toList(), // 요일 헤더를 그리드뷰로 생성
        ),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 7,
          children: dayWidgets, // 날짜를 그리드뷰로 생성
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '선택되지 않음'; // 날짜가 선택되지 않았을 때 표시할 텍스트
    return "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} (${_getDayOfWeek(date)})"; // 날짜를 형식에 맞춰 문자열로 변환
  }

  String _getDayOfWeek(DateTime date) {
    List<String> days = ['일', '월', '화', '수', '목', '금', '토']; // 요일 이름 리스트
    return days[date.weekday % 7]; // 날짜의 요일을 반환
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('여행 날짜'), // 앱바 제목 설정
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(), // 뒤로 가기 버튼
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // 전체 패딩 설정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '여행 일정을 입력하세요.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('내 섬 pick!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 15),
                  DropdownButton<String>(
                    value: widget.selectedIsland, // 선택된 섬
                    items: <String>['거제도', '우도', '외도', '홍도', '무의도', '진도']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {}, // 선택된 섬 변경 이벤트 핸들러
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('출발', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(_formatDate(_startDate), style: TextStyle(fontSize: 16, color: Colors.white)),
                        Text('AM 09:00', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: Colors.black, size: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('도착', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(_formatDate(_endDate), style: TextStyle(fontSize: 16, color: Colors.white)),
                        Text('AM 09:00', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildCalendar(), // 캘린더 위젯 생성
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_startDate != null && _endDate != null) {
                    // 여행 데이터를 추가하고 스케줄 뷰로 이동
                    final travelId = Get.find<MyTravelViewModel>().addTravel(
                      widget.selectedIsland,
                      _startDate!,
                      _endDate!,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TravelScheduleView(travelId: travelId),
                      ),
                    );
                  }
                },
                child: Text('다음', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48), // 버튼 크기 설정
                  backgroundColor: Colors.blueAccent, // 버튼 배경 색상 설정
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
