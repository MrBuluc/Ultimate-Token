import 'package:flutter/material.dart';

class TokenPage extends StatefulWidget {
  const TokenPage({Key? key}) : super(key: key);

  @override
  State<TokenPage> createState() => _TokenPageState();
}

class _TokenPageState extends State<TokenPage> {
  GlobalKey<FormState> tokenAddressFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> walletAddressFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> transferAddressFormKey = GlobalKey<FormState>();

  TextEditingController tokenAddressCnt = TextEditingController();
  TextEditingController walletAddressCnt = TextEditingController();
  TextEditingController recipientAddressCnt = TextEditingController();
  TextEditingController amountCnt = TextEditingController();

  String name = "UltimateToken",
      symbol = "UTN",
      totalSupply = "1000000",
      balance = "1000000";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                const Text(
                  "Read from Token",
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3))
                        ]),
                    child: Form(
                      key: tokenAddressFormKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTextFormField(
                                tokenAddressCnt, "Token Address", checkAddress),
                            buildButton("Get Token Info"),
                            buildInfoText("Name: ", name),
                            buildInfoText("Symbol: ", symbol),
                            buildInfoText("Total Supply: ", totalSupply),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: buildTextFormField(walletAddressCnt,
                                  "Wallet Address", checkAddress),
                            ),
                            buildButton("Get My Balance")
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField(TextEditingController controller,
          String hintText, String? Function(String?)? validator) =>
      TextFormField(
        style: const TextStyle(color: Colors.grey),
        controller: controller,
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

  Widget buildButton(String text) => ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        onPressed: () {},
      );

  Widget buildInfoText(String infoName, String info) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          infoName + info,
          style: const TextStyle(fontSize: 20),
        ),
      );
}
