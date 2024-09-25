/*
import 'package:get/get.dart';
import 'package:project_island/section/my_page/repository/settings_repository.dart';
import 'package:project_island/section/my_page/model/settings_model.dart';

class SettingsController extends GetxController {
  var isServiceNotificationEnabled = false.obs;
  var isOneWeekBeforeAlertEnabled = false.obs;
  var isOneDayBeforeAlertEnabled = false.obs;
  var isTenMinutesBeforeAlertEnabled = false.obs;
  var isCommentNotificationEnabled = false.obs;
  var isLikeNotificationEnabled = false.obs;
  var isChanged = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings(); // 설정 로드
  }

  void loadSettings() {
    // 기존 설정 로드 로직
    var settings = SettingsRepository.getSettings();
    isServiceNotificationEnabled.value = settings.serviceNotificationEnabled;
    isOneWeekBeforeAlertEnabled.value = settings.oneWeekBeforeAlertEnabled;
    isOneDayBeforeAlertEnabled.value = settings.oneDayBeforeAlertEnabled;
    isTenMinutesBeforeAlertEnabled.value = settings.tenMinutesBeforeAlertEnabled;
    isCommentNotificationEnabled.value = settings.commentNotificationEnabled;
    isLikeNotificationEnabled.value = settings.likeNotificationEnabled;
  }

  void toggleServiceNotification(bool value) {
    isServiceNotificationEnabled.value = value;
    checkChanges();
  }

  void toggleOneWeekBeforeAlert(bool value) {
    isOneWeekBeforeAlertEnabled.value = value;
    checkChanges();
  }

  void toggleOneDayBeforeAlert(bool value) {
    isOneDayBeforeAlertEnabled.value = value;
    checkChanges();
  }

  void toggleTenMinutesBeforeAlert(bool value) {
    isTenMinutesBeforeAlertEnabled.value = value;
    checkChanges();
  }

  void toggleCommentNotification(bool value) {
    isCommentNotificationEnabled.value = value;
    checkChanges();
  }

  void toggleLikeNotification(bool value) {
    isLikeNotificationEnabled.value = value;
    checkChanges();
  }

  void checkChanges() {
    // 변경사항 체크 로직
    isChanged.value = true;
  }

  void saveSettings() {
    // 설정 저장 로직
    var settings = Settings(
      serviceNotificationEnabled: isServiceNotificationEnabled.value,
      oneWeekBeforeAlertEnabled: isOneWeekBeforeAlertEnabled.value,
      oneDayBeforeAlertEnabled: isOneDayBeforeAlertEnabled.value,
      tenMinutesBeforeAlertEnabled: isTenMinutesBeforeAlertEnabled.value,
      commentNotificationEnabled: isCommentNotificationEnabled.value,
      likeNotificationEnabled: isLikeNotificationEnabled.value,
    );
    SettingsRepository.saveSettings(settings);
    Get.back(); // 저장 후 화면 닫기
  }
}

 */
