import 'package:chatapp/pages/message/photoview/controller.dart';
import 'package:get/get.dart';

class PhotoImageViewBinding implements Bindings{
  @override
  void dependencies(){
    //--- Get.lazyPut tối ưu hóa việc sử dụng tài nguyên khi cần mới cung cấp
    Get.lazyPut<PhotoImageViewController>(() => PhotoImageViewController());
  }
}