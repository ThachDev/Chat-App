import 'package:get/get.dart';

import '../../common/entities/user.dart';

class ContactState {
    var count = 0.obs;
    //--- Tạo danh sách
    RxList<UserData> contactList = <UserData>[].obs;

}