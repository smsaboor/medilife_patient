import 'package:flutter/material.dart';

class PaymentTypeSheet extends StatefulWidget {
  const PaymentTypeSheet({Key? key}) : super(key: key);

  @override
  State<PaymentTypeSheet> createState() => _PaymentTypeSheetState();
}

class _PaymentTypeSheetState extends State<PaymentTypeSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .65,
              child: const Text('Select Payment Type',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.red),
            ),
          ),),
          Divider(thickness: 1),
          ListTile(
              leading: Icon(Icons.account_balance_wallet,color: Colors.deepPurple,),
              title: Text('Full Payment',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
              onTap: () {}),
          Divider(thickness: .1),
          ListTile(leading: Icon(Icons.account_balance_wallet_outlined,color: Colors.deepPurple,),
              title: Text('Partial Payment',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
              onTap: () {}),
        ],),
    );
  }
  Widget section(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }
}
