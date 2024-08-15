import 'package:chatapp/pages/contact/controller.dart';
import 'package:chatapp/pages/application/controller.dart';
import 'package:get/get.dart';
import '../message/controller.dart';
import '../profile/controller.dart';
class ApplicationBinding implements Bindings{
  @override
  void dependencies(){
    //--- Được khởi tạo khi nó thực sự được sử dụng, không phải khi ứng dụng khởi động.
    Get.lazyPut <ApplicationController>(() => ApplicationController());
    Get.lazyPut <ContactController>(() => ContactController());
    Get.lazyPut <MessageController>(() => MessageController());
    Get.lazyPut <ProfileController>(() => ProfileController());
  }
}