import 'package:chatapp/pages/contact/index.dart';
import 'package:chatapp/pages/message/view.dart';
import 'package:chatapp/pages/profile/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/values/colors.dart';
import 'controller.dart';


class ApplicationPage extends GetView<ApplicationController> {
  const ApplicationPage({Key? key}): super (key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildPageView(){
      return PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        onPageChanged: controller.handPageChanged,
        children: const [
          MessagePage(),
          ContactPage(),
          ProfilePage(),
        ],
      );
    }
    Widget _buildBottomNavigationBar(){
      return Obx(
          () => BottomNavigationBar(
            items: controller.bottomTabs,
            currentIndex: controller.state.page,
            type: BottomNavigationBarType.fixed,
            onTap: controller.handleNavBarTap,
            showSelectedLabels: true,
            unselectedItemColor: AppColors.tabBarElement,
            selectedItemColor: AppColors.thirdElementText,
          )
      );
    }
    return Scaffold(
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      );
  }
}
