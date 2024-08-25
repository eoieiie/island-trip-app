// schedule_add_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/my_travel_viewmodel.dart';

class ScheduleAddView extends StatefulWidget {
  final String travelId;
  final DateTime selectedDate;
  final MyTravelViewModel travelViewModel;

  ScheduleAddView({
    required this.travelId,
    required this.selectedDate,
    required this.travelViewModel,
  });

  @override
  _ScheduleAddViewState createState() => _ScheduleAddViewState();
}

class _ScheduleAddViewState extends State<ScheduleAddView> {
  FixedExtentScrollController _hoursController = FixedExtentScrollController();
  FixedExtentScrollController _minutesController = FixedExtentScrollController();
  int _selectedHour = 8;
  int _selectedMinute = 15;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _memoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _hoursController = FixedExtentScrollController(initialItem: _selectedHour);
    _minutesController = FixedExtentScrollController(initialItem: _selectedMinute);
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _titleController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('일정 추가'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationInput(),
              SizedBox(height: 20),
              _buildTimePicker(),
              SizedBox(height: 20),
              _buildPhotoSection(),
              SizedBox(height: 20),
              _buildTitleInput(),
              SizedBox(height: 20),
              _buildMemoInput(),
              SizedBox(height: 40),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('장소 입력', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '위치 검색',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              child: Text('+ 관심 리스트에서 불러오기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('시간 선택', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                style: TextStyle(fontSize: 24, color: Colors.black),
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
                style: TextStyle(fontSize: 24, color: Colors.black),
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
        Text('사진 등록 0/3', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: TextButton.icon(
              onPressed: () {
                // 사진 선택 기능 구현
              },
              icon: Icon(Icons.camera_alt, size: 24),
              label: Text('사진 선택'),
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
        Text('일정 제목', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: '간단한 제목을 작성해주세요',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemoInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('메모 작성', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        TextField(
          controller: _memoController,
          maxLength: 100,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: '간단한 메모를 작성해주세요',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
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
          child: Text('추가하기', style: TextStyle(fontSize: 16)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  void _submitSchedule() {
    final DateTime selectedDateTime = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
      _selectedHour,
      _selectedMinute,
    );

    // 스케줄 추가
    widget.travelViewModel.addSchedule(
      travelId: widget.travelId,
      date: selectedDateTime,
      title: _titleController.text,
      startTime: "${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}",
      endTime: "23:59", // 필요에 따라 종료 시간을 설정
      memo: _memoController.text,
    );

    Navigator.of(context).pop();
  }
}
