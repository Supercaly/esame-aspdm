import 'package:aspdm_project/model/user.dart';
import 'package:aspdm_project/states/auth_state.dart';
import 'package:aspdm_project/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<AuthState, User>(
      selector: (_, state) => state.currentUser,
      builder: (context, user, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              UserAvatar(
                size: 56.0,
                rectangle: true,
                user: user,
              ),
              SizedBox(width: 24.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    user?.name ?? "",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    user?.email ?? "",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
