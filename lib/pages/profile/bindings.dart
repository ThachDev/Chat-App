import 'package:get/get.dart';

import 'controller.dart';

class ProfileBinding implements Bindings{
  @override
  void dependencies(){
    //--- Được khởi tạo khi nó thực sự được sử dụng, không phải khi ứng dụng khởi động.
    Get.lazyPut <ProfileController>(() => ProfileController());
  }
}