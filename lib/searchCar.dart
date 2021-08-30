import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_car/profileScreen.dart';
import 'package:timeago/timeago.dart' as tAgo;

import 'homeScreen.dart';
import 'dart:io' show Platform;

class SearchCar extends StatefulWidget {
  const SearchCar({Key? key}) : super(key: key);

  @override
  _SearchCarState createState() => _SearchCarState();
}

class _SearchCarState extends State<SearchCar> {

  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";

  FirebaseAuth auth = FirebaseAuth.instance;
  late String carModel;
  late String carColor;

  QuerySnapshot? cars;

  Widget _buildSearchField(){
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search",
        border: InputBorder.none,
        hintStyle: TextStyle(
          fontSize: 20,
          color: Colors.white30
        ),
      ),
      style: TextStyle(
        color: Colors.white,
      fontSize: 18
    ),
      onChanged: (query)=> updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions(){
    if(_isSearching){
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
            onPressed: (){
              if(_searchQueryController == null || _searchQueryController.text.isEmpty){
                Navigator.pop(context);
                return;
              }
              _clearSearchQuery();
            },
        ),
      ];
    }
    return <Widget>[
    IconButton(
      icon: const Icon(Icons.search),
      onPressed: _startSearch,
    ),
    ];
  }

  _startSearch(){
    ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  _stopSearching(){
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }

  _buildTitle(BuildContext context){
    return Text("Search Car");
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

  _clearSearchQuery(){
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  updateSearchQuery(String newQuery){
    setState(() {
      getResults();
      searchQuery = newQuery;
    });
  }

  getResults(){
    FirebaseFirestore.instance.collection('cars')
    .where('carModel', isGreaterThanOrEqualTo: _searchQueryController.text.trim()).get()
    .then((results){
      setState(() {
        cars = results;
        print('this is the result');
        print("result " + cars!.docs[0].data()['carModel']);
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
                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                          SizedBox(width: 4.0),
                          Icon(Icons.location_pin, color: Colors.grey),
                        ],
                      ),
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
        leading: _isSearching ? const BackButton() : _buildBackButton(),
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildActions(),
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
          width: Platform.isAndroid || Platform.isIOS? _screenWidth : _screenWidth * 0.6,
          child: showCarsList(),
        )
      )
    );
  }
}
