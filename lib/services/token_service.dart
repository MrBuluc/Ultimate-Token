import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class TokenService {
  final String blockchainUrl = dotenv.env["blockchainUrl"]!;

  late Client httpClient;

  late Web3Client ethClient;

  TokenService() {
    httpClient = Client();
    ethClient = Web3Client(blockchainUrl, httpClient);
  }

  Future<List> callGetFunc(
      String tokenAddress, String funcName, List params) async {
    DeployedContract contract = await getContract(tokenAddress);
    ContractFunction function = contract.function(funcName);
    return await ethClient.call(
        contract: contract, function: function, params: params);
  }

  Future<DeployedContract> getContract(String tokenAddress) async {
    String abiFile =
        await rootBundle.loadString("assets/ultimate_token_abi.json");
    return DeployedContract(ContractAbi.fromJson(abiFile, "UltimateToken"),
        EthereumAddress.fromHex(tokenAddress));
  }

  Future<String> getTokenName(String tokenAddress) async {
    return ((await callGetFunc(tokenAddress, "name", []))[0]).toString();
  }

  Future<String> getTokenSymbol(String tokenAddress) async {
    return ((await callGetFunc(tokenAddress, "symbol", []))[0]).toString();
  }

  Future<String> getTokenTotalSupply(String tokenAddress) async {
    return ((await callGetFunc(tokenAddress, "totalSupply", []))[0]).toString();
  }

  Future<String> getTokenBalance(
      String tokenAddress, String walletAddress) async {
    return ((await callGetFunc(tokenAddress, "balanceOf",
            [EthereumAddress.fromHex(walletAddress)]))[0])
        .toString();
  }

  Future<String> callSetFunc(
      String tokenAddress, String funcName, List params) async {
    DeployedContract contract = await getContract(tokenAddress);
    return await ethClient.sendTransaction(
        EthPrivateKey.fromHex(dotenv.env["privateAddress"]!),
        Transaction.callContract(
            contract: contract,
            function: contract.function(funcName),
            parameters: params,
            maxGas: 100000),
        chainId: 5);
  }

  Future<String> sendToken(
      String tokenAddress, String recipientAddress, BigInt amount) async {
    return await callSetFunc(tokenAddress, "transfer",
        [EthereumAddress.fromHex(recipientAddress), amount]);
  }
}
