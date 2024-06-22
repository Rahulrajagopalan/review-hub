import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:review_hub/CustomWidgets/customText.dart';
import 'package:review_hub/constants/colors.dart';
import 'package:review_hub/user/babytoys.dart';
import 'package:review_hub/user/channel.dart';
import 'package:review_hub/user/movies.dart';
import 'package:review_hub/user/restaurent.dart';
import 'package:review_hub/user/resturentview.dart';
import 'package:review_hub/user/services.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
 final search = TextEditingController();

  late Stream<QuerySnapshot> _serviceStream;

  void _onSearchChanged(String query) {
    setState(() {
      _serviceStream = FirebaseFirestore.instance
          .collection('items')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .snapshots();
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize the stream with all mechanics initially
    _serviceStream = FirebaseFirestore.instance.collection('items').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            // _buildSearchBar(),
            _buildCategory("Movie", Movies()),
            _buildCategory("Hotel", Restaurants()),
            _buildCategory("Product", Toys()),
            _buildCategory("Service", Services()),
            _buildCategory("Channel", Channel()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      height: 50,
      child: TextFormField(
          onChanged: _onSearchChanged,
        controller: search,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          fillColor: white,
          filled: true,
          hintText: "Search",
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: customBalck),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: white),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(String title, Widget route) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: AppText(
                text: title,
                weight: FontWeight.w400,
                size: 15,
                textcolor: customBalck,
              ),
            ),
            RatingBar.builder(
              initialRating: 3.5,
              minRating: 1,
              ignoreGestures: true,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 18,
              unratedColor: Colors.yellow[100],
              itemPadding: const EdgeInsets.symmetric(horizontal: 1),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {},
            ),
          ],
        ),
        SizedBox(height: 15),
        SizedBox(
          height: 120,
          child: InkWell(            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return route;
              }));
            },
            child:FutureBuilder(
            future: search.text.isEmpty
                ? _fetchCategoryItems(title)
                : _fetchSearchResults(search.text),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<DocumentSnapshot> data = snapshot.data as List<DocumentSnapshot>;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                height: 80,
                                width: 160,
                                child: Image.network(
                                  '${data[index]['image_url']}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            AppText(
                              text: data[index]['name'],
                              weight: FontWeight.normal,
                              size: 12,
                              textcolor: customBalck,
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<List<DocumentSnapshot>> _fetchCategoryItems(String category) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('items').where('category', isEqualTo: category).get();
      return querySnapshot.docs.toList();
    } catch (error) {
      print('Error fetching $category: $error');
      throw error;
    }
  }
  Future<List<DocumentSnapshot>> _fetchSearchResults(String searchTerm) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('items')
        .where('name', isGreaterThanOrEqualTo: searchTerm)
        .where('name', isLessThan: searchTerm + 'z')
        .get();
    return querySnapshot.docs.toList();
  } catch (error) {
    print('Error fetching search results: $error');
    throw error;
  }
}
}
