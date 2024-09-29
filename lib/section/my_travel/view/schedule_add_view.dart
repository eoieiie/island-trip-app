import 'package:flutter/material.dart';
import '../viewmodel/my_travel_viewmodel.dart';
import 'new_google_search_page.dart';

class ScheduleAddView extends StatefulWidget {
  final String selectedIsland; // 새로 추가된 selectedIsland 속성
  final String travelId;
  final DateTime selectedDate;
  final MyTravelViewModel travelViewModel;
  final String? title;
  final String? startTime;
  final String? endTime;
  final String? memo;

  const ScheduleAddView({
    Key? key,
    required this.travelId,
    required this.selectedDate,
    required this.travelViewModel,
    required this.selectedIsland, // 여기에 selectedIsland 추가
    this.title, // 기존 일정 제목
    this.startTime, // 기존 일정 시작 시간
    this.endTime, // 기존 일정 종료 시간
    this.memo, // 기존 메모
  }) : super(key: key);

  @override
  _ScheduleAddViewState createState() => _ScheduleAddViewState();
}

class _ScheduleAddViewState extends State<ScheduleAddView> {
  FixedExtentScrollController _hoursController = FixedExtentScrollController();
  FixedExtentScrollController _minutesController = FixedExtentScrollController();
  String? _selectedPlace;
  double? _selectedLatitude;
  double? _selectedLongitude;
  int _selectedHour = 12;
  int _selectedMinute = 0;

  late TextEditingController _titleController;
  late TextEditingController _memoController;

  bool _isTitleValid = true; // 제목 유효성 확인 변수
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 키보드에 의해 화면이 밀려올라가도록 설정
      resizeToAvoidBottomInset: true,
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
      body: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.black, // 커서 색상 검은색으로 설정
            selectionHandleColor: Color(0xFF1BB874), // 선택 핸들 색상 초록색으로 설정
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: SingleChildScrollView(
            controller: _scrollController,
            // 키보드가 올라올 때 하단에 충분한 공간을 주기 위해 추가
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
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
                _buildMemoInput(),
                SizedBox(height: 20),
                _buildSubmitButton(),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _makeline() {
    return Container(
      width: double.infinity,
      height: 1,
      color: Color(0xFFF7F7F7),
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
          onTap: () async {
            // NewGoogleSearchPage에서 장소와 좌표를 받아옵니다
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                // 섬 이름을 별도 매개변수로 전달
                builder: (context) => NewGoogleSearchPage(selectedIsland: widget.selectedIsland),
              ),
            );

            // 결과로 받은 장소와 좌표를 저장
            if (result != null && result is Map<String, dynamic>) {
              setState(() {
                _selectedPlace = result['place'];
                _selectedLatitude = result['latitude'];
                _selectedLongitude = result['longitude'];

                print('선택된 장소: $_selectedPlace');
                print('위도: $_selectedLatitude, 경도: $_selectedLongitude');

                // 제목이 비어있다면 장소 이름으로 설정
                if (_titleController.text.isEmpty) {
                  _titleController.text = _selectedPlace!;
                }
              });
            }
          },
          child: AbsorbPointer(
            child: TextField(
              decoration: InputDecoration(
                hintText: _selectedPlace ?? '위치 검색',
                hintStyle: TextStyle(
                  color: _selectedPlace != null ? Colors.black : Colors.grey,
                ),
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
              borderSide: BorderSide(color: Color(0xFFC8C8C8), width: 1), // 테두리 색 변경
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
        Text(
          '메모 작성',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _memoController,
          maxLength: 100,
          maxLines: null, // 입력 내용에 따라 자동으로 높이 조절
          decoration: InputDecoration(
            hintText: '간단한 메모를 작성해주세요',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFFC8C8C8), width: 1), // 테두리 색 변경
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
      // 제목이 비어있거나 장소가 선택되지 않으면 경고 처리
      if (_titleController.text.isEmpty || _selectedPlace == null) {
        _isTitleValid = _titleController.text.isNotEmpty;
        String missingField = '';

        if (_titleController.text.isEmpty && _selectedPlace == null) {
          missingField = '일정 제목과 장소를';
        } else if (_titleController.text.isEmpty) {
          missingField = '일정 제목을';
        } else if (_selectedPlace == null) {
          missingField = '장소를';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$missingField 입력해주세요.'),
            backgroundColor: Colors.red,
          ),
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
        endTime: "23:59", // 예시: 종료 시간을 고정하거나, 사용자 입력으로 변경 가능
        memo: _memoController.text,
        latitude: _selectedLatitude,
        longitude: _selectedLongitude,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('일정이 저장되었습니다.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true); // result로 true를 반환
    });
  }
}
