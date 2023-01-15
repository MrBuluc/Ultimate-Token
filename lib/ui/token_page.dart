import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_token/model/transfer.dart';
import 'package:ultimate_token/viewmodel/user_model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/web3dart.dart';

class TokenPage extends StatefulWidget {
  const TokenPage({Key? key}) : super(key: key);

  @override
  State<TokenPage> createState() => _TokenPageState();
}

class _TokenPageState extends State<TokenPage> {
  GlobalKey<FormState> tokenAddressFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> walletAddressFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> transferFormKey = GlobalKey<FormState>();

  TextEditingController tokenAddressCnt = TextEditingController();
  TextEditingController walletAddressCnt = TextEditingController();
  TextEditingController recipientAddressCnt = TextEditingController();
  TextEditingController amountCnt = TextEditingController();

  String name = "", symbol = "", totalSupply = "", balance = "";

  List<Transfer> transfers = [];

  Decoration boxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3))
      ]);

  late Size size;

  bool isProgress = false;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  const Text(
                    "Read from Token",
                    style: TextStyle(fontSize: 20),
                  ),
                  buildContainer(tokenAddressFormKey, [
                    buildTextFormField(
                        tokenAddressCnt, "Token Address", checkAddress),
                    buildButton("Get Token Info", getTokenInfo),
                    buildInfoText("Name: ", name),
                    buildInfoText("Symbol: ", symbol),
                    buildInfoText("Total Supply: ", totalSupply),
                    Form(
                      key: walletAddressFormKey,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: buildTextFormField(
                            walletAddressCnt, "Wallet Address", checkAddress),
                      ),
                    ),
                    buildButton("Get My Balance", getBalance),
                    buildInfoText("Balance: ", balance),
                    const SizedBox(
                      height: 10,
                    )
                  ]),
                  const Text(
                    "Transfer Token",
                    style: TextStyle(fontSize: 20),
                  ),
                  buildContainer(transferFormKey, [
                    buildTextFormField(
                        recipientAddressCnt, "Recipient Address", checkAddress),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: buildTextFormField(
                          amountCnt, "Amount to Transfer", checkAmount,
                          textInputType: TextInputType.number),
                    ),
                    buildButton("Transfer", sendToken)
                  ]),
                  const Text(
                    "Transactions",
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: boxDecoration,
                      child: Column(
                        children: [
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: transfers.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              Transfer transaction = transfers[index];
                              return Card(
                                color: Color(
                                        (math.Random().nextDouble() * 0xFFFFFF)
                                            .toInt())
                                    .withOpacity(1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        buildText("From: ", transaction.from),
                                        buildText("To: ", transaction.to),
                                        buildText(
                                            "Amount: ", transaction.amount),
                                        TextButton(
                                          child: const Text(
                                              "Check in block explorer"),
                                          onPressed: () async {
                                            await launchUrl(transaction.hash);
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContainer(Key key, List<Widget> children) => Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: size.width,
          decoration: boxDecoration,
          child: Form(
            key: key,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        ),
      );

  TextFormField buildTextFormField(TextEditingController controller,
          String hintText, String? Function(String?)? validator,
          {TextInputType? textInputType}) =>
      TextFormField(
        style: const TextStyle(color: Colors.grey),
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
                fontFamily: "Catamaran",
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 17)),
        validator: validator,
      );

  String? checkAddress(String? value) {
    RegExp regExp = RegExp("^0x[a-fA-F0-9]{40}\$");
    if (!regExp.hasMatch(value!)) {
      return "Please enter valid Ethereum address";
    }
    return null;
  }

  Widget buildButton(String text, Future Function() onPressed) =>
      ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !isProgress
                ? Text(
                    text,
                    style: const TextStyle(fontSize: 15),
                  )
                : const Icon(Icons.lock)
          ],
        ),
      );

  Future getTokenInfo() async {
    if (!isProgress) {
      setState(() {
        isProgress = true;
      });
      await EasyLoading.show(status: "Loading...");

      if (tokenAddressFormKey.currentState!.validate()) {
        try {
          Map<String, String> tokenInfo =
              await Provider.of<UserModel>(context, listen: false)
                  .getTokenInfo(tokenAddressCnt.text);

          await listenEvent();

          setState(() {
            name = tokenInfo["name"]!;
            symbol = tokenInfo["symbol"]!;
            totalSupply = tokenInfo["totalSupply"]!;

            isProgress = false;
          });
          await EasyLoading.dismiss();
        } catch (e) {
          EasyLoading.showError("Failed to get token info");

          setState(() {
            isProgress = false;
          });
        }
      } else {
        showSnackBar();

        setState(() {
          isProgress = false;
        });

        EasyLoading.dismiss();
      }
    }
  }

  Future listenEvent() async {
    List eventAndStream = await Provider.of<UserModel>(context, listen: false)
        .listenEvent(tokenAddressCnt.text, "Transfer");
    ContractEvent contractEvent = eventAndStream[0] as ContractEvent;
    Stream<FilterEvent> stream = eventAndStream[1] as Stream<FilterEvent>;

    stream.listen((event) {
      List decoded = contractEvent.decodeResults(event.topics!, event.data!);
      String from = (decoded[0] as EthereumAddress).toString();
      String to = (decoded[1] as EthereumAddress).toString();
      String amount = (decoded[2] as BigInt).toString();
      String hash = event.transactionHash!;
      Transfer transfer =
          Transfer(from: from, to: to, amount: amount, hash: hash);
      setState(() {
        transfers.add(transfer);
      });
    });
  }

  showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter valid entry..."),
        duration: Duration(seconds: 2)));
  }

  Widget buildInfoText(String infoName, String info) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          infoName + info,
          style: const TextStyle(fontSize: 20),
        ),
      );

  Future getBalance() async {
    if (!isProgress) {
      setState(() {
        isProgress = true;
      });
      await EasyLoading.show(status: "Loading...");

      if (tokenAddressFormKey.currentState!.validate() &&
          walletAddressFormKey.currentState!.validate()) {
        try {
          String newBalance =
              await Provider.of<UserModel>(context, listen: false)
                  .getTokenBalance(tokenAddressCnt.text, walletAddressCnt.text);
          setState(() {
            balance = newBalance;
            isProgress = false;
          });
          await EasyLoading.dismiss();
        } catch (e) {
          EasyLoading.showError("Failed to get balance");

          setState(() {
            isProgress = false;
          });
        }
      } else {
        showSnackBar();

        setState(() {
          isProgress = false;
        });

        EasyLoading.dismiss();
      }
    }
  }

  String? checkAmount(String? value) {
    if (int.tryParse(value!) != null) {
      if (int.parse(value) < 0) {
        return "Please enter an amount which is greater than 0";
      }
      return null;
    }
    return "Please enter a amount which is a number";
  }

  Future sendToken() async {
    if (!isProgress) {
      setState(() {
        isProgress = true;
      });
      EasyLoading.show(status: "Loading...");

      if (tokenAddressFormKey.currentState!.validate() &&
          transferFormKey.currentState!.validate()) {
        try {
          int amount = int.parse(amountCnt.text);

          await Provider.of<UserModel>(context, listen: false).sendToken(
              tokenAddressCnt.text, recipientAddressCnt.text, amount);

          EasyLoading.showSuccess("Transfer token Success");

          setState(() {
            isProgress = false;
          });
        } catch (e) {
          EasyLoading.showError("Failed to transfer token");

          setState(() {
            isProgress = false;
          });
        }
      } else {
        showSnackBar();

        setState(() {
          isProgress = false;
        });

        EasyLoading.dismiss();
      }
    }
  }

  Widget buildText(String transactionInfo, String transaction) => Padding(
        padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
        child: Text(
          transactionInfo + transaction,
          style: const TextStyle(fontSize: 15),
        ),
      );

  Future launchUrl(String transactionHash) async {
    String etherScanUrl = "https://goerli.etherscan.io/tx/$transactionHash";

    if (await canLaunchUrlString(etherScanUrl)) {
      await launchUrlString(etherScanUrl);
    }
  }
}
