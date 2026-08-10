import 'package:medicompare/features/notification/data/datasources/notification_local_data_source.dart';
import 'package:medicompare/features/notification/data/repositories/notification_repository.dart';
import 'package:medicompare/features/notification/domain/services/notification_service.dart';

class FirebaseTokenService {
  static Future<void> init() async {
    final localDataSource = NotificationLocalDataSourceImpl();
    final repository = NotificationRepositoryImpl(localDataSource: localDataSource);
    final notificationService = NotificationService(repository: repository);
    await notificationService.init();
  }
}
