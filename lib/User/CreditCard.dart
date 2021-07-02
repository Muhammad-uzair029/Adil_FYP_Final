import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_fyp/Add_fvrt/Database.dart';
import 'package:ecommerce_fyp/Global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../Utils.dart';
import 'package:toast/toast.dart';
import 'package:ecommerce_fyp/Add_fvrt/fvrt_list.dart';

class CreditCardPage extends StatefulWidget {
  final String _etName,
      _etEmail,
      _etPhone,
      _etAddress,
      _productID,
      _productName,
      _productPrice,
      _ShopKeeperID;

  const CreditCardPage(
    this._etName,
    this._etEmail,
    this._etPhone,
    this._etAddress,
    this._productID,
    this._productName,
    this._productPrice,
    this._ShopKeeperID,
  );

  @override
  State<StatefulWidget> createState() {
    return CreditCardPageState();
  }
}

class CreditCardPageState extends State<CreditCardPage> {
  final FirebaseFirestore _message = FirebaseFirestore.instance;

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: false,
        title: Center(child: Text("Pay For :" + widget._productName)),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardBgColor: Colors.greenAccent,
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              height: 175,
              obscureCardCvv: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CreditCardForm(
                      formKey: formKey,
                      onCreditCardModelChange: onCreditCardModelChange,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumberDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Number',
                        hintText: 'XXXX XXXX XXXX XXXX',
                      ),
                      expiryDateDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Expired Date',
                        hintText: 'XX/XX',
                      ),
                      cvvCodeDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'CVV',
                        hintText: 'XXX',
                      ),
                      cardHolderDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Card Holder Name',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: const Text(
                          'Validate and Make Order',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      color: Colors.green,
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          print('valid!');
                          orderProduct();
                          _showValidDialog(context, "Valid",
                              "You successfully Pay for this Item !!!");
                        } else {
                          _showValidDialog(context, "invalid",
                              "Somwthing went wrong with your !!!");
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<AlertDialog> _showValidDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xff1b447b),
          title: Text(title),
          content: Text(content),
          actions: [
            FlatButton(
                child: Text(
                  "Ok",
                  style: TextStyle(fontSize: 18, color: Colors.white54),
                ),
                onPressed: () {
                  DatePicker.showTimePicker(context, showTitleActions: true,
                      onChanged: (date) {
                    print('change $date in time zone ' +
                        date.timeZoneOffset.inHours.toString());
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }, onConfirm: (date) {
                    print('confirm $date');
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }, currentTime: DateTime.now());
                }),
          ],
        );
      },
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  orderProduct() async {
    print(widget._productPrice);
    Utils.loader(context);
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('orders').push();
    await databaseReference.set({
      'user_id': FirebaseAuth.instance.currentUser.uid,
      'user_name': widget._etName,
      'user_email': widget._etEmail,
      'user_phone': widget._etPhone,
      'user_address': widget._etAddress,
      'product_id': widget._productID,
      'product_name': widget._productName,
      'product_price': widget._productPrice,
      'ShopKeeper_id': widget._ShopKeeperID,
      'status': "Pending",
      'shippingstatus': "0"
    });
    _message
        .collection('usertoken')
        .doc(widget._ShopKeeperID)
        .get()
        .then((value) {
      if (value.exists) {
        print(value['token']);
        Global.sendnotification(
          value['token'],
          "New Order!",
          "You have a New Order from " + widget._etName,
        );
      } else {
        print('Doesnot exists');
      }
    });
    // Navigator.pop(context);
    // Navigator.pop(context);
  }
}
