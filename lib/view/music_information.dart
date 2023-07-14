import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui show window;

import '../model/music.dart';
import '../tools/audio_player.dart';
import '../widgets/audio_slider.dart';

class musicDetail extends StatefulWidget {
  musicDetail({Key? key}) : super(key: key);
  @override
  State<musicDetail> createState() => DetailPage();
}

class DetailPage extends State<musicDetail>  {
  DetailPage({Key? key});
  late MusicModel musicModel = AudioPlayerUtil.musicModel!;
  var name = "Happy!";
  var author = "Everyday";
  @override
  void initState() {
    super.initState();
    AudioPlayerUtil.statusListener(key: this, listener: (sate){
      if(mounted){
        setState(() {
          musicModel = AudioPlayerUtil.musicModel!;
          name = AudioPlayerUtil.musicModel!.name.toString();
          author = AudioPlayerUtil.musicModel!.author.toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQueryData.fromWindow(ui.window).size;
    return Scaffold(
      appBar: AppBar(title: Text(musicModel.name),),
      body: Center(
        child: Column(
          children: [
            Container(
              width: size.width*0.6,
              height: size.width*0.6,
              margin: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                border: Border.all(width: 10,color: Colors.white),
                borderRadius: BorderRadius.circular(size.width*0.3),
                boxShadow: const [BoxShadow(color: Color(0xffdddddd),offset: Offset(0.0,2.0),blurRadius: 10.0,spreadRadius: 0.0)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size.width*0.3),
                child: Image.network(musicModel.thumbnail,width: size.width*0.6,height: size.width*0.6,fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 40,),
            AudioButton(musicModel: musicModel),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
              child: AudioSlider(),
            ),
          ],
        ),
      ),
    );
  }
}

class AudioButton extends StatefulWidget {
  const AudioButton({Key? key,required this.musicModel}) : super(key: key);
  final MusicModel musicModel;
  @override
  State<AudioButton> createState() => _AudioButtonState();
}

class _AudioButtonState extends State<AudioButton> {

  bool _playing = false;

  @override
  void initState() {
    if ((AudioPlayerUtil.state == PlayerState.playing) &&
        (AudioPlayerUtil.musicModel != null) &&
        (AudioPlayerUtil.musicModel!.url == widget.musicModel.url)) {
      _playing = true;
    }
    super.initState();

    // 监听播放状态
    AudioPlayerUtil.statusListener(key: this, listener: (state) {
      if ((AudioPlayerUtil.musicModel != null) &&
          (AudioPlayerUtil.musicModel!.url == widget.musicModel.url)) { // 为当前资源
        if (mounted) {
          setState(() {
            _playing = state == PlayerState.playing;
          });
        }
      } else { // 不是当前资源，若当前正在播放，则暂停
        if (_playing == true) {
          if (mounted) {
            setState(() {
              _playing == false;
            });
          }
        }
      }
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            Icons.skip_previous_rounded,
            size: 40,
            color: Colors.blue,
          ),
          onPressed: () {
            setState(() {
              AudioPlayerUtil.previousMusic();
            });
          },
        ),
        InkWell(
          onTap: () => AudioPlayerUtil.playerHandle(model: widget.musicModel),
          child: Icon(
            _playing ? Icons.pause_circle_rounded : Icons.play_circle_rounded,
            size: 60,
            color: Colors.blue,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.skip_next_rounded,
            size: 40,
            color: Colors.blue,
          ),
          onPressed: () {
            setState(() {
              AudioPlayerUtil.nextMusic();
            });
          },
        ),
      ],
    );
  }


  @override
  void dispose() {
    AudioPlayerUtil.removeStatusListener(this);
    super.dispose();
  }
}