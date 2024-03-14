import 'package:fioretti_app/functions/utils.dart';
import 'package:fioretti_app/models/school_event.dart';
import 'package:flutter/material.dart';

class EventDisplay extends StatelessWidget {
  final SchoolEvent event;

  const EventDisplay({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
            alignment: Alignment.center,
            width: width * 0.8,
            height: height * 0.4,
            child: Column(
              children: [
                // title
                Text(event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children:[
                        const Icon(Icons.calendar_month),
                        Text("Datum: ${dateToString(event.date)}",
                          style: const TextStyle(
                            fontSize: 13.0, fontStyle: FontStyle.italic))]),
                    /*Row(
                      children:[
                        const Icon(Icons.schedule),
                        Text("Tijd: ${dateTimeToString(event.date)}",
                          style: const TextStyle(
                            fontSize: 13.0, fontStyle: FontStyle.italic))]),*/
                    Row( 
                      children:[ 
                        const Icon(Icons.euro),
                        Text("${event.price}",
                          style: const TextStyle(fontSize: 13.0))]),
                    Row(
                      children: [
                        const Icon(Icons.location_on),
                        Text(event.location,
                          style: const TextStyle(
                            fontSize: 13.0, fontStyle: FontStyle.italic))]),
                  ],
                ),
                Text(event.description, style: const TextStyle(fontSize: 16.0)),
              ],
            ))
      ],
    );
  }
}
