# 💬 ChatApp – Ứng dụng Chat Thời Gian Thực

ChatApp là một **ứng dụng chat thời gian thực** được xây dựng bằng **Flutter** và **Firebase**.  
Người dùng có thể **đăng ký, đăng nhập, nhắn tin, gửi hình ảnh, trạng thái online/offline** và nhận **thông báo đẩy** ngay lập tức.  
Ứng dụng phù hợp cho cá nhân hoặc nhóm muốn xây dựng một **chat app hiện đại, nhanh và bảo mật**.

---

## 🚀 Tính năng nổi bật

- 🔐 **Xác thực người dùng** bằng **Firebase Auth** (Email & Google Sign-In)
- 💬 **Nhắn tin thời gian thực** với **Cloud Firestore**
- 📸 **Gửi ảnh** trực tiếp trong cuộc trò chuyện
- 🟢 **Hiển thị trạng thái online/offline** của người dùng
- 🛎 **Thông báo đẩy (Push Notification)** khi có tin nhắn mới
---

## 🛠 Công nghệ sử dụng

- **Flutter** + **Dart**
- **Firebase Authentication** → Đăng ký, đăng nhập và bảo mật tài khoản
- **Cloud Firestore** → Lưu trữ tin nhắn và thông tin người dùng theo thời gian thực
- **Firebase Storage** → Lưu trữ hình ảnh
- **Firebase Cloud Messaging (FCM)** → Push Notifications
- **Provider / GetX / Riverpod** → Quản lý trạng thái *(tùy chọn)*
- **MVC Architecture** → Tách biệt **Model – View – Controller** để dễ bảo trì

---

## 📂 Cấu trúc thư mục

```bash
lib/
├── models/          # Khai báo các model dữ liệu (User, Message, ChatRoom)
├── views/           # UI (màn hình đăng nhập, chat, profile, settings, etc.)
├── controllers/     # Xử lý logic, kết nối Firebase, quản lý trạng thái
├── services/        # Firebase, Push Notifications, Upload ảnh
├── utils/           # Hàm tiện ích, constants, theme, validator
└── widgets/         # Các widget tái sử dụng (ChatBubble, Avatar, InputField, etc.)
```
---
⚙️ Hướng dẫn cài đặt
1. Clone dự án
```bash
git clone https://github.com/your-username/chatify.git
```

2. Di chuyển vào thư mục dự án
```bash
cd chatify
```

3. Cài đặt dependencies
```bash
flutter pub get
```
4. Chạy dự án 
```bash
flutter run
```
---
📌 Lộ trình phát triển

 Đăng nhập, đăng ký

 Nhắn tin realtime

 Gửi ảnh & avatar

 Push Notifications

 Gọi thoại & video call (sắp ra mắt)

 Mã hóa đầu cuối (E2EE)
