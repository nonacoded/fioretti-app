import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fioretti_app/providers.dart';
import 'package:fioretti_app/models/user.dart';

class AppScaffold extends ConsumerStatefulWidget {
  final String title;
  final Widget body;

  const AppScaffold(
      {super.key, this.title = "Fioretti App", required this.body});

  @override
  ConsumerState<AppScaffold> createState() => AppScaffoldState();
}

class AppScaffoldState extends ConsumerState<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    int currentIndex = ref.watch(navigationBarIndexProvider);
    User? user = ref.watch(userProvider);

    bool isAdmin = false;
    if (user != null) {
      isAdmin = user.isAdmin;
    }

    List<BottomNavigationBarItem> normalItems = const [
      BottomNavigationBarItem(icon: Icon(Icons.home, ), label: "Home"),
      BottomNavigationBarItem(
          icon: Icon(Icons.local_activity, ), label: "Tickets"),
      BottomNavigationBarItem(
        icon: Icon(Icons.event),
        label: "Kalender",
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.account_circle, ), label: "Profiel"),
    ];

    List<BottomNavigationBarItem> adminItems =
        List<BottomNavigationBarItem>.from(normalItems)
          ..addAll([
            const BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner), label: "QR scannen"),
          ]);

    Scaffold result = Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[900],
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
          /*leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },*/
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/logo.png',
                width: 2000, // Adjust the width to your desired size
                height: 2000, // Adjust the height to your desired size// Added semantic label for accessibility
              ),
            ),
          ),
        ),
      body: widget.body,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        currentIndex: currentIndex,
        items: isAdmin ? adminItems : normalItems,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          ref.read(navigationBarIndexProvider.notifier).state = index;
          if (index == 0) {
            context.go("/home");
          } else if (index == 1) {
            context.go("/tickets");
          /*} else if (index == 2) {
            context.go("/events");*/
          } else if (index == 3) {
            context.go("/profile");
          } else if (index == 4 && isAdmin) {
            context.go("/qr-scanning");
          }else if (index == 2) {
            context.go("/calender"); 
          }         
        },
        backgroundColor: Colors.lightBlue[900],
      ),
    );
/*let op index navigationbar*/
    return result;
  }
}
