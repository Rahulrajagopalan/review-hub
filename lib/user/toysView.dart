import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:review_hub/CustomWidgets/customText.dart';
import 'package:review_hub/CustomWidgets/customTextField.dart';
import 'package:review_hub/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToysView extends StatefulWidget {
  var name;
  var image;
  var about;
   ToysView({super.key, required this.name, required this.image, required this.about});

  @override
  State<ToysView> createState() => _ToysViewState();
}

class _ToysViewState extends State<ToysView> {
  var id;
  var _userRating=0.0;
  var comment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 200,
                        child: Image.network(
            widget.image,
            fit: BoxFit.fill,
                        ),
                        width: double.infinity,
                      ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    AppText(
                        text: widget.name,
                        weight: FontWeight.bold,
                        size: 20,
                        textcolor: customBalck),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                                width: 400,
                                child: Expanded(
                                    child: Text(
widget.about                                ))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40,),
                    AppText(
                        text: 'Rating and Reviews',
                        weight: FontWeight.bold,
                        size: 20,
                        textcolor: customBalck),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                                width: 400,
                                child: Expanded(
                                    child: Text(
                                  'Rating and Reviews are verified and are from people who use the same type of device that you use',
                                  style: GoogleFonts.poppins(),
                                ))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FutureBuilder(
                              future: calculateAverageRating(widget.name),
                              builder: (context, snapshot) {
                                 if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      double rating = snapshot.data ?? 0.0;
                     
                                return Column(
                                  children: [
                                    AppText(
                                        text: rating.toString(),
                                        weight: FontWeight.w400,
                                        size: 35,
                                        textcolor: customBalck),
                                    RatingBar.builder(
                                      initialRating: rating.toDouble(),
                                      minRating: 1,
                                      ignoreGestures: true,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 18,
                                      unratedColor: Colors.yellow[100],
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 1),
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
                          Image.asset('assets/images/rating.png')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 100,
              color: grey,
              child: FutureBuilder(
                  future: fetchLatestReview(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snap.hasError) {
                      return Text('Error: ${snap.error}');
                    }
                    if (!snap.hasData) {
                      return Container(
                          width: double.infinity,
                          child: Center(child: Text("No reviews yet.")));
                    }
                    var data = snap.data!;
                   return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                      ),
                      title: AppText(
                          text: 'user : ${snap.data!['user']}',
                          weight: FontWeight.w400,
                          size: 15,
                          textcolor: white),
                      subtitle: AppText(
                          text: snap.data!['review'],
                          weight: FontWeight.w400,
                          size: 15,
                          textcolor: white),
                      trailing: Icon(
                        CupertinoIcons.heart,
                        color: white,
                      ),
                    );
                  }),
            ),
           Padding(
              padding: const EdgeInsets.all(28.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: comment,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter comment';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        errorBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        fillColor: grey,
                        filled: true,
                        hintText: 'Add comment',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: white),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      SharedPreferences spref =
                          await SharedPreferences.getInstance();
                      var name = spref.getString('name');
                      DateTime now = DateTime.now();
                      DateFormat formatter = DateFormat('dd-MM-yyyy');
                      String formattedDate = formatter.format(now);

                      DocumentReference ref = await FirebaseFirestore.instance
                          .collection('reviews')
                          .add({
                        'user': name,
                        'review': comment.text,
                        'item': widget.name,
                        'date': formattedDate,
                        'rating': 0.0
                      });
                      setState(() {
                        id = ref.id;
                      });
                      comment.clear();
                      _showRatingDialog(id);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRatingDialog(id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Rate This Toy"),
          content: RatingBar.builder(
            initialRating: _userRating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30.0,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) =>
                const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) {
              setState(() {
                _userRating = rating;
              });
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                FirebaseFirestore.instance.collection('reviews').doc(id).update({
                  'rating': _userRating,
                });
                // Here you can add the logic to store the rating in your database
                Navigator.of(context).pop();
                // Optionally show a snackbar or toast message
              },
            ),
          ],
        );
      },
    );
  }
  Future<QueryDocumentSnapshot<Map<String, dynamic>>?>
      fetchLatestReview() async {
    try {
      // Fetch the latest review based on the timestamp
      final querySnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('item', isEqualTo: widget.name)
          .limit(1)
          .get();

      // Check if we got any results
      if (querySnapshot.docs.isNotEmpty) {
        print('-----------------------');
        return querySnapshot.docs.first;
      } else {
        // No reviews found
        return null;
      }
    } catch (e) {
      // Handle errors in fetching data
      print('Error fetching latest review data: $e');
      return null;
    }
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
