
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import 'package:player/tools/dataUtils.dart';
import 'package:player/tools/mysql.dart';
import 'package:player/view/home.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {

  void postRequestFunction(String email, String password,BuildContext context) async{
    Dio dio = Dio();
    Map<String, String> map = Map();
    map['email'] = email;
    map['password'] = password;
    Response response = await dio.post("http://121.41.1.169:8080/user/login",data: map);
    String res = response.data.toString();
    if(res == 'success'){
      setState(() async {
        DataUtils.putBool('login', true);
        DataUtils.putString('email', email);
        mysql.Results results = await MySQLUtils.database('select * from user where email = \'${email}\'');
        for (var row in results) {
          DataUtils.putString('name', row[1]);
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      });
    }else{
      Fluttertoast.showToast(msg: '登录失败');
    }
    dio.close();
    print(res);
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
        //backgroundColor: Colors.transparent, // 将AppBar的背景颜色设置为透明
        elevation: 0,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: '用户名'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(labelText: '密码'),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    postRequestFunction(emailController.text, passwordController.text,context);
                  });

                },
                child: Text('登录'),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  // 跳转到注册页面
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text('没有账号？注册新账号'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController surePasswordController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  void postRegisterRequestFunction(String email, String password, String name, String code, BuildContext context) async{
    Dio dio = Dio();
    Map<String, String> map = Map();
    map['email'] = email;
    map['name'] = name;
    map['password'] = password;
    map['code'] = code;
    Response response = await dio.post("http://121.41.1.169:8080/user/register",data: map);
    String res = response.data.toString();
    if(res == 'success'){
      setState(() async {
        Fluttertoast.showToast(msg: '注册成功');
      });
    }else{
      Fluttertoast.showToast(msg: '注册失败');
    }
    print(res);
    dio.close();
  }

  void postSendRequestFunction(String email, String name) async{
    Dio dio = Dio();
    Map<String, String> map = Map();
    map["name"] = name;
    map["email"] = email;

    Response response = await dio.post("http://121.41.1.169:8080/user/send",data: map);
    String res = response.data.toString();
    if(res == '验证码发送成功'){
      setState(() {
        Fluttertoast.showToast(msg: '验证码发送成功');
      });
    }else{
      Fluttertoast.showToast(msg: '验证码发送失败');
    }
    print(res);
    dio.close();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: '昵称'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: '邮箱'),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: codeController,
                      decoration: InputDecoration(labelText: '验证码'),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () async {
                      postSendRequestFunction(emailController.text,nameController.text);
                    },
                    child: Text('发送验证码'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: '密码'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: surePasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: '确认密码'),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  String Name = nameController.text;
                  String Email = emailController.text;
                  String Password = passwordController.text;
                  String surePassword = surePasswordController.text;
                  if(Password!=surePassword){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("错误"),
                          content: const Text("密码不相同"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("确认"),
                            ),
                          ],
                        );
                      },
                    );
                  }else{
                    postRegisterRequestFunction(emailController.text,passwordController.text,nameController.text,codeController.text,context);
                  }
                },
                child: Text('注册'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

