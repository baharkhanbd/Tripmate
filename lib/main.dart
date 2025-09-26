import 'package:flutter/material.dart';
import 'package:tripmate/config/shared_pref_helper.dart';
import 'package:tripmate/my_app.dart';

void main() async{ WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.init();
  runApp(const MyApp());
} 