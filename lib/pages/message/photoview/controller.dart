import 'package:chatapp/pages/message/photoview/state.dart';
import 'package:get/get.dart';


class PhotoImageViewController extends GetxController{
  final PhotoImageViewSate state = PhotoImageViewSate();

  @override
  void onInit(){
    super.onInit();
    var data = Get.parameters;
    if(data['url']!= null){
      state.url.value = data['url']!;
    }

  }
}