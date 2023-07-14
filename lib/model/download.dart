import 'package:player/model/music.dart';

class DownloadModel {

  MusicModel model;
  double progress = 0;

  String get progressForPercent {
    int aProgress = (progress * 100).toInt();
    return '$aProgress%';
  }

  DownloadModel(this.model);

}