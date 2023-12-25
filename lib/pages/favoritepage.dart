import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trynote/data/sqldb.dart';
import 'package:trynote/main.dart';

class FavoritePage extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const FavoritePage({Key? key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  SqlDb sqlDb = SqlDb();
  List favoriteNotes = [];
  bool isLoading = true;
  late ScrollController favoriteScrollController;

  Future<void> readFavoriteData() async {
    List<Map> resultTwo = await sqlDb.readData('''
    SELECT notes.*
    FROM notes
    JOIN favorite_notes ON notes.id = favorite_notes.id AND notes.userid='${sharepref!.getString('id')}';
    ''');
    if (mounted) {
      setState(() {
        favoriteNotes.addAll(resultTwo);
        isLoading = false;
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (favoriteScrollController.hasClients) {
        favoriteScrollController
            .jumpTo(favoriteScrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> removeNote(int index) async {
    int result = await sqlDb.removeData('''
      DELETE FROM favorite_notes
      WHERE id = ${favoriteNotes[index]['id']}
    ''');
    if (result > 0) {
      setState(() {
        favoriteNotes.removeWhere(
            (element) => element['id'] == favoriteNotes[index]['id']);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    favoriteScrollController = ScrollController();
    readFavoriteData();
  }

  @override
  void dispose() {
    favoriteScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (favoriteNotes.isEmpty) {
      return Center(
        child: Text(
          'No favorite notes',
          style: GoogleFonts.mPlusRounded1c(
            color: Colors.grey[850]!.withOpacity(0.7),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return ListView.builder(
        controller: favoriteScrollController,
        itemCount: favoriteNotes.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          return Dismissible(
            key: Key("${favoriteNotes[i]['id']}"),
            background: Container(
              color: Colors.red,
              alignment: Alignment.center,
              child: const Icon(
                Icons.delete_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            onDismissed: (DismissDirection direction) {
              removeNote(i);
            },
            child: Card(
              color: const Color.fromARGB(255, 20, 18, 18),
              child: ListTile(
                title: Text(
                  '${favoriteNotes[i]['title']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    '${favoriteNotes[i]['content']}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
