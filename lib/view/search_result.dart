import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:player/model/music.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import 'package:player/tools/music_data.dart';
import 'package:player/tools/mysql.dart';

import '../tools/audio_player.dart';
import '../widgets/music_item_preview.dart';
import '../tools/permission_manager.dart';

class ResultPage extends StatefulWidget {
  final String target;
  const ResultPage({Key? key, required this.target})
      : super(
          key: key,
        );
  @override
  State<ResultPage> createState() => _ResultPageState(target: target);
}

class _ResultPageState extends State<ResultPage>
    with AutomaticKeepAliveClientMixin {
  late String target;

  _ResultPageState({required String target}) {
    this.target = target;
    print(target);
  }

  bool isLoading = true;
  late mysql.Results results;
  late List<MusicModel> res_data = MusicDataUtil.getMusicData();

  @override
  bool get wantKeepAlive => true;
  bool downloading = false;
  double progress = 0;
  var path;

  Future<void> downloadFile(MusicModel model) async {
    final Dio dio = Dio();
    bool per = await PermissionUtils.requestStoragePermission();
    if (per == true) {
      Directory? tempDir = await getExternalStorageDirectory();
      String? dirloc = tempDir?.path;
      var name = model.name;
      path = dirloc! + name.toString() + ".mp3";
      try {
        await dio.download(model.url, path,
            onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            downloading = true;
            progress = (receivedBytes / totalBytes);
          });
        });
        print('start');
      } catch (e) {
        print(e);
      }
      setState(() {
        downloading = false;
        progress = 0;
        path = dirloc! + name.toString() + ".mp3";
      });
    } else {
      setState(() {
        progress = 0;
      });
    }
  }

  Future<void> rand() async {
    results = await MySQLUtils.database(
        "SELECT * FROM music WHERE name LIKE '%${target}%'"
    );
  }

  @override
  void initState() {
    super.initState();
    rand().then((_) {
      setState(() {
        isLoading = false;
        final List<Map<String, String>> _json = [];
        for (final row in results) {
          final Map<String, String> map = {
            "id": row['id'].toString(),
            "name": row['name'].toString(),
            "author": row['author'].toString(),
            "thumbnail": row['thumbnail'].toString(),
            "url": row['url'].toString(),
          };
          _json.add(map);
        }
        List<MusicModel> list = [];
        for (Map<String, String> map in _json) {
          MusicModel model = MusicModel.fromMap(map);
          list.add(model);
        }
        setState(() {
          res_data = list;
        });
      });
    });
    AudioPlayerUtil.statusListener(
        key: this,
        listener: (sate) {
          if (mounted) {
            setState(() {});
          }
        });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // 加载完成后的界面内容
      return Scaffold(
        appBar: AppBar(
          title: const Text("音乐列表"),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.only(bottom: 60),
          itemCount: res_data.length,
          itemBuilder: (ctx, index) => MusicItemPreview(
            model: res_data[index],
            callback: (type) {
              itemCallback(res_data[index], type);
            },
            downloading: downloading,
          ),
          separatorBuilder: (ctx, index) => const Divider(
            height: 0.0,
          ),
        ),
      );
    }
  }

  void itemCallback(MusicModel model, int type) {
    if (mounted) {
      setState(() {});
    }
    if (type == 0) {
    } else if (type == 1) {
      PermissionUtils.requestStoragePermission();
      downloadFile(model);
    } else if (type == 2) {
      AudioPlayerUtil.listPlayerHandle(
          musicModels: res_data, musicModel: model);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
