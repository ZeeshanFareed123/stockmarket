import 'package:stockubl/app/config/app_config.dart';
import 'package:stockubl/app/config/environment.dart';
import 'package:stockubl/bootstrap.dart';

Future<void> main() async {
  final environment = AppEnvironment.fromEnvironment();
  await bootstrap(AppConfig.forEnvironment(environment));
}
