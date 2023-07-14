import 'package:flutter/material.dart';

import '../model/music.dart';
import '../tools/audio_player.dart';
import '../tools/music_data.dart';
import '../widgets/music_item.dart';


class MusicPage extends StatefulWidget {
  const MusicPage({Key? key}) : super(key: key);

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> with AutomaticKeepAliveClientMixin{

  late List<MusicModel> _data;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _data = MusicDataUtil.getMusicData();
    super.initState();

    AudioPlayerUtil.statusListener(key: this, listener: (sate){
      if(mounted){
        setState(() {});
      }
    });
  }
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("音乐列表"),),
      body: ListView.separated(
        padding: const EdgeInsets.only(bottom: 60),
        itemCount: _data.length,
        itemBuilder: (ctx,index) => MusicItem(model: _data[index],callback:(type){
          itemCallback(_data[index], type);
        },),
        separatorBuilder: (ctx,index) => const Divider(height: 0.0,),
      ),
    );
  }

  void itemCallback(MusicModel model,int type){
    if(mounted){
      setState(() {});
    }
    if(type == 0){
      /*Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>  musicDetail(),
      ));*/
    }else{
      AudioPlayerUtil.listPlayerHandle(musicModels: _data,musicModel: model);
    }
  }

  @override
  void dispose() {
    AudioPlayerUtil.removeStatusListener(this);
    super.dispose();
  }
}
