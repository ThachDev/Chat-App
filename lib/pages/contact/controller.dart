import 'dart:convert';

import 'package:chatapp/common/entities/entities.dart';
import 'package:chatapp/common/store/store.dart';
import 'package:chatapp/pages/contact/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
class ContactController extends GetxController {
  ContactController();

  final ContactState state = ContactState();

  //---Tạo một biến để tương tác với db
  final db = FirebaseFirestore.instance;
  final token = UserStore.to.token;

  @override
  void onReady() {
    super.onReady();
    asyncLoadAllData();
  }

  //---Tạo một tệp trò chuyện trong firebase
  goChat(UserData to_userdata) async {
    // Lấy tất cả các tin nhắn từ người dùng hiện tại đến người dùng đích
    var from_messages = await db.collection("message").withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) => msg.toFirestore()).where(
        "from_uid", isEqualTo: token
    ).where(
        "to_uid", isEqualTo: to_userdata.id
    ).get();
    // Lấy tất cả các tin nhắn từ người dùng đích đến người dùng hiện tại và ngược lại
    var to_messages = await db.collection("message").withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) => msg.toFirestore()).where(
        "from_uid", isEqualTo: to_userdata.id
    ).where(
        "to_uid", isEqualTo: token
    ).get();

    //--- Kiểm tra xem hai người dùng đã trò chuyện hay chưa?
    if (from_messages.docs.isEmpty && to_messages.docs.isEmpty) {
      //---Lấy hồ sơ đã lưu
      String profile = await UserStore.to.getProfile();
      UserLoginResponseEntity userdata = UserLoginResponseEntity.fromJson(
          jsonDecode(profile));
      // Tạo một tin nhắn mới
      var msgdata = Msg(
        from_uid: userdata.accessToken,
        to_uid: to_userdata.id,
        from_name: userdata.displayName,
        to_name: to_userdata.name,
        from_avatar: userdata.photoUrl,
        to_avatar: to_userdata.photourl,
        last_msg: "",
        last_time: Timestamp.now(),
        //---Số lần nhắn tin
        msg_num: 0,
      );
      // Thêm tin nhắn mới vào Firestore
      db.collection("message").withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore()
      ).add(msgdata).then((value) {
        // Chuyển hướng đến trang chat và truyền thông tin cần thiết
        Get.toNamed("/chat", parameters: {
          "doc_id": value.id,
          "to_uid": to_userdata.id ?? "",
          "to_name": to_userdata.name ?? "",
          "to_avatar": to_userdata.photourl ?? ""
        });
      });
    } else {
      // Nếu đã có tin nhắn giữa hai người dùng, chuyển hướng đến trang chat
      if (from_messages.docs.isNotEmpty) {
        Get.toNamed("/chat", parameters: {
          "doc_id": from_messages.docs.first.id,
          "to_uid": to_userdata.id ?? "",
          "to_name": to_userdata.name ?? "",
          "to_avatar": to_userdata.photourl ?? ""
        });
      }
      if (to_messages.docs.isNotEmpty) {
        Get.toNamed("/chat", parameters: {
          "doc_id": to_messages.docs.first.id,
          "to_uid": to_userdata.id ?? "",
          "to_name": to_userdata.name ?? "",
          "to_avatar": to_userdata.photourl ?? ""
        });
      }
    }
  }
    asyncLoadAllData() async {
      var usersbase = await db.collection("users").where(
          "id", isNotEqualTo: token).withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userdata, options) => userdata.toFirestore()
      ).get();

      //--- Lưu vào danh sách để có thể liên lạc
      for (var doc in usersbase.docs) {
        state.contactList.add(doc.data());
      }
    }
  }

