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

  Column _buildProfile(
          BuildContext context, String user, String phone, String loc) =>
      Column(
        children: [
          _avatar(context),
          _userName(context, user),
          _userCom(context, phone),
          _userLoc(context, loc),
          _userStared(context),
        ],
      );

  Padding _avatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Center(
        child: CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primary,
          child: Text(
            "S",
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
    );
  }

  Padding _userName(BuildContext context, String user) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: Text(
          user,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
        ),
      ),
    );
  }

  Padding _userCom(BuildContext context, String phone) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: Text(
          phone,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).disabledColor,
              ),
        ),
      ),
    );
  }

  Padding _userLoc(BuildContext context, String loc) {
    return Padding(
      padding: const EdgeInsets.only(left: 125.0),
      child: Row(
        children: [
          Expanded(
            child: Row(children: [
              const Padding(
                  padding: EdgeInsets.only(top: 15, left: 15),
                  child: Icon(Icons.location_city_rounded,
                      color: AppColors.primary, size: 30)),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 15),
                child: Text(loc,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 18,
                          color: AppColors.disable,
                        )),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Row _userStared(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(children: [
            const Padding(
                padding: EdgeInsets.only(top: 15, left: 15),
                child: Icon(Icons.star, color: AppColors.primary, size: 30)),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15),
              child: Text("Favoriler",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 18,
                        color: AppColors.disable,
                      )),
            ),
          ]),
        ),
      ],
    );
  }
}
