import 'package:flutter/material.dart';
import 'package:player/tools/dataUtils.dart';
import 'package:player/view/login_register.dart';

import 'music_list.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _userState createState() => _userState();
}

class _userState extends State<UserPage> {
  bool loginState = false;
  var textInfo;

  @override
  void initState() {
    loginState = DataUtils.get('login') ?? false;
    super.initState();
  }

  Future<void> _askedToLoad() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('确认退出?', style: TextStyle(fontSize: 17.0)),
          actions: <Widget>[
            TextButton(
              child: new Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: new Text('确定'),
              onPressed: () {
                setState(
                  () {
                    DataUtils.remove('login');
                    loginState = DataUtils.get('login') ?? false;
                    Navigator.of(context).pop();
                  },
                );
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = Theme.of(context).brightness;
    Color mainColor = Theme.of(context).primaryColor;
    Color head =
        currentBrightness == Brightness.light ? Colors.black : Colors.white;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '我的',
          style: TextStyle(color: head),
        ),
        //backgroundColor: Color(0x00000000),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
                flex: 4,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.925,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [mainColor, mainColor],
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.09,
                        backgroundImage: NetworkImage(
                            'https://desk-fd.zol-img.com.cn/t_s960x600c5/g5/M00/02/0A/ChMkJlbKz2GIGH8DAAO3mI6kKy4AALJUgLc1CMAA7ew789.jpg'),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Expanded(
                        flex: 3,
                        child: loginState
                            ? Text(
                                '${DataUtils.get('name')}\n\n${DataUtils.get('email')}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              )
                            : InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                },
                                child: Text(
                                  '请登录或注册',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    _askedToLoad();
                                  },
                                  icon: Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                )),
            Expanded(
              flex: 10,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.925,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    //Divider(),
                    ListTile(
                      leading: Icon(Icons.phone_android),
                      title: Text('本地音乐'),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () {
                        setState(() {
                          //addSource("https://freepd.com/music/Beat%20Thee.mp3".toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MusicPage()),
                          );
                        });
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.favorite),
                      title: Text('我的收藏'),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
