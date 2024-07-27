import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:online_job_portal/helpers/api_helper.dart';
//screens
import 'em_profile_edit.dart';
import '../widgets/loading.dart';

class EmProfile extends StatefulWidget {
  const EmProfile({Key? key}) : super(key: key);

  @override
  _EmProfileState createState() => _EmProfileState();
}

class _EmProfileState extends State<EmProfile> {
  //variables
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Color fieldColor = Color(0xffedeef3);
  List profiledata = [];
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Company Profile'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmProfileEdit()),
              );
            },
          ),
        ],
      ),
      body: isloading
          ? const LoadingLayout()
          : profiledata.isEmpty
              ? Center(child: const Text('OOPS!'))
              : Stack(
                  children: <Widget>[
                    // Background gradient
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blueAccent, Colors.deepPurpleAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                    // Overlay with gradient
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black54],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    // Main content
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            //company Email
                            ListTile(
                              title: Text('Company Email', style: TextStyle(color: Colors.white)),
                              subtitle: profiledata[0]["email"] != null
                                  ? Text(profiledata[0]["email"], style: TextStyle(color: Colors.white70))
                                  : Text('-', style: TextStyle(color: Colors.white70)),
                            ),
                            //company name
                            ListTile(
                              title: Text('Company Name', style: TextStyle(color: Colors.white)),
                              subtitle: profiledata[0]["company_name"] != null
                                  ? Text(profiledata[0]["company_name"], style: TextStyle(color: Colors.white70))
                                  : Text('-', style: TextStyle(color: Colors.white70)),
                            ),
                            //company Phone
                            ListTile(
                              title: Text('Company Phone', style: TextStyle(color: Colors.white)),
                              subtitle: profiledata[0]["company_phone"] != null
                                  ? Text(profiledata[0]["company_phone"], style: TextStyle(color: Colors.white70))
                                  : Text('-', style: TextStyle(color: Colors.white70)),
                            ),
                            //company Address
                            ListTile(
                              title: Text('Company Address', style: TextStyle(color: Colors.white)),
                              subtitle: profiledata[0]["company_address"] != null
                                  ? Text(profiledata[0]["company_address"], style: TextStyle(color: Colors.white70))
                                  : Text('-', style: TextStyle(color: Colors.white70)),
                            ),
                            //company Map
                            ListTile(
                              title: Text('Company Map Data', style: TextStyle(color: Colors.white)),
                              subtitle: profiledata[0]["lat"] != null && profiledata[0]["long"] != null
                                  ? Text('lat: ${profiledata[0]["lat"]}, long: ${profiledata[0]["long"]}', style: TextStyle(color: Colors.white70))
                                  : Text('-', style: TextStyle(color: Colors.white70)),
                            ),
                            //About Company
                            ListTile(
                              title: Text('About Company', style: TextStyle(color: Colors.white)),
                              subtitle: profiledata[0]["company_desc"] != null
                                  ? Text(profiledata[0]["company_desc"], style: TextStyle(color: Colors.white70), textAlign: TextAlign.justify)
                                  : Text('-', style: TextStyle(color: Colors.white70)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  @override
  void initState() {
    _fetchProfileData();
    super.initState();
  }

  Future<void> _fetchProfileData() async {
    setState(() {
      isloading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getInt('user_id');

    var url = ApiHelper.emProfileData;
    var response = await http.post(Uri.parse(url), body: {
      'user_id': userid.toString(), //need to send as string
    }, headers: {
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      var data = json.decode(response.body);
      print('Response body: $data');
      if (data['status'] == 200) {
        setState(() {
          isloading = false;
          profiledata.add(data['datas']);
        });
      }
    }
  }
}
