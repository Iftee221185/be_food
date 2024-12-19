import 'package:be_food/ui_for_customer/post_interface.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class FoodSearchPage extends StatefulWidget {
  @override
  _FoodSearchPageState createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Firestore reference
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to fetch foods from Firestore
  Future<List<DocumentSnapshot>> _searchFoods(String query) async {
    if (query.isEmpty) {
      return [];
    }
    var result = await _firestore
        .collection('post') // Use the correct collection name 'post'
        .where('foodname', isGreaterThanOrEqualTo: query)
        .where('foodname', isLessThanOrEqualTo: query + '\uf8ff') // For prefix search
        .get();
    return result.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, // The back arrow icon
            color: Colors.yellow, // Change this to any color you want
          ),
          onPressed: () {
            // Add your back navigation logic here
            Navigator.pop(context);
          },
        ),
        actions: [
          SizedBox(
            height: 40,
            width: 350,
            child: TextFormField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: "Search for Food",
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical:2.0,horizontal: 2.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.search,color: Colors.white,)
              ),
              style: TextStyle(fontSize: 13,color: Colors.white),
            ),
          ),
          SizedBox(width: 10,)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: _searchFoods(_searchQuery),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No results found.'));
                }
                var foods = snapshot.data!;
                return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 items per row
                      crossAxisSpacing: 10, // Space between columns
                      mainAxisSpacing: 10, // Space between rows
                    ),
                    itemCount: foods.length,
                  itemBuilder: (context,index){
                    var food = foods[index].data() as Map<String, dynamic>;
                    String foodId = foods[index].id;
                      return GestureDetector(
                          onTap: () {
                            Get.to(PostInterface(), arguments: [
                              food['date']??'',
                              food['description']??'',
                              food['imageurl']??'',
                              food['nameadmin']??'',
                              food['price']??'',
                              food['profilepic']??'',
                              food['time']??'',
                              food['uid']??'',
                              food['foodname']??'',
                              food['adminlocation']??'',
                              food['likes']??0,
                              food['rating']??0.0,
                              foodId??'',
                            ],);
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            height: 130,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  child: Image(
                                    height: 125,
                                    width: 200,
                                    image: food['imageurl'] !=
                                        null
                                        ? NetworkImage(
                                        food['imageurl']!)
                                        : AssetImage(
                                        "assets/images/upload.jpg")
                                    as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(
                                      5, 3, 10, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        food['foodname'],
                                        style: GoogleFonts.abel(
                                            fontSize: 10,
                                            fontWeight:
                                            FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        food['foodtype'],
                                        style: GoogleFonts.abel(
                                            fontSize: 10,
                                            color: Colors.black),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(
                                            food['price'],
                                            style:
                                            GoogleFonts.abel(
                                                fontSize: 10,
                                                color: Colors
                                                    .black),
                                          ),
                                          Text(
                                            '',
                                            style:
                                            GoogleFonts.abel(
                                                fontSize: 10,
                                                color: Colors
                                                    .black),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ));













                  },

                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
