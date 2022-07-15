import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:chatapp/app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerScreen extends StatelessWidget {
  final authC = Get.find<AuthController>();

  DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 172, 230, 220),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              SizedBox(
                width: double.maxFinite,
                child: Center(
                  child: UserAccountsDrawerHeader(
                    accountName: Text(authC.user.value.name!),
                    accountEmail: Text(authC.user.value.email!),
                    currentAccountPicture:
                        authC.user.value.photoUrl! == 'noimage'
                            ? const CircleAvatar(
                                backgroundImage: AssetImage(
                                'assets/logo/noimage.png',
                              ))
                            : CircleAvatar(
                                backgroundImage:
                                    NetworkImage(authC.user.value.photoUrl!),
                              ),
                    decoration: BoxDecoration(
                      color: ColorApp.secondary,
                    ),
                  ),
                ),
              ),
              DrawerListTile(
                iconData: Icons.update,
                title: 'Update Status',
                onTilePressed: () {
                  Get.back();
                  Get.toNamed(Routes.UPDATE_STATUS);
                },
              ),
              DrawerListTile(
                iconData: Icons.account_circle,
                title: 'Change Profile',
                onTilePressed: () {
                  Get.back();
                  Get.toNamed(Routes.CHANGE_PROFILE);
                },
              ),
              DrawerListTile(
                iconData: Icons.contacts,
                title: 'New Contacts',
                onTilePressed: () {},
              ),
              DrawerListTile(
                iconData: Icons.bookmark_border,
                title: 'Saved Message',
                onTilePressed: () {},
              ),
            ],
          ),
          Expanded(child: SizedBox()),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.blue[700], padding: EdgeInsets.zero),
              onPressed: () => authC.logout(),
              child: const Center(child: Text('LOGOUT'))),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onTilePressed;

  const DrawerListTile(
      {Key? key,
      required this.iconData,
      required this.title,
      required this.onTilePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTilePressed,
      dense: true,
      leading: Icon(iconData),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
