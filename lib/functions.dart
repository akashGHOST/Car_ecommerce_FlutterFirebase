import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CarMethods{
  isLoggedIn(){
    if(FirebaseAuth.instance.currentUser != null){
      return true;
    }
    else{
      return false;
    }
  }

  Future<void> addData(carData) async {
    if(isLoggedIn()){
      FirebaseFirestore.instance.collection('cars').add(carData).catchError((e){
        print(e);
      });
    }
    else{
      print("You need to be Signed in");
    }
  }

  getData() async {
    return await FirebaseFirestore.instance.collection('cars').orderBy('time', descending: true).get();
  }

  updateData(selectedDoc, newValue){
    FirebaseFirestore.instance.collection('cars').doc(selectedDoc).update(newValue).catchError((e){
      print(e);
    });
  }

  deleteData(docId){
    FirebaseFirestore.instance.collection('cars').doc(docId).delete().catchError((e){
      print(e);
    });
  }
}
