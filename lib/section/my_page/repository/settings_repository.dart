import 'package:project_island/section/my_page/model/settings_model.dart';

class SettingsRepository {
  static Settings getSettings() {
    // 기존 설정을 로드하는 로직
    // 예: Firebase 또는 로컬 저장소에서 불러오기
    return Settings(
      serviceNotificationEnabled: true,
      oneWeekBeforeAlertEnabled: true,
      oneDayBeforeAlertEnabled: true,
      tenMinutesBeforeAlertEnabled: false,
      commentNotificationEnabled: true,
      likeNotificationEnabled: true,
    );
  }

  static void saveSettings(Settings settings) {
    // 설정을 저장하는 로직
    // 예: Firebase 또는 로컬 저장소에 저장하기
  }
}
