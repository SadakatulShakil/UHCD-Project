import 'package:flutter/material.dart';

class OthersInfoPage extends StatefulWidget{

  @override
  State<OthersInfoPage> createState() => _OthersInfoPageState();

}

class _OthersInfoPageState extends State<OthersInfoPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 90,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mic),
                    Text('00:00'),
                    Text('Press START')
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

}
