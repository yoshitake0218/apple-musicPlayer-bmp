import 'package:bmp_music/features/album/notifiers/album_notifier.dart';
import 'package:bmp_music/features/song/notifiers/song_notifier.dart';
import 'package:bmp_music/features/song/ui/components/player_deck.dart';
import 'package:bmp_music/shared/ui/screens/home_screen.dart';
import 'package:bmp_music/screens/library_screen.dart';
import 'package:bmp_music/screens/profile_screen.dart';
import 'package:bmp_music/screens/search_screen.dart';
import 'package:bmp_music/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const LibraryScreen(),
    const SearchScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        Provider.of<SongNotifier>(context, listen: false).loadSongs();
        Provider.of<AlbumNotifier>(context, listen: false).loadAlbums();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: ColorUtils.systemNavigationBarColor(context),
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("音楽ペースメーカー"),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Offstage(
                    offstage: _selectedIndex != 0,
                    child: _screens[0],
                  ),
                  Offstage(
                    offstage: _selectedIndex != 1,
                    child: _screens[1],
                  ),
                  Offstage(
                    offstage: _selectedIndex != 2,
                    child: _screens[2],
                  ),
                  Offstage(
                    offstage: _selectedIndex != 3,
                    child: _screens[3],
                  ),
                ],
              ),
            ),
            const PlayerDeck(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (value) => setState(() {
            _selectedIndex = value;
          }),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.home_rounded),
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.library_music_rounded),
              icon: Icon(Icons.library_music_outlined),
              label: "Library",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.search_rounded),
              icon: Icon(Icons.search_rounded),
              label: "Search",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.account_circle_rounded),
              icon: Icon(Icons.account_circle_outlined),
              label: "Me",
            ),
          ],
        ),
      ),
    );
  }
}
