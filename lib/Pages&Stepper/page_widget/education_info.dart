import 'package:flutter/material.dart';

class EducationalInfoPage extends StatefulWidget{

  @override
  State<EducationalInfoPage> createState() => _EducationalInfoPageState();

}

class _EducationalInfoPageState extends State<EducationalInfoPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 90,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.red,
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
