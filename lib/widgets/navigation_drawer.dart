import 'package:flutter/material.dart';
import 'package:pa_flutter_t3/core/services/Api.dart';
import 'package:pa_flutter_t3/screens/add_post.dart';
import 'package:pa_flutter_t3/screens/auth/google_sign_in.dart';
import 'package:pa_flutter_t3/screens/auth/sign_in.dart';
import 'package:pa_flutter_t3/utils/appUtils.dart';

class NavigationDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;

  NavigationDrawer(this.userName, this.userEmail);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: ListView(
              children: <Widget>[
                // UserAccountsDrawerHeader(
                //   currentAccountPicture: CircleAvatar(
                //     child: Text(userName.substring(0, 1) ?? 'userName', style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 36.0,
                //       fontWeight: FontWeight.bold
                //     ),),
                //     backgroundColor: Colors.grey[700],
                //   ),
                //   otherAccountsPictures: <Widget>[
                //     CircleAvatar(
                //       child: Text(userName.substring(0, 1) ?? 'userName', style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 18.0,
                //     ),),
                //       backgroundColor: Colors.grey[700],
                //     ),
                //   ],
                //   accountEmail: Text(userEmail ?? 'userEmail'),
                //   accountName: Text(userName ?? 'userName'),
                //   decoration: BoxDecoration(color: Colors.white),
                // ),
                DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      maxRadius: 32.0,
                      child: Text(
                        userName.substring(0, 1) ?? 'userName',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.grey[700],
                    ),
                    SizedBox(height: 8.0,),
                    Text(userName, style: TextStyle(
                      fontSize: 22.0
                    ),)
                  ],
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 80.0,
                      height: 75.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '50',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'POSTS',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    Container(
                      width: 80.0,
                      height: 75.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '10',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'SHARES',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    Container(
                      width: 90.0,
                      height: 75.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '1000',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'VIEWS',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(6)),
                    )
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                ListTile(
                  title: Text('About Me'),
                  subtitle: Text(
                      "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs."),
                )
              ],
            ),
          ),
          Expanded(
              flex: 2,
              child: ListView(
                children: <Widget>[
                  Container(
                    color: Colors.grey[700],
                    child: ListTile(
                      title: Text(
                        'Post your talk',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => AddPost(userName: userName,)));
                      },
                      trailing: Icon(
                        Icons.done,
                        size: 28.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Logout',
                    ),
                    trailing: Icon(
                      Icons.exit_to_app,
                      size: 28.0,
                    ),
                    onTap: () {
                      Api.auth.signOut();
                      signOutGoogle();
                      Navigator.of(context).pop();
                      navigateClearStack(context, SignIn());
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
