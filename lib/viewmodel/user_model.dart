import 'package:flutter/cupertino.dart';
import 'package:ultimate_token/locator.dart';
import 'package:ultimate_token/repository/user_repository.dart';

class UserModel with ChangeNotifier {
  final UserRepository userRepository = locator<UserRepository>();
}
