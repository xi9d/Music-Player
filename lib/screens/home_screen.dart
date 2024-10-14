import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cplayer/models/song_model.dart'; // Import your Song model

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Song? currentlyPlaying;
  int currentIndex = 0;
  bool isPlaying = false;
  String searchQuery = '';

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSong(Song song, int index) async {
    try {
      await _audioPlayer.setAsset(song.url); // Load the song from assets
      _audioPlayer.play();
      setState(() {
        currentlyPlaying = song;
        currentIndex = index;
        isPlaying = true;
      });
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  Future<void> _pauseSong() async {
    await _audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  Future<void> _resumeSong() async {
    await _audioPlayer.play();
    setState(() {
      isPlaying = true;
    });
  }

  Future<void> _nextSong() async {
    if (currentIndex < Song.songs.length - 1) {
      _playSong(Song.songs[currentIndex + 1], currentIndex + 1);
    }
  }

  Future<void> _previousSong() async {
    if (currentIndex > 0) {
      _playSong(Song.songs[currentIndex - 1], currentIndex - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Song> songs = Song.songs
        .where((song) => song.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade900.withOpacity(0.5),
            Colors.deepPurple.shade300.withOpacity(0.6),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Icon(Icons.grid_view_rounded, color: Colors.white),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://avatars.githubusercontent.com/u/137267747?v=4"),
                radius: 15.0,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.deepPurple.shade300,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.white,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              label: "Favourites",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_outline),
              label: "Play",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              label: "Profile",
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Welcome",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                const SizedBox(height: 7),
                const Text(
                  "Enjoy your favourite music",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 32),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.grey.shade700),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Trending music",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "View more",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.asset(
                        songs[index].coverUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        songs[index].title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        songs[index].description,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: const Icon(Icons.play_arrow, color: Colors.white),
                      onTap: () => _playSong(songs[index], index),
                    );
                  },
                ),
                const SizedBox(height: 20),
                if (currentlyPlaying != null)
                  Column(
                    children: [
                      Text(
                        "Now Playing: ${currentlyPlaying!.title}",
                        style: const TextStyle(
                            color: Colors.white, fontSize: 18),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _previousSong,
                            icon: const Icon(Icons.skip_previous),
                            color: Colors.white,
                          ),
                          IconButton(
                            onPressed: isPlaying ? _pauseSong : _resumeSong,
                            icon: Icon(
                              isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                            ),
                            color: Colors.white,
                            iconSize: 40,
                          ),
                          IconButton(
                            onPressed: _nextSong,
                            icon: const Icon(Icons.skip_next),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
