import 'package:aya_flutter_v2/constants/colors.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildProfile(context, "Seda", "54558858809", "İstanbul"),
    );
  }

  Container _buildProfile(
          BuildContext context, String user, String num, String loc) =>
      Container(
        //profil kısmı
        height: 100,
        decoration: const BoxDecoration(
          color: AppColors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.person, color: AppColors.primary, size: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 18,
                            color: AppColors.disable,
                            fontWeight: FontWeight.bold,
                          )),
                  Row(
                    children: [
                      const Icon(Icons.call,
                          color: AppColors.disable, size: 20),
                      Text(num,
                          textAlign: TextAlign.start,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 18,
                                    color: AppColors.disable,
                                  )),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: AppColors.disable, size: 20),
                      Text(loc,
                          textAlign: TextAlign.left,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 18,
                                    color: AppColors.disable,
                                  )),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings,
                    color: AppColors.disable, size: 40),
                padding: const EdgeInsets.only(bottom: 40),
              ),
            ],
          ),
        ),
      );
}
