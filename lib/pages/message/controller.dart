import 'package:chatapp/common/entities/entities.dart';
import 'package:chatapp/common/store/store.dart';
import 'package:chatapp/common/utils/http.dart';
import 'package:chatapp/pages/message/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:location/location.dart';
import '../../common/entities/msg.dart';


class MessageController extends GetxController{
  MessageController();
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final MessageState state  = MessageState();
  var listener;

  //--- Dùng để hiển thị dữ liệu mới ngay từ khi ứng dụng
  final RefreshController refreshController = RefreshController(
      initialRefresh: true
      );
  @override
  void onReady(){
    super.onReady();
    getUserLocation();
    getFcmToken();
  }

  // Hàm được gọi khi người dùng kéo xuống để làm mới dữ liệu
  void onRefresh(){
    asyncLoadAllData().then((_){
      refreshController.refreshCompleted(resetFooterState: true);
    }).catchError((_){
      refreshController.refreshFailed();
    });
  }
  // Hàm được gọi khi người dùng kéo lên để tải thêm dữ liệu
  void onLoading(){
    asyncLoadAllData().then((_){
      refreshController.loadComplete();
    }).catchError((_){
      refreshController.loadFailed();
    });
  }
  // Hàm thực hiện việc tải dữ liệu bất đồng bộ từ cơ sở dữ liệu
  asyncLoadAllData() async {
   var from_message = await db.collection("message").withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) => msg.toFirestore()).where(
      "from_uid", isEqualTo: token
    ).get();

   var to_message = await db.collection("message").withConverter(
       fromFirestore: Msg.fromFirestore,
       toFirestore: (Msg msg, options) => msg.toFirestore()).where(
       "to_uid", isEqualTo: token
   ).get();
   state.msgList.clear();
   // Nếu có tin nhắn từ "from_uid", thêm vào danh sách tin nhắn
   if(from_message.docs.isNotEmpty){
     state.msgList.assignAll(from_message.docs);
   }
   // Nếu có tin nhắn từ "to_uid", thêm vào danh sách tin nhắn
   if(to_message.docs.isNotEmpty){
     state.msgList.assignAll(to_message.docs);
   }

  }

  getUserLocation() async {
    try{
      final location = await Location().getLocation();
      String address = "${location.latitude}, ${location.longitude}";
      String url = "https://maps.googleapis.com/maps/api/geocode/json?address=${address}&key=AIzaSyBIfBeX_4NSVSF4pGqeK1gWnxc_TLP3oLQ";
      var response = await HttpUtil().get(url);
      MyLocation location_res = MyLocation.fromJson(response);
      if(location_res.status == "OK"){
        String? myaddress = location_res.results?.first.formattedAddress;
        if(myaddress !=null){
          var user_location = await db.collection("users").where("id", isEqualTo: token).get();
          if(user_location.docs.isNotEmpty){
            var doc_id = user_location.docs.first.id;
            await db.collection("users").doc(doc_id).update({"location":myaddress});
          }
        }
      }
    }catch(e){
      print("Getting error $e");
    }
  }

  getFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if(fcmToken != null){
      var user = await db.collection("users").where("id", isEqualTo: token).get();
      if(user.docs.isNotEmpty){
        var doc_id = user.docs.first.id;
        await db.collection("users").doc(doc_id).update({"fcmtoken": fcmToken});}
    }
  }
}