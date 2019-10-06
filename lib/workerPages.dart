import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:node_auth/home.dart';
import 'package:node_auth/HistoriquePage.dart';

class WorkerPages extends StatefulWidget {
  final String token;
  WorkerPages(this.token);
 
  @override
  _WorkerPagesState createState() => _WorkerPagesState();
}

class _WorkerPagesState extends State<WorkerPages> {
static String _token;
int _selectedIndex=0;
PageController _pageController;


  
  @override
  void initState() {
    super.initState();

     _token = widget.token; 
     print("_token in workerPages");
     print(_token);
       
  }
  
  final pageOptions = [
         new HomePage(_token),
         new HistoriquePage(_token),        
    ];
  

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageOptions[_selectedIndex],
    
      bottomNavigationBar: BottomNavyBar(
      selectedIndex: _selectedIndex,       
      showElevation: true, // use this to remove appBar's elevation
      onItemSelected: (index) => setState(() {
            _selectedIndex = index;
            
           _pageController.animateToPage(index,
                           duration: Duration(milliseconds: 300), curve: Curves.ease);
                     }),
                     
                 items: [
                   BottomNavyBarItem(
                       icon: Icon(Icons.home),
                       title: Text('Dashboard'),
                       activeColor: Colors.pink),
                   BottomNavyBarItem(
                     icon: Icon(Icons.apps),
                     title: Text('Historique'),
                     activeColor: Color.fromRGBO(55, 230, 199, 1.0),
                   ),
                
                 ],
               ),  




















      
      // AnimatedBottomBar(
      //     barItems: widget.barItems,
      //     animationDuration: const Duration(milliseconds: 150),
      //     barStyle: BarStyle(
      //       fontSize: 20.0,
      //       iconSize: 30.0
      //     ),
      //     onBarTap: (index) {
      //       setState(() {
      //         selectedBarIndex = index;
      //       });
      //     }),
    );
  }
}