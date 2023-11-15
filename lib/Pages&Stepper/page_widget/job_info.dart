import 'package:flutter/material.dart';

class JobInfoPage extends StatefulWidget{

  @override
  State<JobInfoPage> createState() => _JobInfoPageState();

}

class _JobInfoPageState extends State<JobInfoPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 90,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.deepPurple,
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
