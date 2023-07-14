import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:player/tools/mysql.dart';
import 'package:record/record.dart';
import 'package:mysql1/mysql1.dart' as mysql;

import '../tools/permission_manager.dart';
import '../model/music.dart';
import '../tools/audio_player.dart';
import '../widgets/music_card.dart';

class IdentifyPage extends StatefulWidget {
  const IdentifyPage({super.key});

  @override
  _IdentifyPageState createState() => _IdentifyPageState();
}

class _IdentifyPageState extends State<IdentifyPage>
    with SingleTickerProviderStateMixin {
  var path;
  final record = Record();
  bool isRecording = false;

  //late MusicModel musicModel;
  List<MusicModel> _data = [];

  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  bool isRecordingStarted = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(_animationController);
    AudioPlayerUtil.statusListener(
      key: this,
      listener: (sate) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> recordMusic() async {
    bool per = await PermissionUtils.requestStoragePermission();
    if (await record.hasPermission() && per == true) {
      Directory? tempDir = await getExternalStorageDirectory();
      String? dirloc = tempDir?.path;
      var name = "temp";
      path = "${dirloc!}$name.wav";
      setState(() {
        isRecordingStarted = true;
      });
      await record.start(
        path: path.toString(),
        encoder: AudioEncoder.wav,
        bitRate: 128000,
        samplingRate: 44100,
      );
      isRecording = await record.isRecording();
      setState(
        () {
          print(path);
          const timeout = const Duration(seconds: 20);
          print('currentTime=${DateTime.now()}');
          Timer(
            timeout,
            () async {
              await record.stop();
              Dio dio = Dio();
              FormData formData = FormData.fromMap(
                {
                  "file": await MultipartFile.fromFile(path.toString(),
                      filename: 'filestemp.wav')
                },
              );
              Response response = await dio
                  .post('http://121.41.1.169:8067/upload', data: formData);
              if (response.statusCode == 200) {
                print(response.data);
                mysql.Results results = await MySQLUtils.database(
                    "select * from music where name = '${response.data}'");
                for (var row in results) {
                  MusicModel musicModel = MusicModel(
                      id: row[0].toString(),
                      name: row[1].toString(),
                      url: row[2].toString(),
                      author: row[3].toString(),
                      thumbnail: row[5].toString());
                  setState(() {
                    _data.add(musicModel);
                    print(_data);
                  });
                }
              } else {
                print("-------------" "失败！");
              }
              setState(
                () {
                  isRecordingStarted = false;
                  print("录音完毕");
                  isRecording = false;
                  dio.close();
                },
              );
              print('afterTimer=${DateTime.now()}');
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '听音识曲',
          style: TextStyle(color: Colors.blueAccent),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: Center(
                child: isRecording
                    ? Text(
                        "正在识别……",
                        style: TextStyle(fontSize: 24, color: Colors.grey[600]),
                      )
                    : Text(
                        "点击录音\n开始识别",
                        style: TextStyle(fontSize: 24, color: Colors.grey[600]),
                      ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    recordMusic();
                    if (_animationController.status ==
                        AnimationStatus.completed) {
                      _animationController.reverse();
                    } else {
                      _animationController.forward();
                    }
                  });
                },
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        color: _colorAnimation.value,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.mic,
                        size: 40,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: (_data.isEmpty)
                ? Container()
                : GridView.count(
                    padding: const EdgeInsets.only(bottom: 60),
                    crossAxisCount: 1,
                    children: List.generate(_data.length, (index) {
                      return MusicCard(
                        model: _data[index],
                        callback: (type) {
                          itemCallback(_data[index], type);
                        },
                      );
                    }),
                    mainAxisSpacing: 8,
                    // 卡片垂直间距
                    crossAxisSpacing: 8,
                    // 卡片水平间距
                    shrinkWrap: true,
                    // 让网格布局的高度适应内容
                    physics: NeverScrollableScrollPhysics(), // 禁用网格布局的滚动
                  ),
          ),
          Expanded(flex: 1, child: Container()),
        ],
      ),
    );
  }

  void itemCallback(MusicModel model, int type) {
    if (mounted) {
      setState(() {});
    }
    if (type == 0) {
    } else {
      AudioPlayerUtil.listPlayerHandle(musicModels: _data, musicModel: model);
    }
  }
}
