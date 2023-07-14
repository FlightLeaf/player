
import '../model/music.dart';
import 'mysql.dart';

class MusicDataUtil{

  static List<MusicModel> getMusicData(){
    List<MusicModel> list = [];
    for(Map<String,String> map in _json){
      MusicModel model = MusicModel.fromMap(map);
      list.add(model);
    }
    return list;
  }
  static final List<Map<String,String>> _json = [
    {
      "id":"2",
      "name":"My Soul",
      "author":"July",
      "thumbnail":"https://p1.music.126.net/NFl1s5Hl3E37dCaFIDHfNw==/727876697598920.jpg",
      "url":"https://freepd.com/music/And%20Just%20Like%20That.mp3"
    },
    {
      "id":"4",
      "name":"The truth that you leave",
      "author":"Pianoboy高至豪",
      "thumbnail":"https://p1.music.126.net/9idkdzbel_-lYBP7Dv_dVQ==/102254581395289.jpg",
      "url":"https://freepd.com/music/Be%20Chillin.mp3"
    },
    {
      "id":"5",
      "name":"You Approaching",
      "author":"Nirvana",
      "thumbnail":"https://p1.music.126.net/C71zjT6CpHzqcRFObJO4Rg==/109951165319954700.jpg",
      "url":"https://freepd.com/music/City%20Sunshine.mp3"
    },
    {
      "id":"6",
      "name":"A Little Story",
      "author":"Valentin",
      "thumbnail":"https://p1.music.126.net/WDUPJR39CqZrzVgAQbQOZg==/109951167082640661.jpg",
      "url":"https://freepd.com/music/From%20Page%20to%20Practice.mp3"
    },
    {
      "id":"7",
      "name":"Illusionary Daytime",
      "author":"Shirfine",
      "thumbnail":"https://p2.music.126.net/8xNVCemkSNQptEyNw1PHKg==/8914840278033758.jpg",
      "url":"https://freepd.com/music/Funshine.mp3"
    },
    {
      "id":"8",
      "name":"Rain after Summer",
      "author":"羽肿",
      "thumbnail":"https://p1.music.126.net/0qSEuzSqPNrACMPoGy8efw==/109951162863729074.jpg",
      "url":"https://freepd.com/music/Happy%20Whistling%20Ukulele.mp3"
    },
    {
      "id":"9",
      "name":"いつも何度でも （永远同在）",
      "author":"宗次郎",
      "thumbnail":"https://p1.music.126.net/ygxAeYxxXPONww041tylMw==/5996736418028563.jpg",
      "url":"https://freepd.com/music/Advertime.mp3"
    },
    {
      "id":"10",
      "name":"Asphyxia（Piano Ver.）",
      "author":"逆时针向",
      "thumbnail":"https://p2.music.126.net/FRIgNtiwVBjHDIlhgnzGew==/109951163869607960.jpg",
      "url":"https://freepd.com/music/Advertime.mp3"
    },
    {
      "id":"11",
      "name":"花火が瞬く夜に",
      "author":"羽肿",
      "thumbnail":"https://p1.music.126.net/ygxAeYxxXPONww041tylMw==/5996736418028563.jpg",
      "url":"https://freepd.com/music/Advertime.mp3"
    },
    {
      "id":"12",
      "name":"With an Orchid",
      "author":"Yanni",
      "thumbnail":"https://p1.music.126.net/7fgnozyzD3e-flaQO-W2zQ==/109951164936091373.jpg",
      "url":"https://freepd.com/music/Advertime.mp3"
    },
  ];
}