import "package:flutter/material.dart";
import "package:fioretti_app/models/school_event.dart";

class SchoolEventWidget extends StatelessWidget {
  const SchoolEventWidget(this.title, this.description, {Key? key})
      : super(key: key);

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.green),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [Text(title), Text(description)],
          ),
        ),
      ),
    );
  }
}
