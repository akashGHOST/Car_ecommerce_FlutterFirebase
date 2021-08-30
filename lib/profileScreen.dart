import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_car/GlobalVar.dart';
import 'package:i_car/functions.dart';
import 'package:i_car/homeScreen.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'dart:io' show Platform;

class ProfileScreen extends StatefulWidget {

  String sellerId;

  ProfileScreen({required this.sellerId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;
  late String userName;
  late String userNumber;
  late String carPrice;
  late String carModel;
  late String carColor;
  late String description;
  late String urlImage;
  late String carLocation;
  QuerySnapshot? cars;
  late String userId;

  CarMethods carObj = new CarMethods();

  Future showDialogForUpdateData(selectedDoc) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(
              'Update Data',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Bebas',
                letterSpacing: 2.0,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      hintText: "Enter Your Name"
                  ),
                  onChanged: (value){
                    this.userName = value;
                  },
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Enter Your Phone Number"
                  ),
                  onChanged: (value){
                    this.userNumber = value;
                  },
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Enter Your Car Price"
                  ),
                  onChanged: (value){
                    this.carPrice = value;
                  },
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Enter Your Car Model"
                  ),
                  onChanged: (value){
                    this.carModel = value;
                  },
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Enter Your Car Color"
                  ),
                  onChanged: (value){
                    this.carColor = value;
                  },
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Enter Location"
                  ),
                  onChanged: (value){
                    this.carLocation = value;
                  },
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Enter Car Description"
                  ),
                  onChanged: (value){
                    this.description = value;
                  },
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Enter Image URL"
                  ),
                  onChanged: (value){
                    this.urlImage = value;
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text(
                    'Cancel'
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                  Map<String, dynamic> carData = {
                    'usersName': this.userName,
                    'carPrice': this.carPrice,
                    'carModel': this.carModel,
                    'carColor': this.carColor,
                    'carLocation': this.carLocation,
                    'description': this.description,
                    'urlImage': this.urlImage,
                    'imageProfile': userImageURl,
                    'time': DateTime.now()
                  };
                  carObj.updateData(selectedDoc, carData).then((value){
                    print('Data updated successfully');
                    print(carData);
                    print(carObj);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).catchError((e){
                    print(e);
                  });
                },
                child: Text('Update'),
              ),
            ],
          );
        });
  }

  Widget _buildBackButton(){
    return IconButton(
        onPressed: (){
          Route newRoute = MaterialPageRoute(builder: (_) => HomeScreen());
          Navigator.pushReplacement(context, newRoute);
        },
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white
        ),
    );
  }

  getResults(){
    FirebaseFirestore.instance.collection('cars')
        .where('uid', isEqualTo: widget.sellerId)
        .get()
        .then((results){
          setState(() {
            cars = results;
            adUserName = cars!.docs[0].data()['usersName'];
            adUserImageURL = cars!.docs[0].data()['imageProfile'];
          });
    });
  }

  @override
  void initState(){
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    print(userId);
    getResults();
  }

  Widget showCarsList() {
    if(cars != null){
      print('if widget');
      print(cars);
      return ListView.builder(
        itemCount: cars!.docs.length,
        padding: EdgeInsets.all(8),
        itemBuilder: (context, r){
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: GestureDetector(
                    onTap: (){
                      Route newRoute = MaterialPageRoute(builder: (_) => ProfileScreen(sellerId: cars!.docs[r].data()['uid']));
                      Navigator.pushReplacement(context, newRoute);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(cars!.docs[r].data()['imageProfile']),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  title: GestureDetector(
                    onTap: (){
                      Route newRoute = MaterialPageRoute(builder: (_) => ProfileScreen(sellerId: cars!.docs[r].data()['uid']));
                      Navigator.pushReplacement(context, newRoute);
                    },
                    child: Text(cars!.docs[r].data()['usersName']),
                  ),
                  subtitle: GestureDetector(
                    onTap: (){
                      Route newRoute = MaterialPageRoute(builder: (_) => ProfileScreen(sellerId: cars!.docs[r].data()['uid']));
                      Navigator.pushReplacement(context, newRoute);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          cars!.docs[r].data()['carLocation'],
                          style: TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                        SizedBox(width: 4.0),
                        Icon(Icons.location_pin, color: Colors.grey),
                      ],
                    ),
                  ),
                  trailing: cars!.docs[r].data()['uid'] == userId ?
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: (){
                          if(cars!.docs[r].data()['uid'] == userId){
                            showDialogForUpdateData(cars!.docs[r].id);
                          }
                        },
                        child: Icon(Icons.edit_outlined),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onDoubleTap: (){
                          if(cars!.docs[r].data()['uid'] == userId){
                            carObj.deleteData(cars!.docs[r].id);
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext c) => HomeScreen()));
                          }
                        },
                        child: Icon(Icons.delete_forever_sharp),
                      )
                    ],
                  ) : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.network(cars!.docs[r].data()['urlImage'], fit: BoxFit.fill),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    '\$' + cars!.docs[r].data()['carPrice'],
                    style: TextStyle(
                        fontFamily: 'Babas',
                        letterSpacing: 1.0,
                        fontSize: 20
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.directions_car),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Align(
                              child: Text(cars!.docs[r].data()['carModel']),
                              alignment: Alignment.topLeft,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.watch_later_outlined),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Align(
                              // child: Text(cars.docs[i].data()['carModel']),
                              child: Text(tAgo.format((cars!.docs[r].data()['time']).toDate())),
                              alignment: Alignment.topLeft,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 13.0, top: 5),
                      child: Icon(Icons.brush_outlined),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Align(
                        child: Text(cars!.docs[r].data()['carColor']),
                        alignment: Alignment.topLeft,
                      ),
                    ),
                  ],
                ),
                // Row(
                //   children: [
                //     Icon(Icons.phone_android),
                //     Padding(
                //       padding: const EdgeInsets.only(left: 10),
                //       child: Align(
                //         child: Text(cars!.docs[1].data()['userNumber']),
                //         alignment: Alignment.topRight,
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(cars!.docs[r].data()['description'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    }
    else{
      return Text('Loading');
    }
  }

  Widget _buildUserImage(){
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: NetworkImage(adUserImageURL),
            fit: BoxFit.fill
        ),
      ),
    );
  }


  
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: _buildBackButton(),
        title: Row(
          children: [
            _buildUserImage(),
            SizedBox(width: 10),
            Text(adUserName),
          ],
        ),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Colors.blueAccent,
                  Colors.redAccent
                ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: Platform.isAndroid || Platform.isIOS ? _screenWidth: _screenWidth * 0.5,
          child: showCarsList(),
        ),
      ),
    );
  }
}

