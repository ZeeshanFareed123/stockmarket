abstract interface class PushNotificationService {
  Future<void> initialize();

  Stream<String> get openedNotificationRoutes;
}
