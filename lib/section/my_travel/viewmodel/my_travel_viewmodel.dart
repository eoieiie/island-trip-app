// my_travel_viewmodel.dart

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../model/my_travel_model.dart';
import '../model/schedule_model.dart';
import '../repository/my_travel_repository.dart';

class MyTravelViewModel extends GetxController {
  var travels = <TravelModel>[].obs;
  var isLoading = true.obs;
  final uuid = Uuid();

  @override
  void onInit() {
    super.onInit();
    loadTravels();
  }

  Future<void> loadTravels() async {
    try {
      isLoading(true);
      var loadedTravels = await MyTravelRepository.loadTravelData();
      travels.assignAll(loadedTravels);
      // 각 여행의 스케줄도 함께 불러오기
      for (var travel in travels) {
        travel.schedules = await MyTravelRepository.loadSchedulesForTravel(travel.id);
      }
    } finally {
      isLoading(false);
    }
  }

  String addTravel(String island, DateTime startDate, DateTime endDate) {
    final String imageUrl = _getImageUrlForIsland(island); // 섬 ID에 연결된 이미지 URL 가져오기

    final newTravel = TravelModel(
      id: uuid.v4(),
      title: '$island 여행',
      startDate: startDate,
      endDate: endDate,
      island: island,
      imageUrl: imageUrl, // 이미지 URL 추가
    );
    travels.add(newTravel);
    saveTravels(); // 여행 데이터 저장
    return newTravel.id;
  }

  // 새로운 일정 추가 메서드
  void addSchedule({
    required String travelId,
    required DateTime date,
    required String title,
    required String startTime,
    required String endTime,
    String? memo,
  }) async {
    final travel = travels.firstWhere((t) => t.id == travelId);
    final DateTime startDateTime = DateTime.parse("${date.toString().split(' ')[0]} $startTime");
    final DateTime endDateTime = DateTime.parse("${date.toString().split(' ')[0]} $endTime");

    final newSchedule = ScheduleModel(
      id: uuid.v4(),
      title: title,
      date: date,
      startTime: startDateTime,
      endTime: endDateTime,
      memo: memo,
    );
    travel.schedules.add(newSchedule);
    saveSchedules(travelId); // 스케줄 데이터 저장
    saveTravels(); // 여행 데이터 저장
    update(); // 상태 업데이트
  }

  // 섬 ID에 연결된 이미지 URL을 가져오는 메서드 (예시)
  String _getImageUrlForIsland(String island) {
    // 실제 URL 로직에 따라 수정 필요
    switch (island) {
      case '우도':
        return 'https://example.com/images/u-do.jpg';
      case '거제도':
        return 'https://example.com/images/geoje-do.jpg';
      case '외도':
        return 'https://example.com/images/oedo.jpg';
      default:
        return ''; // 이미지가 없는 경우 빈 문자열 반환
    }
  }

  Future<void> updateTravel(int index, TravelModel updatedTravel) async {
    updatedTravel.updatedAt = DateTime.now(); // 수정된 날짜를 현재 시간으로 업데이트
    travels[index] = updatedTravel;
    await saveTravels();
  }

  Future<void> deleteTravel(String id) async {
    travels.removeWhere((travel) => travel.id == id);
    await saveTravels();
  }

  Future<void> saveTravels() async {
    await MyTravelRepository.saveTravelData(travels); // 여행 데이터를 저장합니다.
  }

  Future<void> saveSchedules(String travelId) async {
    final travel = travels.firstWhere((t) => t.id == travelId);
    await MyTravelRepository.saveSchedulesForTravel(travelId, travel.schedules); // 스케줄 데이터를 저장합니다.
  }

  // 일정 데이터를 불러오는 메서드
  Future<void> loadSchedules(String travelId) async {
    final travel = travels.firstWhere((t) => t.id == travelId);
    travel.schedules = await MyTravelRepository.loadSchedulesForTravel(travelId);
    update(); // 상태 업데이트
  }

  // 여행 ID와 날짜 인덱스를 기반으로 해당 날짜의 일정을 반환하는 메서드
  List<ScheduleModel> getSchedulesByDay(String travelId, int dayIndex) {
    // 여행을 찾습니다.
    final travel = travels.firstWhere((t) => t.id == travelId);

    // 시작 날짜를 기준으로 dayIndex만큼 더한 날짜를 계산합니다.
    final selectedDate = travel.startDate.add(Duration(days: dayIndex));

    // 해당 날짜에 맞는 일정들만 필터링하여 반환합니다.
    return travel.schedules.where((schedule) {
      return schedule.date.isSameDate(selectedDate);
    }).toList();
  }
}

// 날짜 비교를 위한 확장 메서드
extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }
}
