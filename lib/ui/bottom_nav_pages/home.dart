import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vision/const/mycolor.dart';
import 'package:vision/ui/product_details_screen.dart';
import 'package:vision/ui/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _carouselImages = [];
  var _dotPosition = 0;
  List _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;

  fetchCarouselImages() async {
    QuerySnapshot qn =
    await _firestoreInstance.collection("carousel-slider").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(
          qn.docs[i]["img-path"],
        );
        print(qn.docs[i]["img-path"]);
      }
    });

    return qn.docs;
  }
fetchProducts ()async {
  QuerySnapshot qn = await _firestoreInstance.collection("products").get();
  setState(() {
    for (int i = 0; i < qn.docs.length; i++) {
      _products.add({
        "product-name": qn.docs[i]["product-name"],
        "product-description": qn.docs[i]["product-description"],
        "product-price": qn.docs[i]["product-price"],
        "product-img": qn.docs[i]["product-img"],
      });
    }
  });
  return qn.docs;
}
@override
  void initState() {
   fetchCarouselImages();
   fetchProducts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Container(
          child: Column(
            children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w,right: 10.w),
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.blue)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey)),
                  hintText: "Search products here",
                  hintStyle: TextStyle(fontSize: 15.sp),
                ),


                onTap: (){
                  Navigator.push(context, CupertinoPageRoute(builder: (_)=>SearchScreen()));
                },

              ),
            ),
              /*   Container(
                  margin: EdgeInsets.only(right: 10.w),
                  padding: EdgeInsets.only(right: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Mycolors.deep_orange,
                  ),

                  height: 50.h,
                  width: 50.h,
                  child: IconButton(
                    icon: Center(child: Icon(Icons.search_outlined,color: Colors.white,)),
                    onPressed: (){},
                    iconSize: 30,
                  ),
                )*/
              SizedBox(height: 10.h,),
              AspectRatio(
                aspectRatio: 3.5,
                child: CarouselSlider(
                    items: _carouselImages.map((item) => Padding(
                      padding: EdgeInsets.only(left: 3,right: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(item),
                            fit: BoxFit.fitWidth,
                          ),
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
                          _dotPosition=val;
                        });
                      }
                    )),
              
              ),
              SizedBox(height: 10.h,),
              DotsIndicator(
                dotsCount: _carouselImages.length==0?1:_carouselImages.length,
                position:_dotPosition.toDouble(),
                decorator: DotsDecorator(
                  color: Mycolors.deep_orange.withOpacity(0.5),
                  activeColor: Mycolors.deep_orange,
                 size: Size(6, 6),
                  activeSize: Size(8, 8),
                  spacing: EdgeInsets.all(4),

                ),

              ),
              Expanded(
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                      itemCount: _products.length,


                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,

                      ),
                     itemBuilder: (_,index){
                      return GestureDetector(
                        onTap: ()=> Navigator.push(context,
                        MaterialPageRoute(builder: (_)=>ProductDetailsScreen(_products[index]))),
                        child: Card(
                          elevation: 3,
                          child: Column(
                            children: [
                              AspectRatio(
                                  aspectRatio: 2,
                                  child: Image.network(_products[index]["product-img"][0],)),
                              SizedBox(height: 5.h,),
                              Text("${_products[index]["product-name"]}",
                                style: TextStyle(fontSize: 18.sp),),
                              SizedBox(height: 5.h,),
                              Text("${_products[index]["product-price"].toString()} BDT",style: TextStyle(fontWeight: FontWeight.bold),),

                            ],
                          ),

                        ),
                      );
                     },
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

