import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:review_hub/CustomWidgets/customText.dart';
import 'package:review_hub/constants/colors.dart';
import 'package:review_hub/user/movieview.dart';

class Channel extends StatefulWidget {
  Channel({Key? key}) : super(key: key);

  @override
  _ChannelState createState() => _ChannelState();
}

class _ChannelState extends State<Channel> {
  final TextEditingController search = TextEditingController();
  late Stream<QuerySnapshot> _ChannelStream;

  @override
  void initState() {
    super.initState();
    // Initialize the stream to display all Channel initially
    _ChannelStream = FirebaseFirestore.instance
        .collection('items')
        .where('category', isEqualTo: 'Channel')
        .snapshots();
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _ChannelStream = FirebaseFirestore.instance
            .collection('items')
            // .where('category', isEqualTo: 'Movie')
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThanOrEqualTo: query + '\uf8ff')
            .snapshots();
      });
    } else {
      // Reset to initial stream if search query is cleared
      setState(() {
        _ChannelStream = FirebaseFirestore.instance
            .collection('items')
            .where('category', isEqualTo: 'Channel')
            .snapshots();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: const Text('Channel'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: TextField(
                  controller: search,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search Channel',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _ChannelStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SizedBox(
                          height: 20,width: 20,
                          child: const CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.data?.docs.isEmpty ?? true) {
                      return const Text('No Channel found.');
                    } else {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var movieData = snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                          return _buildMovieItem(movieData);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieItem(Map<String, dynamic> movieData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (ctx) {
          return MovieView(
              name: movieData['name'],
              image: movieData['image_url'],
              about: movieData['about']);
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                movieData['image_url'],
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              movieData['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            // const SizedBox(height: 5),
            FutureBuilder(
                future: calculateAverageRating(movieData['name']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 20,width: 20,
                      child: const CircularProgressIndicator());
                  }
                  double rating = snapshot.data ?? 0.0;

                  return Column(
                    children: [
                      RatingBar.builder(
                        initialRating: rating.toDouble(),
                        minRating: 1,
                        ignoreGestures: true,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 16,
                        unratedColor: Colors.yellow[100],
                        itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          (rating);
                        },
                      ),
                    ],
                  );
                }),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return MovieView(
                        name: movieData['name'],
                        image: movieData['image_url'],
                        about: movieData['about']);
                  }));
                },
                child: Container(
                  color: maincolor,
                  height: 35,
                  width: 100,
                  child: const Center(
                    child: Text(
                      'See More',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<double> calculateAverageRating(String itemName) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('item', isEqualTo: itemName)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return 0.0; // No reviews, thus no average rating
      }

      double totalRating = 0;
      querySnapshot.docs.forEach((doc) {
        totalRating += doc.data()['rating'];
      });
      print(5 / querySnapshot.docs.length);
      return 5 / querySnapshot.docs.length;
    } catch (e) {
      print("Error fetching reviews: $e");
      return 0.0;
    }
  }
}
