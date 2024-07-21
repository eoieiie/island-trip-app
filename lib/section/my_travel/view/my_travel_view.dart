// lib/section/my_travel/view/my_travel_view.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'island_selection_view.dart';


class MyTravelView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 일정', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // 첫 번째 여행 카드
                TravelCard(
                  title: '거제도',
                  subtitle: '여행 가기 5일 전!',
                  dateRange: '2024-07-07 ~ 2024-07-14',
                  island: '거제도',
                ),
                // 두 번째 여행 카드
                TravelCard(
                  title: '여행 2',
                  subtitle: '여행 가기 31일 전!',
                  dateRange: '2024-07-07 ~ 2024-07-14',
                  island: '우도',
                ),
                // 세 번째 여행 카드
                TravelCard(
                  title: '여행 3',
                  subtitle: '여행 가기 240일 전!',
                  dateRange: '2024-07-07 ~ 2024-07-14',
                  island: '외도',
                ),
              ],
            ),
          ),
          // 새로운 섬강스 떠나기 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IslandSelectionView()),
                 );
              },
              child: Text('새로운 섬캉스 떠나기!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TravelCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String dateRange;
  final String island;

  TravelCard({
    required this.title,
    required this.subtitle,
    required this.dateRange,
    required this.island,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtitle, style: TextStyle(color: Colors.grey)),
              SizedBox(height: 8.0),
              Text(island, style: TextStyle(fontSize: 16)),
              Text(dateRange, style: TextStyle(color: Colors.grey)),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return EditTravelDialog(
                    title: title,
                    startDate: DateTime.parse(dateRange.split(' ~ ')[0]),
                    endDate: DateTime.parse(dateRange.split(' ~ ')[1]),
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
  final String title;
  final DateTime startDate;
  final DateTime endDate;

  EditTravelDialog({required this.title, required this.startDate, required this.endDate});

  @override
  _EditTravelDialogState createState() => _EditTravelDialogState();
}

class _EditTravelDialogState extends State<EditTravelDialog> {
  late TextEditingController _titleController;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != DateTimeRange(start: _startDate, end: _endDate)) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('여행 정보 수정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: '여행 이름'),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              _selectDateRange(context);
            },
            child: AbsorbPointer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('출발', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(DateFormat('yyyy-MM-dd').format(_startDate)),
                  Text('도착', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(DateFormat('yyyy-MM-dd').format(_endDate)),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            // 저장 로직
            Navigator.of(context).pop();
          },
          child: Text('저장'),
        ),
      ],
    );
  }
}
