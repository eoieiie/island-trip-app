// viewmodel/magazine_viewmodel.dart
/*
import 'package:get/get.dart';
import '../model/home_model.dart';
import '../repository/home_repository.dart';

// 매거진 뷰모델 클래스
class MagazineViewModel extends GetxController {
  // 리포지토리 인스턴스를 저장할 변수
  final Repository repository;

  // 매거진과 가게 리스트를 관리하기 위한 Observable 리스트
  var magazines = <Magazine>[].obs;
  var stores = <Store>[].obs;

  // 생성자에서 리포지토리를 받아옴
  MagazineViewModel({required this.repository});

  // 컨트롤러가 초기화될 때 호출되는 메서드
  @override
  void onInit() {
    super.onInit();
    fetchMagazines();  // 컨트롤러가 초기화될 때 매거진을 가져옴
    fetchStores();    // 컨트롤러가 초기화될 때 가게를 가져옴
  }

  // 매거진을 가져와서 Observable 리스트를 업데이트하는 메서드
  void fetchMagazines() async {
    try {
      // 리포지토리에서 매거진을 가져와서 리스트에 할당
      var fetchedMagazines = await repository.fetchMagazines();
      magazines.assignAll(fetchedMagazines);
    } catch (e) {
      // 에러 발생 시 콘솔에 출력
      print('Error fetching magazines: $e');
    }
  }

  // 가게를 가져와서 Observable 리스트를 업데이트하는 메서드
  void fetchStores() async {
    try {
      // 리포지토리에서 울릉도 상세 정보를 가져와서 가게 리스트에 할당
      var fetchedStores = await repository.fetchIslandDetails('울릉도').stores;
      stores.assignAll(fetchedStores);
    } catch (e) {
      // 에러 발생 시 콘솔에 출력
      print('Error fetching stores: $e');
    }
  }
} */
