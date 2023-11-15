import 'package:flutter/material.dart';

class FinancialInfoPage extends StatefulWidget{

  @override
  State<FinancialInfoPage> createState() => _FinancialInfoPageState();

}

class _FinancialInfoPageState extends State<FinancialInfoPage>{
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
