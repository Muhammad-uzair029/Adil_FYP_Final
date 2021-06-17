// import 'package:Golobal_variable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_fyp/Add_fvrt/Global_variable.dart';
import 'package:ecommerce_fyp/Add_fvrt/Database.dart';
import 'package:ecommerce_fyp/User/OrderScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
// import 'package:page_transition/page_transition.dart';

class heart extends StatefulWidget {
  @override
  _heartState createState() => _heartState();
}

class _heartState extends State<heart> {
  final DBStudentManager dbStudentManager = new DBStudentManager();

  Student student;
  int updateindex;

  List<Student> studlist;

  dynamic data;
  int bill;
  @override
  Widget build(BuildContext context) {
    bill = 0;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text("Carts Products", style: TextStyle(color: Colors.black)),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: IconButton(
                  icon: Icon(Icons.description_outlined),
                  onPressed: () {
                    _showcontent(bill);
                  }),
            ),
          ],
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              size: 15,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: FutureBuilder(
          future: dbStudentManager.getStudentList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              studlist = snapshot.data;
              return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: studlist == null ? 0 : studlist.length,
                itemBuilder: (BuildContext context, int index) {
                  Variable.counter = studlist.length;
                  Student st = studlist[index];
                  print('Price Type');
                  print(st.productPrice.runtimeType);

                  print(st.productPrice);
                  bill = bill + int.parse(st.productPrice);

                  return _buildContactItem(
                      st.id,
                      index,
                      st.name,
                      st.productdescription,
                      st.email,
                      st.mobile,
                      st.address,
                      st.productName,
                      st.productPrice,
                      st.productID,
                      st.image,
                      st.shopkeeperID,
                      st.time);

                  // IconButton(
                  //   onPressed: () {
                  //     dbStudentManager.deleteStudent(st.id);
                  //     setState(() {
                  //       studlist.removeAt(index);
                  //     });
                  //   },
                  //   icon: Icon(
                  //     Icons.delete,
                  //     color: Colors.red,
                  //   ),
                  // ),
                },
              );
            }
            return CircularProgressIndicator();
          },
        ));
  }

  Widget details(String title, String value) {
    return RichText(
        text: TextSpan(children: <TextSpan>[
      TextSpan(
          text: title + ': ',
          style: TextStyle(
              fontSize: 14,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.bold,
              color: Colors.black)),
      TextSpan(
          text: value,
          style: TextStyle(
              fontSize: 12,
              color: Colors.blueGrey,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w700))
    ]));
  }

  QuerySnapshot snapshot;

  Widget _buildContactItem(
      int id,
      int index,
      name,
      description,
      email,
      mobile,
      address,
      productName,
      productPrice,
      productID,
      image,
      shopkeeperID,
      time) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(left: 20),
                // alignment: Alignment.bottomRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ImageShow(shopkeeperID),
                    Text(
                      productName,
                      style: TextStyle(fontSize: 18),
                    ),
                    details('Price Rs.', productPrice),
                    details('Product Details.', description),
                    details('Saved Time', time.toString().substring(0, 16)),
                    Container(
                      alignment: Alignment.bottomRight,
                      margin: const EdgeInsets.only(left: 150, top: 30),
                      child: MaterialButton(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Center(
                                    child: Icon(
                                  Icons.description,
                                  color: Colors.black,
                                  size: 30,
                                )),
                                IconButton(
                                  onPressed: () {
                                    dbStudentManager.deleteStudent(id);
                                    setState(() {
                                      studlist.removeAt(index);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                ),
                              ]),
                          onPressed: () {
                            getContents(shopkeeperID);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Order(
                                  name,
                                  description,
                                  email,
                                  mobile,
                                  address,
                                  productName,
                                  productPrice,
                                  productID,
                                  shopkeeperID,
                                  image);
                            }));
                          }),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Future getContents(String path) async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection(path).orderBy("images").get();
    return qn.docs;
  }

  void _showcontent(int bill) {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('You clicked on'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                new ListTile(
                  title: Text("This is the calculated bill fromm all products"),
                  subtitle: Text(bill.toString()),
                ),
              ],
            ),
          ),
          actions: [
            new FlatButton(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Widget ImageShow(String shopkeeperID) {
//   return
//  StreamBuilder(
//     stream: FirebaseFirestore.instance.collection(shopkeeperID).snapshots(),
//     builder: (context, snapshot) {
//       return !snapshot.hasData
//           ? Text('PLease Wait')
//           : Text("URL:::::::::::::::::::::" + snapshot.data()['image']);
//     });
//   FutureBuilder(
//       // This assumes you have a project on Firebase with a firestore database.
//       future: FirebaseFirestore.instance.collection(shopkeeperID).get(),
//       initialData: null,
//       builder:
//           (BuildContext context, AsyncSnapshot'<'QuerySnapshot'>' snapshot) {

//         return ClipRRect(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(8.0),
//             bottomLeft: Radius.circular(8.0),
//           ),
//           child: Image.network(
//           snapshot.data.documents['image'],
//             width: 130,
//             height: 130,
//             fit: BoxFit.fill,
//           ),
//         );
//       });
// }

// Widget products(BuildContext context) {
//   return Container(
//     child: dbStudentManager.getStudentList(), != 0
//         ? ListView.builder(
//             itemCount: dbStudentManager.getStudentList(),,
//             itemBuilder: (BuildContext context, int index) {
//               return ListTile(
//                 onTap: () {
//                   /*Navigator.push(context, MaterialPageRoute(builder: (context){
//                 return Product();
//               }));*/
//                 },
//                 title: Text(
//                   dataProducts[index].name,
//                   style: TextStyle(fontSize: 20.0),
//                 ),
//                 subtitle: Text(
//                   "Rs. " + dataProducts[index].price,
//                   style: TextStyle(fontSize: 15.0, color: Colors.amber),
//                 ),
//                 leading: CircleAvatar(
//                   radius: 30.0,
//                   backgroundImage: NetworkImage(dataProducts[index].image),
//                   backgroundColor: Colors.transparent,
//                 ),
//                 trailing: IconButton(
//                   icon: new Icon(Icons.add_shopping_cart),
//                   onPressed: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) {
//                       return Order(
//                           _name,
//                           _email,
//                           _mobile,
//                           _address,
//                           dataProducts[index].name,
//                           dataProducts[index].price,
//                           dataProducts[index].id,
//                           dataProducts[index].user,
//                           dataProducts[index].image);
//                     }));
//                   },
//                   iconSize: 30.0,
//                   color: Colors.black,
//                 ),
//               );
//             })
//         : Center(child: Text('Data Not Found')),
//   );
// }

// Widget gridProducts(BuildContext context) {
//   return GridView.builder(
//       itemCount: dbStudentManager.getStudentList(),,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, crossAxisSpacing: 2.0, mainAxisSpacing: 2.0),
//       itemBuilder: (context, index) {
//         return InkResponse(
//           onTap: () {
//             // Navigator.push(context, MaterialPageRoute(builder: (context) {
//             //   return Order(
//             //       _name,
//             //       _email,
//             //       _mobile,
//             //       _address,
//             //       newDataProducts[index].name,
//             //       newDataProducts[index].price,
//             //       newDataProducts[index].id,
//             //       newDataProducts[index].user,
//             //       dataProducts[index].image);
//             // }));
//           },
//           child: Card(
//             semanticContainer: true,
//             clipBehavior: Clip.antiAliasWithSaveLayer,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15.0),
//             ),
//             elevation: 3.0,
//             child: new Stack(
//               children: [
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height,
//                   child: Image.network(
//                     newDataProducts[index].image,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height,
//                   color: Colors.black12,
//                 ),
//                 Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         newDataProducts[index].name,
//                         style: TextStyle(
//                             color: Colors.amber,
//                             fontSize: 22.0,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       Text("Rs. " + newDataProducts[index].price,
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15.0,
//                               fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       });
// }
