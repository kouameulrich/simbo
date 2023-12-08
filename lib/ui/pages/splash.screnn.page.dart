import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:simbo_mobile/ui/pages/login.page.dart';
import 'package:simbo_mobile/widgets/default.colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
    return Scaffold(
      backgroundColor: Defaults.blueFondCadre,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 250,),
            Image.asset('images/logo_exports-02.png', width: 250, height: 150,),
            Container(
              width: 200,
              child: LinearPercentIndicator(
                width: 200,
                animation: true,
                lineHeight: 10.0,
                animationDuration: 3000,
                percent: 1,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Defaults.bluePrincipal,
              ),
            )
          ],
        ),
      ),
    );
  }
}
