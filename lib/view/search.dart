import 'package:flutter/material.dart';
import 'package:player/view/search_result.dart';

import '../model/music.dart';
import '../tools/audio_player.dart';
import '../tools/music_data.dart';
import '../tools/mysql.dart';
import '../widgets/music_item.dart';

class SearchPage extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<SearchPage> {
  late List<MusicModel> _data = MusicDataUtil.getMusicData();
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  var results;

  @override
  bool get wantKeepAlive => true;

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
        });
  }

  bool _isInputFocused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        title: TextField(
          controller: _textEditingController,
          focusNode: _focusNode,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: '请输入搜索内容',
            prefixIcon: IconButton(
              icon: Icon(Icons.search),
              color: Colors.blue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(target: _textEditingController.text.toString()),
                  ),
                );
                _focusNode.unfocus();
              },
            ),
            suffixIcon: _textEditingController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.cancel),
                    color: Colors.grey,
                    onPressed: () {
                      setState(() {
                        _textEditingController.clear();
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.only(bottom: 60),
        itemCount: _data.length,
        itemBuilder: (ctx, index) => MusicItem(
          model: _data[index],
          callback: (type) {
            itemCallback(_data[index], type);
          },
        ),
        separatorBuilder: (ctx, index) => const Divider(
          height: 0.0,
        ),
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
