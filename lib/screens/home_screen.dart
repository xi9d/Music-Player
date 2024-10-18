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
      _audioPlayer.setAsset(song.url); // Load the song from assets
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
                    "https://images.unsplash.com/photo-1729008014121-edd6672688d7?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw0fHx8ZW58MHx8fHx8"),
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

  Widget _buildFavoritesScreen(BuildContext context) {
    // Dummy data for favorite songs (replace with actual data)
    final List<Map<String, String>> favoriteSongs = [
      {
        'title': 'Song 1',
        'artist': 'Artist 1',
        'coverUrl': 'assets/images/fox2.png', // Example image paths
      },
      {
        'title': 'Song 2',
        'artist': 'Artist 2',
        'coverUrl': 'assets/images/fox3.png',
      },
      // Add more songs here...
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          const Text(
            'Your Favorite Songs',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Conditional Rendering: If no favorite songs
          favoriteSongs.isEmpty
              ? Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/fox1.png', // Placeholder for empty state
                  height: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                const Text(
                  "You haven't added any favorite songs yet!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'still in development',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to add songs
                  },
                  child: const Text('Add Favorite Songs'),
                ),

              ],
            ),
          )
              : Expanded(
            child: ListView.builder(
              itemCount: favoriteSongs.length,
              itemBuilder: (context, index) {
                final song = favoriteSongs[index];
                return _buildFavoriteSongItem(song);
              },
            ),
          ),

          // Add Favorite Songs Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12), // Better button size
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add Favorite Songs'),
                onPressed: () {
                  // Navigate to add more songs
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

// Helper widget for displaying each favorite song in a card format
  Widget _buildFavoriteSongItem(Map<String, String> song) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            song['coverUrl']!,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          song['title']!,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          song['artist']!,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.redAccent),
          onPressed: () {
            // Functionality to remove from favorites
          },
        ),
      ),
    );
  }

  Widget _buildPlayScreen(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (currentlyPlaying == null) {
      return const Center(
        child: Text(
          'No song is playing',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white54, // Softer color for no song state
          ),
        ),
      );
    }

    return Column(
      children: [
        // This section will take half of the screen height for the image
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                width: screenWidth * 0.8, // Image takes 80% of the screen width
                height: screenHeight * 0.4, // Image takes 40% of screen height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24), // More pronounced rounding for modern look
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38, // Slightly darker shadow for better contrast
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: currentlyPlaying!.coverUrl.isNotEmpty
                      ? Image.asset(
                    currentlyPlaying!.coverUrl,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    'assets/images/fox1.png', // Fallback image for missing cover
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Song Title Section
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Now Playing: ${currentlyPlaying!.title}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24, // Make the title more prominent
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        // Controls Section
        Expanded(
          flex: 2,
          child: _buildControlButtons(),
        ),
      ],
    );
  }

  Widget _buildControlButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: _previousSong,
            icon: const Icon(Icons.skip_previous),
            color: Colors.white,
            iconSize: 48, // Slightly larger for better visibility
          ),
          IconButton(
            onPressed: isPlaying ? _pauseSong : _resumeSong,
            icon: Icon(
              isPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled,
            ),
            color: Colors.white,
            iconSize: 64, // Larger play/pause button for prominence
          ),
          IconButton(
            onPressed: _nextSong,
            icon: const Icon(Icons.skip_next),
            color: Colors.white,
            iconSize: 48, // Larger next button
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
                      'https://images.unsplash.com/photo-1729008014121-edd6672688d7?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw0fHx8ZW58MHx8fHx8'),
                  radius: 50,
                ),
                const SizedBox(height: 20),
                const Text(
                  'John Doe',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  'Music Player',
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
              _buildProfileStat('Songs Played', 'N/A'),
              _buildProfileStat('Playlists', 'N/A'),
              _buildProfileStat('Favorites', 'N/A'),
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


