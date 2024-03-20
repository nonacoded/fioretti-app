import 'package:fioretti_app/models/ticket.dart';
import 'package:fioretti_app/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatelessWidget {
  final Ticket ticket;

  const QrCodePage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: ticket.event.title,
      body: Column(
         children:[ 
          Align(alignment: Alignment.topLeft,
          child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child : Container(
                padding: const EdgeInsets.all(15.0),
                                  child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.grey,
                    size: 20,
                    ),
                  ),),),
                  const SizedBox(height: 100),
       Align(alignment: Alignment.center,
          child:  QrImageView(
          data: ticket.id,
          version: QrVersions.auto,
          size: 300.0,
        ),
      ),],
          ),  
    );
  }
}
