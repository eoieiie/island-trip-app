import 'package:get/get.dart';
import '../model/island_model.dart';
import '../repository/island_repository.dart';

class IslandViewModel extends GetxController {
  var islands = <IslandModel>[].obs;
  var filteredIslands = <IslandModel>[].obs;
  var isLoading = true.obs;

  final IslandRepository repository = IslandRepository();

  @override
  void onInit() {
    super.onInit();
    loadIslands();
  }

  Future<void> loadIslands() async {
    isLoading(true);
    try {
      final loadedIslands = await repository.loadIslands();
      islands.assignAll(loadedIslands);
      filteredIslands.assignAll(loadedIslands);
    } finally {
      isLoading(false);
    }
  }

  void filterIslands(String tag) {
    if (tag.isEmpty) {
      filteredIslands.assignAll(islands);
    } else {
      filteredIslands.assignAll(islands.where((island) => island.tags.contains(tag)).toList());
    }
  }
}