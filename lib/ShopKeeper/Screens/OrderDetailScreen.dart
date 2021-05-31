import 'package:flutter/material.dart';

class OrderDetail extends StatefulWidget {

  String name;
  String email;
  String phone;
  String address;
  String productName;
  String productPrice;


  OrderDetail(this.name, this.email, this.phone, this.address, this.productName,
      this.productPrice);

  @override
  _OrderDetailState createState() => _OrderDetailState(name,email,phone,address,productName,productPrice);
}

class _OrderDetailState extends State<OrderDetail> {

  String name;
  String email;
  String phone;
  String address;
  String productName;
  String productPrice;


  _OrderDetailState(this.name, this.email, this.phone, this.address,
      this.productName, this.productPrice);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child:Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text('Name',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 20,
                    ),),


                  Text('Email',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 20,
                    ),),


                  Text('Phone',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 20,
                    ),),

                  Text('Address',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 20,
                    ),),


                  Text('Product Name',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 20,
                    ),),


                  Text('Product Price',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 20,
                    ),),


                ],

              ),

              SizedBox(
                width: 20.0,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),),


                  Text(email,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),),


                  Text(phone,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),),

                  Text(address,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),),


                  Text(productName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),),


                  Text(productPrice,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),),


                ],

              ),

            ],

          ),
        ),
      ),
    );
  }
}
