import 'package:ultimate_token/locator.dart';
import 'package:ultimate_token/services/token_service.dart';

class UserRepository {
  final TokenService _tokenService = locator<TokenService>();

  Future<Map<String, String>> getTokenInfo(String tokenAddress) async {
    Map<String, String> tokenInfo = {};
    String tokenName = await _tokenService.getTokenName(tokenAddress);
    String tokenSymbol = await _tokenService.getTokenSymbol(tokenAddress);
    String tokenTotalSupply =
        await _tokenService.getTokenTotalSupply(tokenAddress);

    tokenInfo["name"] = tokenName;
    tokenInfo["symbol"] = tokenSymbol;
    tokenInfo["totalSupply"] = tokenTotalSupply;

    return tokenInfo;
  }

  Future<String> getTokenBalance(
      String tokenAddress, String walletAddress) async {
    return await _tokenService.getTokenBalance(tokenAddress, walletAddress);
  }
}
