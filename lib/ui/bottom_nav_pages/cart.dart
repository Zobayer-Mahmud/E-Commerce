import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartSceen extends StatefulWidget {
  const CartSceen({Key? key}) : super(key: key);

  @override
  State<CartSceen> createState() => _CartSceenState();
}

class _CartSceenState extends State<CartSceen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('user-cart-item').doc(FirebaseAuth.instance.currentUser!.email).collection('items').snapshots(),

        builder: (BuildContext context, AsyncSnapshot <QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Center(
              child: Text('Something is wrong'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
              itemBuilder: (_,index){
              DocumentSnapshot _documentSnapshot=snapshot.data!.docs[index];
              return ListTile(
                leading: Text(_documentSnapshot['name']),
                title: Text("\$ ${_documentSnapshot['price']}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),),


              );
              }

          );
        } ,

      )
      ) ,
    );
  }
}
