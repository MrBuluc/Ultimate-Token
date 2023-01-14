import 'package:get_it/get_it.dart';
import 'package:ultimate_token/repository/user_repository.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(() => UserRepository());
}
