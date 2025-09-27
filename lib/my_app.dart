import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripmate/controller/auth/login_proivder.dart';
import 'package:tripmate/controller/history/history_provder.dart';
import 'package:tripmate/controller/scan/scan_provider.dart';
import 'package:tripmate/view/auth/login_page.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            
            ChangeNotifierProvider(create: (_) => LoginProvider()),
            
              ChangeNotifierProvider(create: (_) => ScanProvider()),
               ChangeNotifierProvider(create: (_) => HistoryProvder())
            
            ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
          title: 'TripMate',
          
        
          theme: ThemeData(
            textTheme: GoogleFonts.interTextTheme(),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
            home: const LoginPage(),
          ),
        );
      },
    );
  }
}
