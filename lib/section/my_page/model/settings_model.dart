class Settings {
  bool serviceNotificationEnabled;
  bool oneWeekBeforeAlertEnabled;
  bool oneDayBeforeAlertEnabled;
  bool tenMinutesBeforeAlertEnabled;
  bool commentNotificationEnabled;
  bool likeNotificationEnabled;

  Settings({
    required this.serviceNotificationEnabled,
    required this.oneWeekBeforeAlertEnabled,
    required this.oneDayBeforeAlertEnabled,
    required this.tenMinutesBeforeAlertEnabled,
    required this.commentNotificationEnabled,
    required this.likeNotificationEnabled,
  });
}
