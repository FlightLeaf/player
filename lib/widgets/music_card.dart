import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../model/music.dart';
import '../tools/audio_player.dart';

class MusicCard extends StatelessWidget {
  const MusicCard({
    Key? key,
    required this.model,
    required this.callback,
  }) : super(key: key);

  final MusicModel model;
  final Function(int) callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback(0),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  model.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 0.40 * 120, // 15%的高度
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // 黑色背景，透明度50%
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 8,
              bottom: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    model.author,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: InkWell(
                onTap: () => callback(1),
                child: Icon(
                  (AudioPlayerUtil.state == PlayerState.playing) &&
                      (AudioPlayerUtil.musicModel?.url == model.url)
                      ? Icons.pause_circle_outline_outlined
                      : Icons.play_circle_outline_outlined,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
