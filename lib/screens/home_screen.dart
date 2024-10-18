import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:player/model/song_model.dart'; // Import your Song model

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
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeFirstSong();
  }

  void _initializeFirstSong() {
    // Load the first song on initialization
    if (Song.songs.isNotEmpty) {
      _playSong(Song.songs[0], 0);
    }
  }

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

  // Navigation method for selecting tabs
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
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
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeScreen(context), // Home Screen
            _buildFavoritesScreen(context), // Favorites Page
            _buildPlayScreen(context), // Play Page
            _buildProfileScreen(context), // Profile Page
          ],
        ),
      ),
    );
  }

  // Home screen implementation
  Widget _buildHomeScreen(BuildContext context) {
    List<Song> songs = Song.songs
        .where((song) => song.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Padding(
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
    );
  }

  // Favorites screen
  Widget _buildFavoritesScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Favorites Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // You can add functionality here
            },
            child: const Text('Add Favorite Songs'),
          ),
        ],
      ),
    );
  }

  // Play screen to show current song or first song on the list
  Widget _buildPlayScreen(BuildContext context) {
    if (currentlyPlaying == null) {
      return const Center(
        child: Text(
          'No song is playing',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(
        'Now Playing: ${currentlyPlaying!.title}',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 10),
    Image.asset(            currentlyPlaying!.coverUrl,
      width: 200,
      height: 200,
      fit: BoxFit.cover,
    ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _previousSong,
                icon: const Icon(Icons.skip_previous),
                color: Colors.white,
                iconSize: 40,
              ),
              IconButton(
                onPressed: isPlaying ? _pauseSong : _resumeSong,
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                ),
                color: Colors.white,
                iconSize: 60,
              ),
              IconButton(
                onPressed: _nextSong,
                icon: const Icon(Icons.skip_next),
                color: Colors.white,
                iconSize: 40,
              ),
            ],
          ),
        ],
        ),
    );
  }

  // Profile screen implementation
  Widget _buildProfileScreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://avatars.githubusercontent.com/u/137267747?v=4'),
                  radius: 50,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Paul Webo',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  'Music Lover | Developer | Song Curator',
                  style: TextStyle(color: Colors.grey.shade300, fontSize: 16),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add profile edit functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Divider(color: Colors.white70),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProfileStat('Songs Played', '102'),
              _buildProfileStat('Playlists', '8'),
              _buildProfileStat('Favorites', '24'),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white70),
          const SizedBox(height: 20),
          const Text(
            'Your Recent Activity',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildRecentActivity('Liked', 'Song Title 1', Icons.favorite),
                _buildRecentActivity('Added to Playlist', 'Song Title 2',
                    Icons.playlist_add),
                _buildRecentActivity('Played', 'Song Title 3', Icons.play_arrow),
                _buildRecentActivity('Followed Artist', 'Artist Name',
                    Icons.person_add),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(String action, String detail, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurpleAccent),
      title: Text(
        '$action: $detail',
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
      onTap: () {
        // Add navigation or action for recent activities
      },
    );
  }

}


