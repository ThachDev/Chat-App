import 'package:chatapp/common/routes/pages.dart';
import 'package:chatapp/common/services/services.dart';
import 'package:chatapp/common/store/config.dart';
import 'package:chatapp/common/store/store.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync<StorageService>(()  => StorageService().init());
  Get.put<ConfigStore>(ConfigStore());
  Get.put<UserStore>(UserStore());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //--- Tự đồng điều chỉnh độ phân giải của màn hình
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) =>GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue
        ),
        // initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        //home: Center(child: Container(child: Text("Project started"),),)
      ),
    );
  }
}
