import 'package:cplayer/models/song_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    List<Song> songs = Song.songs;



    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight ,
            colors: [
              Colors.blue.shade900.withOpacity(0.5),
              Colors.deepPurple.shade300.withOpacity(0.6),
              // Colors.deepOrange.shade100.withOpacity(0.7)
            ]
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Icon(Icons.grid_view_rounded, color: Colors.white,),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: CircleAvatar(
                backgroundImage: NetworkImage("https://avatars.githubusercontent.com/u/137267747?v=4"),
                radius: 15.0,
              ),
            )
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
              // home navigation
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              // favorites navigation
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline),
                label: "Favourites",
              ),
              // play navigation
              BottomNavigationBarItem(
                icon: Icon(Icons.play_circle_outline),
                label: "Play",
              ),
              // people navigation
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
                Column(
                  children: [
                    Text(
                      "Welcome",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white)),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Enjoy your favourite music",
                      style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Search",
                        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey.shade700),
                        prefixIcon:
                          Icon(
                            Icons.search,
                            color: Colors.grey.shade400,
                          ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        )
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              "Trending music",
                                style: Theme.of(context)
                                    .textTheme.bodyLarge!
                                    .copyWith(
                                    color: Colors.white,v
                                    fontWeight: FontWeight.bold)
                            ),
                            Text(
                              "view more",
                                style: Theme.of(context)
                                    .textTheme.bodyLarge!
                                    .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300)),

                          ],
                        ),
                      ],
                    )

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


