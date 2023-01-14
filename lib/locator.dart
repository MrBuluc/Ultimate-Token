import 'package:get_it/get_it.dart';
import 'package:ultimate_token/repository/user_repository.dart';
import 'package:ultimate_token/services/token_service.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => TokenService());
}
