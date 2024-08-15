import 'package:chatapp/common/routes/names.dart';
import 'package:chatapp/pages/welcome/state.dart';
import 'package:get/get.dart';

import '../../common/store/config.dart';
class WelcomeController extends GetxController{
  final state = WelcomeState();
  WelcomeController();
  changePage(int index) async{
    state.index.value = index;
  }

  handleSignIn() async{
    //--- Kiểm tra xem người dùng có dùng lần đầu tiên hay không
    await ConfigStore.to.saveAlreadyOpen();
    Get.offAndToNamed(AppRoutes.SIGN_IN);
  }
}