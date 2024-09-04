// my_travel_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/my_travel_model.dart';
import '../viewmodel/my_travel_viewmodel.dart';
import 'island_selection_view.dart';
import 'travel_schedule_view.dart';

class MyTravelView extends StatelessWidget {
  final MyTravelViewModel travelViewModel = Get.put(MyTravelViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
        //title: Text(
          //'내 일정',
          //style: TextStyle(
              //fontSize: 24, fontWeight: FontWeight.bold), // 제목 텍스트 크기 설정
        //),
        //centerTitle: true,
      //),
      backgroundColor: Colors.white,
      body: Obx(() {
        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0, top: 100.0, right: 50.0, bottom: 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '내가 작성한',
                        style: TextStyle(
                          fontSize: 24, // 큰 글씨 크기 설정
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '여행 일정을 확인하세요',
                        style: TextStyle(
                          fontSize: 24, // 큰 글씨 크기 설정
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '이전에 작성한 섬으로 떠나는 일정을 확인해 보세요.',
                        style: TextStyle(
                          fontSize: 13, // 설명 텍스트 크기 설정
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: travelViewModel.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : travelViewModel.travels.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '여행 리스트가 없습니다.',
                          style: TextStyle(fontSize: 16), // 텍스트 크기 설정
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      IslandSelectionView()),
                            );
                          },
                          child: Text(
                            '+ 일정 추가',
                            style: TextStyle(
                                fontSize: 14, // 버튼 텍스트 크기 설정
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(130, 38),
                            backgroundColor: Colors.black, // 검은색 버튼 유지
                          ),
                        ),
                      ],
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: travelViewModel.travels.length,
                      itemBuilder: (context, index) {
                        final travel = travelViewModel.travels[index];
                        return Dismissible(
                          key: Key(travel.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('삭제 확인'),
                                  content: Text(
                                      '정말로 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text('취소'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text('삭제'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) {
                            travelViewModel.deleteTravel(travel.id);
                          },
                          child: TravelCard(
                            travel: travel,
                            onSave: (updatedTravel) {
                              travelViewModel.updateTravel(
                                  index, updatedTravel);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (travelViewModel.travels.isNotEmpty)
              Positioned(
                bottom: 60,
                left: MediaQuery
                    .of(context)
                    .size
                    .width / 2 - 60, // 가운데 위치 조정
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IslandSelectionView()),
                    );
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('일정 추가',
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                  backgroundColor: Color(0XFF292929),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
          ],
        );
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

  String getFormattedDate(DateTime date) {
    final weekday = ['월', '화', '수', '목', '금', '토', '일'];
    return '${DateFormat('yy.MM.dd').format(date)} (${weekday[date.weekday -
        1]})';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140, // 컨테이너 높이 설정
      padding: EdgeInsets.symmetric(vertical: 8.0), // 카드 위아래 여백 추가
      child: Card(
        color: Color(0XFFf7f7f7),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: InkWell(  // InkWell을 사용하여 카드를 터치할 수 있게 함
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TravelScheduleView(
                  travelId: travel.id,
                  selectedIsland: travel.island,
                  startDate: travel.startDate,
                  endDate: travel.endDate,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 16.0), // Card 안쪽 여백 조절
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  backgroundImage: travel.imageUrl != null && travel.imageUrl!.isNotEmpty
                      ? NetworkImage(travel.imageUrl!)
                      : AssetImage('assets/default_image.png') as ImageProvider,
                  radius: 30,
                ),
                SizedBox(width: 16), // 이미지와 텍스트 사이의 여백 추가
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '️${travel.island}',
                        style: TextStyle(fontSize: 14, color: Colors.black54,fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        travel.title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8), // 제목과 날짜 사이의 여백 추가
                      Text(
                        '${getFormattedDate(travel.startDate)} ~ ${getFormattedDate(travel.endDate)}', // 날짜 형식에 한글 요일 추가
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8), // 텍스트와 트레일링 아이콘 사이의 여백 추가
                Column(
                  mainAxisAlignment: MainAxisAlignment.center, // 아이콘과 텍스트를 센터로 배치
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.grey[700]),
                      iconSize: 18, // 아이콘 크기 조정
                      padding: EdgeInsets.zero, // 패딩 없애기
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
                    SizedBox(height: 4), // 아이콘과 상태 텍스트 사이의 간격
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: travel.statusColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        travel.statusText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
              id: widget.travel.id,
              title: _titleController.text,
              island: widget.travel.island,
              startDate: _startDate,
              endDate: _endDate,
              imageUrl: widget.travel.imageUrl,  // 수정: 기존의 imageUrl 값을 유지합니다.
              updatedAt: DateTime.now(),
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
