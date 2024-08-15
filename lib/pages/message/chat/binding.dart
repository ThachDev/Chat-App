import 'package:chatapp/pages/message/chat/controller.dart';
import 'package:get/get.dart';
class ChatBinding implements Bindings{
  @override
  void dependencies(){
    //--- Được khởi tạo khi nó thực sự được sử dụng, không phải khi ứng dụng khởi động.
    Get.lazyPut <ChatController>(() => ChatController());
  }
}