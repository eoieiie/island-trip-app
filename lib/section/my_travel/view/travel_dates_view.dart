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
    if (selectedDay.isBefore(DateTime.now())) return; // 과거 날짜는 선택 불가
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
        backgroundColor: Colors.white,
        title: Text(''),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0), // 전체 패딩 설정
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100), // 상단의 글자 상자 높이만큼 추가
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
                  _buildCalendar(), // 캘린더 위젯 생성
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0, // 상단에 붙이기 위해 top을 0으로 설정
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 30.0, top: 0.0, right: 16.0, bottom: 10.0),
              color: Colors.white, // 배경을 하얀색으로 설정
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '여행을',
                    style: TextStyle(
                      fontSize: 24, // 큰 글씨 크기 설정
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '언제 떠나시나요?',
                    style: TextStyle(
                      fontSize: 24, // 큰 글씨 크기 설정
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '기간을 선택해 주세요..',
                    style: TextStyle(
                      fontSize: 13, // 설명 텍스트 크기 설정
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startDate != null && _endDate != null
            ? () {
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
                builder: (context) => TravelScheduleView(
                  travelId: travelId,
                  selectedIsland: widget.selectedIsland,
                  startDate: _startDate!,
                  endDate: _endDate!,
                ),
              ),
            );
          }
        }
            : null, // 비활성화 상태일 때는 onPressed가 null로 설정됨
        label: Text(
            '                                다음                               ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: _startDate != null && _endDate != null
            ? Color(0XFF1BB874) // 활성화된 버튼 색상
            : Colors.grey, // 비활성화된 버튼 색상
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
