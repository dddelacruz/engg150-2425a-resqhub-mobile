import 'package:engg150_2425a_reqhub/qr_page.dart';
import 'package:engg150_2425a_reqhub/register_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NavBar(),
    );
  }
}

class NavBar extends StatefulWidget{
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("ResQHub"),
      ),

      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.qr_code_2),
            label: 'Scan QR',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.person_add_alt)),
            label: 'Register',
          ),
        ],
      ),

      body: <Widget>[
        QRScanner(),
        RegisterForm(),
      ][currentPageIndex],
    );
  }
}