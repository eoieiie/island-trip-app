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
  late String _selectedIsland;

  List<String> _daysOfWeek = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

  @override
  void initState() {
    super.initState();
    _selectedIsland = widget.selectedIsland;
  }

  void _onDaySelected(DateTime selectedDay) {
    if (selectedDay.isBefore(DateTime.now())) return;
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
          children: _daysOfWeek.map((day) => Center(child: Text(day, style: TextStyle(fontWeight: FontWeight.bold)))).toList(),
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
        backgroundColor: Colors.white,
        title: Text(''),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('내 섬 pick!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(width: 15),
                            DropdownButton<String>(
                              value: _selectedIsland,
                              items: <String>['거제도', '우도', '외도', '홍도', '무의도', '진도'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  if (newValue != null) {
                                    _selectedIsland = newValue;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        _buildCalendar(),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.only(left: 30.0, top: 0.0, right: 16.0, bottom: 10.0),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '여행을',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '언제 떠나시나요?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '기간을 선택해 주세요.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: ElevatedButton(
              onPressed: _startDate != null && _endDate != null
                  ? () {
                if (_startDate != null && _endDate != null) {
                  final travelId = Get.find<MyTravelViewModel>().addTravel(
                    _selectedIsland,
                    _startDate!,
                    _endDate!,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TravelScheduleView(
                        travelId: travelId,
                        selectedIsland: _selectedIsland,
                        startDate: _startDate!,
                        endDate: _endDate!,
                      ),
                    ),
                  );
                }
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _startDate != null && _endDate != null ? Color(0XFF1BB874) : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Center(
                child: Text(
                  '다음',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
