import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simbo_mobile/models/dbhelper.dart';
import 'package:simbo_mobile/ui/pages/collecte.page.dart';
import 'package:simbo_mobile/ui/pages/home.page.dart';
import 'package:simbo_mobile/ui/pages/login.page.dart';
import 'package:simbo_mobile/ui/pages/liste.recensement.page.dart';
import 'package:simbo_mobile/ui/pages/payment.page.dart';
import 'package:simbo_mobile/ui/pages/splash.screnn.page.dart';
import 'package:simbo_mobile/ui/pages/transfert.page.dart';
import 'package:simbo_mobile/widgets/default.colors.dart';
import 'package:simbo_mobile/widgets/navigator_key.dart';

import 'di/service_locator.dart';

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHandler().initializeDB();
  HttpOverrides.global = DevHttpOverrides();
  setup();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        '/': (context)=> SplashScreen(),
        '/loginpage': (context)=> LoginPage(),
        '/home': (context)=> HomePage(),
        '/listerecensement': (context)=> ListeRecensementPage(),
        '/collecte': (context)=> CollectePage(),
        '/transfert': (context)=> TransfertDonnees(),

      },
      title: 'Simbo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Defaults.primaryBleuColor,
      ),
     initialRoute: '/',
    );
  }
}



