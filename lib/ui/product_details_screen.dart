import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vision/const/mycolor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ProductDetailsScreen extends StatefulWidget {
 // const ProductDetailsScreen({Key? key}) : super(key: key);
var _products;
ProductDetailsScreen(this._products);
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
 var _dotpostion=0;
 Future addToCart() async{
   final FirebaseAuth _auth= FirebaseAuth.instance;
   var currentUser= _auth.currentUser;
   CollectionReference _collectionRef = FirebaseFirestore.instance.collection('user-cart-item');
   return _collectionRef.doc(currentUser!.email).collection('item').doc().set(
       {
         "name":widget._products['product-name'],
         "price":widget._products['product-price'],
         "images":widget._products['product-img'],
       }
   ).then((value) => Fluttertoast.showToast(msg: 'Added to cart'));
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CircleAvatar(
            maxRadius: 30.r,
            backgroundColor: Mycolors.deep_orange,
            child: IconButton(
              onPressed: ()=>Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircleAvatar(
              maxRadius: 30.r,
              backgroundColor: Mycolors.deep_orange,
              child: IconButton(
                onPressed: ()=>Navigator.pop(context),
                icon: Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(padding: EdgeInsets.only(left: 12,right: 12,top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
                aspectRatio:3.5,
                child: CarouselSlider(
                    items: widget._products['product-img']
                        .map<Widget>((item)=>Padding(
                          padding: const EdgeInsets.only(left: 3,right: 3),
                          child: Container(
                          //  width: MediaQuery.of(context).size.width*65,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(item),
                            //fit: BoxFit.fitHeight,
                            
                          )
                      ),
                    ),
                        ),
                    ).toList(),
                    options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      onPageChanged: (val, carouselPageChangedReason){
setState(() {
  _dotpostion=val;
});
                      }
                    ),
                ),
            ),
            SizedBox(height: 5.h,),
            Center(child: DotsIndicator(dotsCount: widget._products["product-img"].length==0?1:widget._products["product-img"].length,
              position: _dotpostion.toDouble(),
              decorator: DotsDecorator(
                color: Mycolors.deep_orange.withOpacity(0.5),
                activeColor: Mycolors.deep_orange,
                size: Size(6, 6),
                activeSize: Size(8, 8),
                spacing: EdgeInsets.all(4),

              ),
            ),
            ),
            SizedBox(height: 10.sp,),
            Text(widget._products['product-name'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.sp,
            ),),
            SizedBox(
              height: 7.h,
            ),
            Text(
                "${widget._products["product-price"].toString()} TK",
            style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: 30.sp,
            color: Colors.red),),
            SizedBox(
              height: 10,
            ),
            Text(widget._products['product-description'],
            style: TextStyle(
              fontSize: 16.sp,

            ),),
            SizedBox(height: 10.sp,),
            Divider(),
            SizedBox(height: 56.h,
            width: 1.sw,

            child: ElevatedButton(

                onPressed: (){
                      addToCart();

                },
                child: Text('Add to cart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,

                ),
                ),
              style: ElevatedButton.styleFrom(
                primary: Mycolors.deep_orange,
                elevation: 3,
              ),
            ),
            ),
            

          ],
        ),
        ),
      ),
    );
  }
}
