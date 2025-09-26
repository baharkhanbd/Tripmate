import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tripmate/controller/auth/login_proivder.dart';
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
            
              ChangeNotifierProvider(create: (_) => ScanProvider())
            
            ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.white,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black, // AppBar text/icon color
                elevation: 0,
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.black),
                bodyMedium: TextStyle(color: Colors.black),
                bodySmall: TextStyle(color: Colors.black54),
              ),
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            home: const LoginPage(),
          ),
        );
      },
    );
  }
}
