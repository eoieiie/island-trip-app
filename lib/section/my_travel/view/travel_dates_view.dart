import 'package:flutter/material.dart';
import 'package:project_island/section/my_travel/view/travel_schedule_view.dart';

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
      dayWidgets.add(Container());
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
                  _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
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
                  _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
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
              .toList(),
        ),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 7,
          children: dayWidgets,
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '선택되지 않음';
    return "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} (${_getDayOfWeek(date)})";
  }

  String _getDayOfWeek(DateTime date) {
    List<String> days = ['일', '월', '화', '수', '목', '금', '토'];
    return days[date.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('여행 날짜'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                    value: widget.selectedIsland,
                    items: <String>['거제도', '우도', '외도', '홍도', '무의도', '진도']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {},
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
                        Text(_formatDate(_startDate), style: TextStyle(fontSize: 16)),
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
                        Text(_formatDate(_endDate), style: TextStyle(fontSize: 16)),
                        Text('AM 09:00', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildCalendar(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TravelScheduleView(
                        selectedIsland: widget.selectedIsland,
                        startDate: _startDate!,
                        endDate: _endDate!,
                      ),
                    ),
                  );
                },
                child: Text('다음', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
