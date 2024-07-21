// lib/section/my_travel/view/my_travel_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/my_travel_model.dart';
import '../viewmodel/my_travel_viewmodel.dart';
import 'island_selection_view.dart';

class MyTravelView extends StatelessWidget {
  final MyTravelViewModel travelViewModel = Get.put(MyTravelViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 일정', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (travelViewModel.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: travelViewModel.travels.length,
                  itemBuilder: (context, index) {
                    final travel = travelViewModel.travels[index];
                    return TravelCard(
                      travel: travel,
                      onSave: (updatedTravel) {
                        travelViewModel.updateTravel(index, updatedTravel);
                      },
                    );
                  },
                ),
              ),
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
          );
        }
      }),
    );
  }
}

class TravelCard extends StatelessWidget {
  final TravelModel travel;
  final Function(TravelModel) onSave;

  TravelCard({
    required this.travel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title: Text(
            travel.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('여행 가기 ${travel.daysUntilTravel}일 전!', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 8.0),
              Text(travel.island, style: TextStyle(fontSize: 16)),
              Text('${travel.startDate} ~ ${travel.endDate}', style: TextStyle(color: Colors.grey)),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return EditTravelDialog(
                    travel: travel,
                    onSave: onSave,
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
  final TravelModel travel;
  final Function(TravelModel) onSave;

  EditTravelDialog({
    required this.travel,
    required this.onSave,
  });

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
    _titleController = TextEditingController(text: widget.travel.title);
    _startDate = widget.travel.startDate;
    _endDate = widget.travel.endDate;
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
            final updatedTravel = TravelModel(
              title: _titleController.text,
              island: widget.travel.island,
              startDate: _startDate,
              endDate: _endDate,
            );
            widget.onSave(updatedTravel);
            Navigator.of(context).pop();
          },
          child: Text('저장'),
        ),
      ],
    );
  }
}
