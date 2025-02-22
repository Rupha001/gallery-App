import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'add_photo_dialog.dart';

class Photo {
  final String name;
  final String url;
  final String description;
  final DateTime dateTime;

  Photo({
    required this.name,
    required this.url,
    required this.description,
    required this.dateTime,
  });
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<String> menu = ['All Photos', 'Santhos', 'Test-1'];
  List<Photo> photoList = [];
  String sortBy = 'Time -latest first';

  void _handleAddPhoto(Photo photo) {
    setState(() {
      photoList.add(photo);
    });
  }

  void _sortPhotoList(String sortOption) {
    setState(() {
      sortBy = sortOption;
      if (sortOption == 'Time -latest first') {
        photoList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      } else if (sortOption == 'Time -latest last') {
        photoList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      } else if (sortOption == 'Name') {
        photoList.sort((a, b) => a.name.compareTo(b.name));
      }
    });
  }

  void _deletePhoto(int index) {
    setState(() {
      photoList.removeAt(index);
    });
  }

  void _showDeleteConfirmationDialog(int index) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Sure you want to delete the selected photo?'),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    width: 120, 
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('CANCEL'),
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xffF68F50),
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    width: 130, 
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _deletePhoto(index);
                      },
                      child: Text('DELETE'),
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xffF65050),
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Photo Gallery',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xff4A4C50),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.filter_list_sharp,
              color: Colors.white,
            ),
            onSelected: (String value) {
            },
            itemBuilder: (context) {
              return menu.map((e) => PopupMenuItem<String>(
                value: e,
                child: Text(e),
              )).toList();
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.sort,
              color: Colors.white,
            ),
            onSelected: (String value) {
              _sortPhotoList(value);
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Time -latest first',
                  child: Text('Time -latest first'),
                ),
                const PopupMenuItem<String>(
                  value: 'Time -latest last',
                  child: Text('Time -latest last'),
                ),
                const PopupMenuItem<String>(
                  value: 'Name',
                  child: Text('Name'),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        shape: CircleBorder(),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddPhotoDialog(
                onAdd: (photo) {
                  _handleAddPhoto(photo);
                },
              );
            },
          );
        },
        child: Icon(Icons.add,
        color: Colors.white,
        ),
      ),
      body: photoList.isEmpty
          ? Center(child: Text('No photo Added'))
          : GridView.builder(
              padding: EdgeInsets.all(9),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 9,
                mainAxisSpacing: 9,
              ),
              itemCount: photoList.length,
              itemBuilder: (context, index) {
                final photo = photoList[index];
                final formattedDate = DateFormat('dd-MM-yyyy').format(photo.dateTime);

                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        photo.url,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                photo.description,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                '$formattedDate         -by ${photo.name}', 
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: LikeButton(
                          onTap: (isLiked) async {
                            return !isLiked;
                          },  
                          likeCountPadding: EdgeInsets.symmetric(horizontal: 4),
                          likeBuilder: (isLiked) {
                            return Icon(
                              Icons.favorite,
                              color: isLiked ? Colors.red : Colors.white,
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(index);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
