import 'package:be_food/models/note.dart';
import 'package:be_food/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomerFeed extends StatefulWidget {
  const CustomerFeed({super.key});

  @override
  State<CustomerFeed> createState() => _CustomerFeedState();
}

class _CustomerFeedState extends State<CustomerFeed> {
  void initState() {
    updateData();
    // TODO: implement initState
    super.initState();
  }
  updateData() async{
    UserProvider userProvider =Provider.of(context,listen: false);
    await userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context) {
    Userdata? userdata =Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: Colors.white10,
      body:Column(
        children: [
          Stack(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 5, 0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 27,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: userdata?.imageurl != null
                            ? NetworkImage(userdata!.imageurl!)
                            : AssetImage("assets/images/file.png") as ImageProvider,
                      ),
                    ),
                  ),

                  Text(userdata?.name??'',style:GoogleFonts.abel(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),),
                ],
              ),

            ],
          ),
          SizedBox(height: 5,),
          Divider(height: 0,color: Colors.black,),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('post').snapshots(),
              builder: (context,snapshot){
                List<Column> clientWidgets=[];
                if(snapshot.hasData)
                {
                  final clients=snapshot.data?.docs.reversed.toList();
                  for(var client in clients!)
                  {

                      final clientWidget = Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20, 10, 0, 0),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundImage:  client['profilepic'] != null
                                      ? NetworkImage( client['profilepic'])
                                      : AssetImage(
                                      "assets/images/file.png") as ImageProvider,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                  client['nameadmin'] ,style: GoogleFonts.abel(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                  ),),
                                  Row(

                                    children: [
                                      Text(
                                        client['date'], style: GoogleFonts.abel(
                                          fontSize: 12,

                                          color: Colors.black
                                      ),),
                                      SizedBox(width: 5,),
                                      Text(
                                        client['time'], style: GoogleFonts.abel(
                                          fontSize: 12,

                                          color: Colors.black
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(width: 30,),
                              Container(
                                height: 30,
                                width: 130,
                                decoration: BoxDecoration(
                                    color: Colors.orangeAccent,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(width: 1,color: Colors.black)
                                ),

                                child: Center(
                                  child: Text("Price: ${client['price']}tk",style:GoogleFonts.abel(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                  ),),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 0, 10),
                            child: Text(
                              client['description'], style: GoogleFonts.acme(
                                fontSize: 17,
                                color: Colors.black
                            ),),
                          ),
                          Center(
                            child: Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height / 2,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 1.3,
                              child: Image(
                                image: client['imageurl'] != null
                                    ? NetworkImage(client['imageurl']!)
                                    : AssetImage(
                                    "assets/images/upload.jpg") as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                        ],
                      );
                      clientWidgets.add(clientWidget);

                  }
                }
                return Expanded(
                  child: ListView(
                    children: clientWidgets,
                  ),
                );
              }
          ),
        ],
      ),

    );
  }
}
