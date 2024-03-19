import 'package:fioretti_app/functions/utils.dart';
import 'package:fioretti_app/models/school_event.dart';
import 'package:fioretti_app/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EventDisplay extends StatelessWidget {
  final SchoolEvent event;

  const EventDisplay({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return AppScaffold(
      appBar: AppBar(
        title: const Text("Ticket info", style: TextStyle(color: Colors.white),),
        centerTitle: true,
          leading: GestureDetector(
            /*onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },*/
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/logo.png',
                width: 60, // Adjust the width to your desired size
                height: 60, // Adjust the height to your desired size// Added semantic label for accessibility
              ),
            ),
          ),
        backgroundColor: Colors.lightBlue[900],
      ),
      body: Container(
            width: width * 0.9,
            height: height * 0.6,
            child: Column(
              children: [
                // title
                const SizedBox(height: 20),
                Align(alignment: Alignment.centerLeft,
                child: Container(child: Text(event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ), textAlign: TextAlign.left,
                    ),)),
                    const SizedBox(height: 10),
                Column(
                  children: [
                    
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    //color: const Color.fromRGBO(134, 195, 235, 100),
                   child: Row(
                    children: [
                      Flexible(
                      child: Column(
                      children: [
                        Text(event.description, style: const TextStyle(fontSize: 16.0),),]
                      ),
      )
    ],
  ), ), ),  
                    const SizedBox(height: 20),
                   
                    Row(
                      children:[
                        const Icon(Icons.calendar_month),
                        Text("${dateToString(event.date)}",
                          style: const TextStyle(
                            fontSize: 13.0, fontStyle: FontStyle.italic))]),
                    const SizedBox(height: 10),
                    const Row(
                      children:[
                         Icon(Icons.schedule),
                         Text("..:.. - ..:..",
                          style:  TextStyle(
                            fontSize: 13.0, fontStyle: FontStyle.italic))]),
                    const SizedBox(height: 10),
                    Row( 
                      children:[ 
                        const Icon(Icons.euro),
                        Text("${event.price}",
                          style: const TextStyle(fontSize: 13.0))]),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.location_on),
                        Text(event.location,
                          style: const TextStyle(
                            fontSize: 13.0, fontStyle: FontStyle.italic))]),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ))
      ],
    );
  }
}

