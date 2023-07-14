/// Created by RongCheng on 2022/3/2.

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../model/music.dart';
import '../tools/audio_player.dart';

class MusicItemPreview extends StatelessWidget {
  const MusicItemPreview({
    Key? key,
    required this.model,
    required this.callback,
    required bool downloading,
  })  : isDownloading = downloading,
        super(key: key);

  final MusicModel model;
  final Function(int) callback;
  final bool isDownloading;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> callback(0),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
          height: 80,
          child: Row(
            children: [
              Image.network(model.thumbnail,width: 64,height: 64,fit: BoxFit.fitWidth,),
              const SizedBox(width: 10,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.name,style: const TextStyle(color: Colors.black87,fontSize: 17),),
                    Text(model.author,style: const TextStyle(color: Colors.black45,fontSize: 14)),
                  ],
                ),
              ),
              InkWell(
                onTap: () => callback(1),
                child: isDownloading
                    ? CircularProgressIndicator()  // 下载按钮的加载动画
                    : Icon(Icons.download, size: 22, color: Colors.blue),  // 正常的下载图标
              ),
              SizedBox(width: 5,),
              InkWell(
                onTap: ()=> callback(2),
                child: (AudioPlayerUtil.state == PlayerState.playing) && (AudioPlayerUtil.musicModel?.url == model.url) ?
                const Icon(Icons.pause_circle,size: 22,color: Colors.blue) :
                const Icon(Icons.play_circle,size: 22,color: Colors.blue,),
              ),
            ],
          )
      ),
    );
  }
}

