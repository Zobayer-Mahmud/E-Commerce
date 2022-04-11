import 'package:flutter/material.dart';
import 'package:vision/const/mycolor.dart';
import 'package:vision/ui/bottom_nav_pages/cart.dart';
import 'package:vision/ui/bottom_nav_pages/favourite.dart';
import 'package:vision/ui/bottom_nav_pages/home.dart';
import 'package:vision/ui/bottom_nav_pages/profile.dart';
class BottomNavBarController extends StatefulWidget {
  const BottomNavBarController({Key? key}) : super(key: key);

  @override
  State<BottomNavBarController> createState() => _BottomNavBarControllerState();
}

class _BottomNavBarControllerState extends State<BottomNavBarController> {
 final _pages=[
   HomeScreen(),
   FavouriteScreen(),
   CartSceen(),
   ProfileScreen(),
 ];
 var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Scaffold(
          appBar: AppBar(
           backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text("Vision",
              style: TextStyle(color: Colors.black,
              letterSpacing: 4),),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 5,
            selectedItemColor: Mycolors.deep_orange,
            unselectedItemColor: Colors.grey,
            currentIndex: _currentIndex,
            backgroundColor: Colors.white,
            selectedLabelStyle: TextStyle(color: Colors.black,fontWeight:FontWeight.bold ),
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_sharp),
                label: "Favourite",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: "Cart",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),

            ],
            onTap: (index){
              setState(() {
                _currentIndex=index;
              });
            },
          ),
          body: _pages[_currentIndex],
        ),

    );
  }
}

