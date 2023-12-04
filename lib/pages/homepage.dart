import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trynote/data/sqldb.dart';




class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SqlDb sqlDb = SqlDb();
  late ScrollController homeScrollController;
  List<Map<String, dynamic>> notes = [];
  List<Map<String, dynamic>> favoriteNotes = [];

  @override
  void initState() {
    super.initState();
    homeScrollController = ScrollController();
    readData();
    readFavoriteData();
  }

  Future<void> readData() async {
    List<Map<String, dynamic>> result =
        await sqlDb.readData("SELECT * FROM notes");
    setState(() {
      notes.addAll(result);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeScrollController
          .jumpTo(homeScrollController.position.maxScrollExtent);
    });
  }

  Future<void> readFavoriteData() async {
    favoriteNotes.clear();
    List<Map<String, dynamic>> resultTwo = await sqlDb.readData('''
    SELECT notes.*
    FROM notes
    JOIN favorite_notes ON notes.id = favorite_notes.id;
    ''');
    setState(() {
      favoriteNotes.addAll(resultTwo);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeScrollController
          .jumpTo(homeScrollController.position.maxScrollExtent);
    });
  }

  Future<void> removeNote(int index) async {
    int result = await sqlDb.removeData('''
      DELETE FROM notes
      WHERE id = ${notes[index]['id']}
    ''');
    if (result > 0) {
      setState(() {
        notes.removeWhere((element) => element['id'] == notes[index]['id']);
      });
    }
  }

  Future<void> insertToFavorites(int id) async {
    await sqlDb.insertData('''
      INSERT INTO favorite_notes (id)
      VALUES ("$id")
    ''');
  }

  Future<void> removeFromFavorites(int id) async {
    await sqlDb.removeData('''
      DELETE FROM favorite_notes
      WHERE id = $id
    ''');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (notes.isEmpty) {
      return Center(
        child: Stack(clipBehavior: Clip.none, children: [
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text(
                'No notes try add one using ',
                style: GoogleFonts.mPlusRounded1c(
                  color: Colors.grey[850]!.withOpacity(0.7),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.add_circle,
                size: 35,
                color: Colors.grey[850]!.withOpacity(0.7),
              ),
              Text(
                'Icon in the bottom ',
                style: GoogleFonts.mPlusRounded1c(
                  color: Colors.grey[850]!.withOpacity(0.7),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: -size.height / 3.4,
            right: size.width / 3.3,
            child: SizedBox(
                width: size.width / 6,
                height: size.width / 6,
                child: SvgPicture.asset('assets/down-arrow-svgrepo-com.svg')),
          )
        ]),
      );
    } else {
      return ListView(
        controller: homeScrollController,
        physics: const BouncingScrollPhysics(),
        children: notes.map((note) {
          return Dismissible(
            key: Key("${note['id']}"),
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
              removeNote(notes.indexOf(note));
            },
            child: Card(
              color: const Color.fromARGB(255, 20, 18, 18),
              child: ListTile(
                title: Text(
                  '${note['title']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    '${note['content']}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                trailing: IconButton(
                  onPressed: () async {
                    if (favoriteNotes
                        .any((favorite) => favorite['id'] == note['id'])) {
                      await removeFromFavorites(note['id']);
                    } else {
                      await insertToFavorites(note['id']);
                    }
                    readFavoriteData();
                  },
                  icon: Icon(
                    favoriteNotes
                            .any((favorite) => favorite['id'] == note['id'])
                        ? Icons.favorite_rounded
                        : Icons.favorite_outline_rounded,
                    color: const Color(0xff00ADB5),
                    size: 30,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    }
  }
}