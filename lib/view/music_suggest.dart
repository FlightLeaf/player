import 'package:flutter/material.dart';
import 'package:player/tools/dataUtils.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import 'package:player/tools/mysql.dart';
import 'package:player/view/search.dart';
import 'package:player/widgets/music_card.dart';

import '../model/music.dart';
import '../tools/audio_player.dart';
import '../tools/music_data.dart';

class MusicPage extends StatefulWidget {
  @override
  _musicState createState() => _musicState();
}

class _musicState extends State<MusicPage> {
  late List<MusicModel> _data = MusicDataUtil.getMusicData();

  bool get wantKeepAlive => true;
  var results;

  @override
  void initState() {
    setState(() {
      fetchDataFromMySQL();
    });
    super.initState();
    AudioPlayerUtil.statusListener(
      key: this,
      listener: (sate) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Future<void> fetchDataFromMySQL() async {
    results = await MySQLUtils.database(
        "SELECT * FROM music ORDER BY RAND() LIMIT 10");
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
      _data = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = Theme.of(context).brightness;
    Color head =
        currentBrightness == Brightness.light ? Colors.black : Colors.white;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            '悦音-推荐',
            style: TextStyle(color: head),
          ),
          //backgroundColor: Color(0x00000000),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: head,
              ),
              tooltip: '搜索',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: (() async {
            setState(() {
              fetchDataFromMySQL();
            });
          }),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GridView.count(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void itemCallback(MusicModel model, int type) {
    if (mounted) {
      setState(() {});
    }
    if (type == 0) {
      /*Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>  musicDetail(),
      ));*/
    } else {
      AudioPlayerUtil.listPlayerHandle(musicModels: _data, musicModel: model);
    }
  }
}
