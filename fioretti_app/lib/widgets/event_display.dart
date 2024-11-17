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
        SizedBox(
            width: width * 0.9,
            height: height * 0.6,
            child: Column(
              children: [
                // title
                const SizedBox(height: 20),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      event.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.left,
                    )),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Flexible(
                            child: Column(children: [
                              Text(
                                event.description,
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ]),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(children: [
                      const Icon(Icons.calendar_month),
                      Text(" ${dateToString(event.date)}",
                          style: const TextStyle(
                              fontSize: 13.0, fontStyle: FontStyle.italic))
                    ]),
                    const SizedBox(height: 20),
                    Row(children: [
                      const Icon(Icons.schedule),
                      Text(" ${timeToString(event.date)}",
                          style: const TextStyle(
                              fontSize: 13.0, fontStyle: FontStyle.italic))
                    ]),
                    const SizedBox(height: 20),
                    Row(children: [
                      const Icon(Icons.euro),
                      Text(
                          " ${event.price < 0.1 ? "Gratis" : event.price.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 13.0))
                    ]),
                    const SizedBox(height: 20),
                    Row(children: [
                      const Icon(Icons.location_on),
                      Text(event.location,
                          style: const TextStyle(
                              fontSize: 13.0, fontStyle: FontStyle.italic))
                    ]),
                  ],
                ),
              ],
            ))
      ],
    );
  }
}
