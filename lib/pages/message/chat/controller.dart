import 'dart:io';
import 'package:chatapp/common/entities/entities.dart';
import 'package:chatapp/common/store/store.dart';
import 'package:chatapp/common/utils/security.dart';
import 'package:chatapp/pages/message/chat/index.dart';
import 'package:chatapp/pages/message/chat/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;



class ChatController extends GetxController{
  ChatController();
  ChatState state = ChatState();
  var doc_id = null;
  // Tquản lý nội dung của trường văn bản.
  final textController = TextEditingController();
  // quản lý cuộn nội dung trong một danh sách hoặc widget.
  ScrollController msgScrolling = ScrollController();

  // theo dõi trạng thái của trường văn bản (có đang được chú ý hay không).
  FocusNode contentNode = FocusNode();
  // Lấy mã token của người dùng từ một (store) gọi là UserStore.
  final user_id = UserStore.to.token;
  // Tạo một đối tượng Firestore instance để tương tác với cơ sở dữ liệu Firestore của Firebase.
  final db = FirebaseFirestore.instance;
  var listener;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      _photo = File( pickedFile.path);
      uploadFile();
    }
    else{
      print("No image selected");
    }
  }

  Future getImgUrl(String name) async {
    final spaceRef = FirebaseStorage.instance.ref("chat").child(name);
    var str = await spaceRef.getDownloadURL();
    return str??"";
  }

  sendImageMessage(String url) async {
    final content = Msgcontent(
      uid: user_id,
      content: url,
      type: "image",
      addtime: Timestamp.now()
    );
    // Thêm nội dung tin nhắn vào bộ sưu tập "msglist" dưới ID tài liệu đã chỉ định
    await db.collection("message").doc(doc_id).collection("msglist").withConverter(
        fromFirestore: Msgcontent.fromFirestore,
        toFirestore: (Msgcontent msgcontent, options) => msgcontent.toFirestore())
        .add(content).then((DocumentReference doc) {
      print("Document snapshot added with id, ${doc.id}");

      // Xóa nội dung trường nhập văn bản sau khi gửi tin nhắn
      textController.clear();

      // Mất focus khỏi trường nhập văn bản (tắt bàn phím)
      Get.focusScope?.unfocus();
    });
    await db.collection("message").doc(doc_id).update({
      "last_msg": "[image]",
      "last_time": Timestamp.now(),
    }
    );
  }

  Future uploadFile() async {
    // Kiểm tra xem tệp tin hình ảnh (_photo) có tồn tại không
    if (_photo == null) return;

    // Tạo một tên tệp ngẫu nhiên để lưu trữ trên Firebase Storage
    final fileName = getRandomString(15) + path.extension(_photo!.path);

    try {
      // Tạo một tham chiếu đến đường dẫn trên Firebase Storage
      final ref = FirebaseStorage.instance.ref("chat").child(fileName);

      // Bắt đầu quá trình tải lên tệp tin và lắng nghe các sự kiện của nó
      await ref.putFile(_photo!).snapshotEvents.listen((event) async {
        switch (event.state) {
          case TaskState.running:
            break;
          case TaskState.paused:
            break;
          case TaskState.success:
          // Tải lên thành công, lấy URL của tệp tin đã tải lên
            String imgUrl = await getImgUrl(fileName);
            // Gửi tin nhắn hình ảnh với URL
            sendImageMessage(imgUrl);
            break;
          case TaskState.canceled:
            break;
          case TaskState.error:
            break;
        }
      });
    } catch (e) {
      // Xử lý nếu có lỗi xảy ra trong quá trình tải lên
      print("There's an error $e");
    }
  }



  @override
  void onInit(){
    super.onInit();
    print("Debug: Initial msgcontentList: ${state.msgcontentList}");
    var data = Get.parameters;
    doc_id = data['doc_id'];
    // ??:Nếu null thì hãy chuyển sang rỗng ""
    state.to_uid.value = data['to_uid']??"";
    state.to_name.value = data['to_name']??"";
    state.to_avatar.value = data['to_avatar']??"";
  }

  sendMessage() async {
    String sendContent = textController.text;
    final content = Msgcontent(
      uid: user_id,
      content: sendContent,
      type: "text",
      addtime: Timestamp.now(),
    );
    // Thêm nội dung tin nhắn vào bộ sưu tập "msglist" dưới ID tài liệu đã chỉ định
    await db.collection("message").doc(doc_id).collection("msglist").withConverter(
        fromFirestore: Msgcontent.fromFirestore,
        toFirestore: (Msgcontent msgcontent, options) => msgcontent.toFirestore())
        .add(content).then((DocumentReference doc) {
          print("Document snapshot added with id, ${doc.id}");

          // Xóa nội dung trường nhập văn bản sau khi gửi tin nhắn
          textController.clear();

          // Mất focus khỏi trường nhập văn bản (tắt bàn phím)
          Get.focusScope?.unfocus();
    });
    await db.collection("message").doc(doc_id).update({
      "last_msg": sendContent,
      "last_time": Timestamp.now(),
    }
    );
  }

  @override
  void onReady(){
    super.onReady();
   var messages = db.collection("message").doc(doc_id).collection("msglist")
    .withConverter(
        fromFirestore: Msgcontent.fromFirestore,
        toFirestore: (Msgcontent msgcontent, options) =>msgcontent.toFirestore()
    ).orderBy("addtime", descending: false);
   // Xóa toàn bộ nội dung trong danh sách msgcontentList để bắt đầu cập nhật.
    state.msgcontentList.clear();
    listener = messages.snapshots().listen((event) {
     // Vòng lặp duyệt qua mỗi sự kiện thay đổi trong tập hợp sự kiện.
     for(var change in event.docChanges){
       switch(change.type){
         case DocumentChangeType.added:
         // Nếu sự kiện là thêm mới, thêm dữ liệu của tài liệu vào đầu danh sách msgcontentList.
           if(change.doc.data() != null){
             state.msgcontentList.insert(0, change.doc.data()!);
           }
           break;
         case DocumentChangeType.modified:
           break;
         case DocumentChangeType.removed:
           break;
       }
     }
   },
     onError: (error) =>print ( "Listen failed: $error")
   );
    getLocation();
  }
  getLocation() async {
    try{
      var  user_location = await db.collection("users").where("id", isEqualTo: state.to_uid.value).withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userdata, options) => userdata.toFirestore()).get();
      var location = user_location.docs.first.data().location;
      if(location!=""){
        state.to_location.value = location?? "unknown";
      }
    }catch(e){
      print(("We have error $e"));
    }
  }

  @override
  void dispose(){
    msgScrolling.dispose();
    listener.cancel();
    super.dispose();
  }
}