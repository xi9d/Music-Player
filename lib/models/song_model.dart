class Song{
  final String title;
  final String description;
  final String url;
  final String coverUrl;

  Song({
    required this.title,
    required this.description,
    required this.url,
    required this.coverUrl,

});

  static List<Song> songs = [
    Song(
        title: "kuogonzwa",
        description: "Good music",
        url: "assets/music/music1.mp3",
        coverUrl: "assets/images/fox1.png"
    ),
    Song(
        title: "Tiga Niwe",
        description: "kikuyu music",
        url: "assets/music/music2.mp3",
        coverUrl: "assets/images/fox2.png"
    ),
    Song(
        title: "Racing up",
        description: "Paul Mwai music",
        url: "assets/music/music3.mp3",
        coverUrl: "assets/images/fox3.png"
    ),
  ];
  
}