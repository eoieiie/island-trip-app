// my_travel_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/my_travel_model.dart';
import '../viewmodel/my_travel_viewmodel.dart';
import 'island_selection_view.dart';
import 'travel_schedule_view.dart';
import 'package:project_island/section/map/model/island_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert'; // for jsonDecode

class MyTravelView extends StatefulWidget {
  @override
  _MyTravelViewState createState() => _MyTravelViewState();
}

class _MyTravelViewState extends State<MyTravelView> {
  final MyTravelViewModel travelViewModel = Get.put(MyTravelViewModel());
  List<IslandModel> islands = []; // islands 데이터를 정의합니다.

  // JSON 데이터 로드 메서드
  Future<void> _loadIslandData() async {
    print("json load");
    final String response = await rootBundle.loadString('assets/data/island_data.json');
    print("JSON File Content: $response"); // 로드된 JSON 데이터 출력
    final List<dynamic> data = jsonDecode(response);
    islands = data.map((island) => IslandModel.fromJson(island)).toList();
    print("Parsed Islands: $islands"); // 파싱된 섬 리스트 출력
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        // 여행 상태 및 출발일에 따른 정렬
        travelViewModel.travels.sort((a, b) {
          // 여행 중 상태 비교
          if (a.travelStatus == '여행 중' && b.travelStatus != '여행 중') {
            return -1;
          } else if (a.travelStatus != '여행 중' && b.travelStatus == '여행 중') {
            return 1;
          }

          // 출발 n일 전 상태 비교
          if (a.travelStatus.contains('출발') && b.travelStatus.contains('출발')) {
            return a.startDate.compareTo(b.startDate); // 출발일이 빠른 순으로 정렬
          } else if (a.travelStatus.contains('출발')) {
            return -1;
          } else if (b.travelStatus.contains('출발')) {
            return 1;
          }

          // 다녀온 지 n일 상태 비교
          if (a.travelStatus.contains('다녀온') && b.travelStatus.contains('다녀온')) {
            return a.endDate.compareTo(b.endDate); // 종료일이 오래된 순으로 정렬
          }

          return 0;
        });

        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0, top: 50.0, right: 50.0, bottom: 0.0),
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
                              MaterialPageRoute(builder: (context) => IslandSelectionView()),
                            );
                          },
                          child: Text(
                            '+ 일정 추가',
                            style: TextStyle(
                              fontSize: 14, // 버튼 텍스트 크기 설정
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
                    padding: const EdgeInsets.only(top: 25.0, left: 16.0, right: 16.0),
                    child: ListView.builder(
                      itemCount: travelViewModel.travels.length + 1,
                      itemBuilder: (context, index) {
                        if (index == travelViewModel.travels.length) {
                          // 마지막에 빈 공간을 추가
                          return SizedBox(
                            height: 110, // 카드 한 개 크기만큼의 빈 공간 추가
                          );
                        }

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
                                  content: Text('정말로 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: Text('취소'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
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
                              travelViewModel.updateTravel(index, updatedTravel);
                            },
                            islands: islands,
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
                bottom: 40,
                left: MediaQuery.of(context).size.width / 2 - 60, // 가운데 위치 조정
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IslandSelectionView()),
                    );
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('일정 추가', style: TextStyle(color: Colors.white, fontSize: 15)),
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
  final List<IslandModel> islands;

  TravelCard({
    required this.travel,
    required this.onSave,
    required this.islands,
  });

  // 섬 이름에 따른 이미지 경로를 반환하는 함수
  String getIslandImage(String islandName) {
    switch (islandName) {
      case '덕적도':
        return 'assets/icons/3dcamping.png'; // 덕적도: 캠핑 이미지
      case '거제도':
        return 'assets/icons/3dsurf.png'; // 거제도: 서핑 이미지
      case '울릉도':
        return 'assets/icons/3ddiving.png'; // 울릉도: 다이빙 이미지
      case '안면도':
        return 'assets/icons/3dflower.png'; // 안면도: 꽃 관련 이미지
      case '진도':
        return 'assets/icons/3dbluefish.png'; // 진도: 파란 물고기 이미지
      default:
        return 'assets/icons/3disland.png'; // 기본 이미지 설정
    }
  }


  String getFormattedDate(DateTime date) {
    final weekday = ['월', '화', '수', '목', '금', '토', '일'];
    return '${DateFormat('yy.MM.dd').format(date)} (${weekday[date.weekday - 1]})';
  }

  @override
  Widget build(BuildContext context) {
    // 해당 섬 이름에 맞는 이미지 경로 설정
    final String islandImage = getIslandImage(travel.island);

    return Container(
      height: 140, // 컨테이너 높이 설정
      padding: EdgeInsets.symmetric(vertical: 8.0), // 카드 위아래 여백 추가
      child: Card(
        color: Color(0XFFf9f9f9),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 3),
        child: InkWell(
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
            padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Color(0XFFf7f7f7),
                  backgroundImage: AssetImage(islandImage), // 섬 이름에 맞는 이미지 경로 사용
                  radius: 36,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6),
                      Text(
                        '️${travel.island}',
                        style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1),
                      Text(
                        travel.title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 7),
                      Text(
                        '${getFormattedDate(travel.startDate)} ~ ${getFormattedDate(travel.endDate)}', // 날짜 형식에 한글 요일 추가
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.grey[700]),
                      iconSize: 18,
                      padding: EdgeInsets.zero,
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
                    SizedBox(height: 4),
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
  List<IslandModel> islands = []; // islands 리스트 추가
  final MyTravelViewModel travelViewModel = Get.put(MyTravelViewModel());

  @override
  void initState() {
    print('json');
    super.initState();
    _loadIslandData();
    _titleController = TextEditingController(text: widget.travel.title);
    _startDate = widget.travel.startDate;
    _endDate = widget.travel.endDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _loadIslandData() async {
    final String response = await rootBundle.loadString('assets/data/island_data.json');
    print("JSON File Content: $response"); // JSON 파일 내용 출력
    final List<dynamic> data = jsonDecode(response);
    islands = data.map((island) => IslandModel.fromJson(island)).toList();
    print("Parsed Islands: $islands"); // 파싱된 데이터 출력
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
      title: Text(
        '여행 정보 수정',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,  // 제목 폰트 크기 크게
          fontWeight: FontWeight.w500, // 제목 폰트 굵게
          color: Colors.black87, // 제목 색상 변경
        ),
      ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 80),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('     출발', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          Text(DateFormat('yyyy-MM-dd').format(_startDate)),
                        ],
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('     도착', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          Text(DateFormat('yyyy-MM-dd').format(_endDate)),
                        ],
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          _selectDateRange(context);
                        },
                        icon: Icon(Icons.edit, color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    ],
                  ),
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
          child: Text(
            '취소',
            style: TextStyle(
              color: Colors.grey[800], // 색상 변경
              fontWeight: FontWeight.w200, // 글씨체 변경
              fontSize: 16, // 글씨 크기 조정
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedTravel = TravelModel(
              id: widget.travel.id,
              title: _titleController.text,
              island: widget.travel.island,
              startDate: _startDate,
              endDate: _endDate,
              imageUrl: widget.travel.imageUrl, // 수정: 기존의 imageUrl 값을 유지합니다.
              updatedAt: DateTime.now(),
            );
            widget.onSave(updatedTravel);
            Navigator.of(context).pop();
          },
          child: Text(
            '저장',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16, // 글씨 크기 조정
              fontWeight: FontWeight.w200, // 글씨체 변경
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // 버튼 배경 색상 변경
          ),
        ),
      ],
    );
  }
}
