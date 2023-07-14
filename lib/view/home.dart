import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:player/view/music_information.dart';
import 'package:player/view/music_suggest.dart';
import 'package:player/view/identify.dart';
import 'package:player/view/user.dart';

import '../model/music.dart';
import '../tools/audio_player.dart';
import '../tools/music_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  late List<MusicModel> _data;

  @override
  void initState() {
    super.initState();
    _data = MusicDataUtil.getMusicData();
    AudioPlayerUtil.statusListener(
        key: this,
        listener: (sate) {
          if (mounted) {
            setState(() {
              name = AudioPlayerUtil.musicModel!.name.toString();
              author = AudioPlayerUtil.musicModel!.author.toString();
            });
          }
        });
  }

  bool play_state = false;
  var name = "Happy!";
  var author = "Everyday";
  int _currentPage = 0; //当前页面
  //导航栏每个图标对应的页面
  final List<Widget> _pages = <Widget>[
    MusicPage(),
    IdentifyPage(),
    UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = Theme.of(context).brightness;
    Color head =
        currentBrightness == Brightness.light ? Colors.black : Colors.white;
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.lightBlueAccent,
        currentIndex: _currentPage,
        onTap: (int index) {
          setState(() {
            _currentPage = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        //配置底部tabs可以有
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(
              icon: Icon(Icons.my_library_music_rounded), label: '听歌识曲'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.925,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.blueAccent],
            begin: Alignment.bottomLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.12,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: () {
                  AudioPlayerUtil.previousMusic();
                  setState(() {
                    name = AudioPlayerUtil.musicModel!.name.toString();
                    author = AudioPlayerUtil.musicModel!.author.toString();
                  });
                },
              ),
              InkWell(
                onTap: () =>
                    AudioPlayerUtil.listPlayerHandle(musicModels: _data),
                child: const SizedBox(
                  height: 50,
                  child: ListAudioButton(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: () {
                  AudioPlayerUtil.nextMusic();
                  setState(() {
                    name = AudioPlayerUtil.musicModel!.name.toString();
                    author = AudioPlayerUtil.musicModel!.author.toString();
                  });
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.55,
                alignment: Alignment.center,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => musicDetail()),
                      );
                    },
                    child: Marquee(
                      text: name.toString(),
                      style: const TextStyle(color: Colors.white),
                      scrollAxis: Axis.horizontal,
                      blankSpace: 30,
                      velocity: 80,
                      //pauseAfterRound: Duration(seconds: 1),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ListAudioButton extends StatefulWidget {
  const ListAudioButton({Key? key}) : super(key: key);

  @override
  State<ListAudioButton> createState() => _ListAudioButtonState();
}

class _ListAudioButtonState extends State<ListAudioButton> {
  bool _playing = false;

  @override
  void initState() {
    _playing = AudioPlayerUtil.state == PlayerState.playing;
    super.initState();

    // 监听播放状态
    AudioPlayerUtil.statusListener(
        key: this,
        listener: (state) {
          if (AudioPlayerUtil.isListPlayer == false) return;
          if (mounted) {
            setState(() {
              _playing = state == PlayerState.playing;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      _playing
          ? Icons.pause_circle_outline_outlined
          : Icons.play_circle_outline_outlined,
      size: 30,
      color: Colors.white,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    AudioPlayerUtil.removeStatusListener(this);
    super.dispose();
  }
}
