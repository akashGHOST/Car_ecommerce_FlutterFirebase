import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:i_car/authenticationScreen.dart';
import 'package:i_car/functions.dart';

import 'GlobalVar.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'profileScreen.dart';
import 'searchCar.dart';
import 'dart:io' show Platform;

class HomeScreen extends StatefulWidget {


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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

  Future showDialogForAddingData() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(
              'Post a new AD',
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
                    Map<String, dynamic> carData = {
                      'usersName': this.userName,
                      'uid': userId,
                      'carPrice': this.carPrice,
                      'carModel': this.carModel,
                      'carColor': this.carColor,
                      'carLocation': this.carLocation,
                      'description': this.description,
                      'urlImage': this.urlImage,
                      'imageProfile': userImageURl,
                      'userNumber': this.userNumber,
                      'time': DateTime.now()
                    };
                    carObj.addData(carData).then((value){
                      print('Data added successfully');
                      print(carData);
                      print(carObj);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    }).catchError((e){
                      print(e);
                    });
                  },
                  child: Text('Add'),
              ),
            ],
          );
        });
  }

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
  
  getMyData() {
     FirebaseFirestore.instance.collection('users').doc(userId).get().then((results){
      setState(() {
        userImageURl =  results.data()!['imageProfile'];
        getUserName = results.data()!['userName'];
      });
    });
  }

  @override
  void initState(){
    super.initState();

    userId = FirebaseAuth.instance.currentUser!.uid;
    print(userId);
    userEmail = FirebaseAuth.instance.currentUser!.email!;
    print(userEmail);

    getMyData();

    carObj.getData().then((results){
      setState(() {
        cars = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;

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
                              overflow: TextOverflow.ellipsis,
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.refresh, color: Colors.white),
          onPressed: (){
            Route newRoute = MaterialPageRoute(builder: (_) => HomeScreen());
            Navigator.pushReplacement(context, newRoute);
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: (){
              Route newRoute = MaterialPageRoute(builder: (_) => ProfileScreen(sellerId: userId));
              Navigator.pushReplacement(context, newRoute);
            },
            child: Padding(
              padding: Platform.isAndroid || Platform.isIOS ? const EdgeInsets.all(1.0) : const EdgeInsets.all(10.0),
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: (){
              Route newRoute = MaterialPageRoute(builder: (_) => SearchCar());
              Navigator.pushReplacement(context, newRoute);
            },
            child: Padding(
              padding:Platform.isAndroid || Platform.isIOS ? const EdgeInsets.all(1.0) : const EdgeInsets.all(10.0),
              child: Icon(Icons.search, color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: (){
              auth.signOut().then((_){
                Route newRoute = MaterialPageRoute(builder: (_) => AuthenticationScreen());
                Navigator.pushReplacement(context, newRoute);
              });
            },
            child: Padding(
              padding: Platform.isAndroid || Platform.isIOS ? const EdgeInsets.all(1.0) : const EdgeInsets.all(10.0),
              child: Icon(Icons.login_outlined, color: Colors.white),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [
                Colors.blueAccent,
                Colors.redAccent,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp
            ),
          ),
        ),
        title: Text('Home Page'),
        centerTitle: Platform.isAndroid || Platform.isIOS ? false :  true,
      ),
      body: Center(
        child: Container(
          width: Platform.isAndroid || Platform.isIOS ? _screenWidth : _screenWidth * 0.5,
          child: showCarsList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialogForAddingData();
        },
        tooltip: 'Add Post',
        child: Icon(Icons.add),
      ),
    );
  }
}
