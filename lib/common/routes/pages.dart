
import 'package:chatapp/common/middlewares/middlewares.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatapp/pages/sign_in/index.dart' as SignIn;
import 'package:chatapp/pages/welcome/index.dart' as Welcome;
import 'package:chatapp/pages/application/index.dart' as Application;
import 'package:chatapp/pages/contact/index.dart' as Contact;
import 'package:chatapp/pages/message/chat/index.dart' as Chat;
import 'package:chatapp/pages/message/photoview/index.dart' as Photo;
import 'package:chatapp/pages/profile/index.dart' as Profile;

import 'routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.INITIAL;
  static const APPlication = AppRoutes.Application;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static final List<GetPage> routes = [

    GetPage(
      name: AppRoutes.INITIAL,
      page: () => const Welcome.WelcomePage(),
      binding: Welcome.WelcomeBinding(),
      middlewares: [
        RouteWelcomeMiddleware(priority: 1)
      ],

    ),

    GetPage(
      name: AppRoutes.SIGN_IN,
      page: () => const SignIn.SignInPage(),
      binding: SignIn.SignInBinding(),
    ),

    // check if needed to login or not
    GetPage(
      name: AppRoutes.Application,
      page: () => const Application.ApplicationPage(),
      binding: Application.ApplicationBinding(),
      middlewares: [
      //  RouteAuthMiddleware(priority: 1),
      ],
    ),

    // 最新路由
    // 首页
    GetPage(name: AppRoutes.Contact,
        page: () => const Contact.ContactPage(),
        binding: Contact.ContactBinding()),

    GetPage(name: AppRoutes.Me,
        page: () => const Profile.ProfilePage(),
        binding: Profile.ProfileBinding()),

    /*
    GetPage(name: AppRoutes.Message, page: () => MessagePage(), binding: MessageBinding()),
    */

    GetPage(
        name: AppRoutes.Chat,
        page: () => const Chat.ChatPage(),
        binding: Chat.ChatBinding()),

    GetPage(name: AppRoutes.Photoimgview,
        page: () => const Photo.PhotoImgView(),
        binding: Photo.PhotoImageViewBinding()),
  ];






}
