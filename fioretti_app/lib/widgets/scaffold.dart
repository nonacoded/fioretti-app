import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fioretti_app/providers.dart';

class AppScaffold extends ConsumerStatefulWidget {
  final String title;
  final Widget body;

  const AppScaffold(
      {super.key, this.title = "Fioretti App", required this.body});

  @override
  ConsumerState<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends ConsumerState<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    int currentIndex = ref.watch(navigationBarIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: widget.body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: "Evenementen",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_activity), label: "Tickets"),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner), label: "Scan Ticket"),
        ],
        onTap: (int index) {
          ref.read(navigationBarIndexProvider.notifier).state = index;
          if (index == 0) {
            context.go("/home");
          } else if (index == 1) {
            context.go("/tickets");
          } else if (index == 2) {
            context.go("/qr-scanning");
          }
        },
      ),
    );
  }
}
