import 'package:flutter/cupertino.dart';
import 'package:ultimate_token/locator.dart';
import 'package:ultimate_token/repository/user_repository.dart';

class UserModel with ChangeNotifier {
  final UserRepository userRepository = locator<UserRepository>();

  Future<Map<String, String>> getTokenInfo(String tokenAddress) async {
    try {
      return await userRepository.getTokenInfo(tokenAddress);
    } catch (e) {
      printError("getTokenInfo", e);
      rethrow;
    }
  }

  Future<String> getTokenBalance(
      String tokenAddress, String walletAddress) async {
    try {
      return await userRepository.getTokenBalance(tokenAddress, walletAddress);
    } catch (e) {
      printError("getTokenBalance", e);
      rethrow;
    }
  }

  Future<String> sendToken(
      String tokenAddress, String recipientAddress, int amount) async {
    try {
      return await userRepository.sendToken(
          tokenAddress, recipientAddress, amount);
    } catch (e) {
      printError("sendToken", e);
      rethrow;
    }
  }

  Future<List> listenEvent(String tokenAddress, String eventName) async {
    try {
      return await userRepository.listenEvent(tokenAddress, eventName);
    } catch (e) {
      printError("listenEvent", e);
      rethrow;
    }
  }

  printError(String methodName, Object e) {
    print("Usermodel $methodName hata: " + e.toString());
  }
}
