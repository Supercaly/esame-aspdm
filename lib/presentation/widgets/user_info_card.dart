import 'package:aspdm_project/core/maybe.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/application/states/auth_state.dart';
import 'package:aspdm_project/presentation/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<AuthState, Maybe<User>>(
      selector: (_, state) => state.currentUser,
      builder: (context, user, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              UserAvatar(
                size: 56.0,
                rectangle: true,
                user: user.getOrNull(),
              ),
              SizedBox(width: 24.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    user.getOrNull()?.name?.value?.getOrNull() ?? "",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    user.getOrNull()?.email?.value?.getOrNull() ?? "",
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
