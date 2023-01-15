class Transfer {
  String from;
  String to;
  String amount;
  String hash;

  Transfer(
      {required this.from,
      required this.to,
      required this.amount,
      required this.hash});

  @override
  String toString() {
    return 'Transfer{from: $from, to: $to, amount: $amount, hash: $hash}';
  }
}
