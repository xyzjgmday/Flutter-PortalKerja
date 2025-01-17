import 'package:flutter/material.dart';
import 'package:online_job_portal/jobseeker/js_singlejobpost.dart';
import 'package:online_job_portal/model/jobpost.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:online_job_portal/helpers/api_helper.dart';
//screens
import '../widgets/loading.dart';
import 'package:online_job_portal/splash_screen.dart';
import 'js_profile.dart';

class JHomeScreen extends StatefulWidget {
  const JHomeScreen({Key? key}) : super(key: key);

  @override
  _JHomeScreenState createState() => _JHomeScreenState();
}

class _JHomeScreenState extends State<JHomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool isloading = false;
  List<JobPost> jobposts = <JobPost>[];
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portal Kerja'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.face,
                color: Colors.white,
              ),
              onPressed: () {
                _viewProfile(context);
              }),
          IconButton(
              icon: const Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
              onPressed: () {
                _logout(context);
              }),
        ],
      ),
      body: Stack(
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
          Container(
            child: isloading
                ? const LoadingLayout()
                : RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _refresh,
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                hintText: 'Search for jobs...',
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(20.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(20.0)),
                                suffixIcon: IconButton(
                                  onPressed: () => _filterData(),
                                  icon: const Icon(Icons.search),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: jobposts.length,
                              itemBuilder: _buildItemsForListView,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  _filterData() {
    var searchtext = searchController.text;
    if (searchtext != '') {
      print(searchtext);
      _fetchPosts().then((posts) {
        // jobposts.clear();
        // jobposts = posts;
        List<JobPost> searchedjobposts = <JobPost>[];
        for (var post in posts) {
          //jobtitle
          if (post.jobtitle.toLowerCase().contains(searchtext.toLowerCase())) {
            searchedjobposts.add(post);
          }
          //job designation
          if (post.designation
              .toLowerCase()
              .contains(searchtext.toLowerCase())) {
            searchedjobposts.add(post);
          }
          //job jobtype
          if (post.jobtype.toLowerCase().contains(searchtext.toLowerCase())) {
            searchedjobposts.add(post);
          }
          //job company_address
          if (post.companyaddress
              .toLowerCase()
              .contains(searchtext.toLowerCase())) {
            searchedjobposts.add(post);
          }
          //job qualification
          if (post.qualification
              .toLowerCase()
              .contains(searchtext.toLowerCase())) {
            searchedjobposts.add(post);
          }
        }
        setState(() {
          jobposts.clear();
          jobposts = searchedjobposts;
        });
      });
    } else {
      _refresh();
    }
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );
  }

  void _viewProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const JsProfile()),
    );
  }

  Widget _buildItemsForListView(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JsSingleJobPost(
                jobpost: jobposts[index],
              ),
            ),
          );
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //job title
                Text(
                  jobposts[index].jobtitle,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color(0xff0a0a0a),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                //company name
                Text(
                  jobposts[index].companyname,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xffababab),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: <Widget>[
                    Chip(
                      backgroundColor: Color(0xfff1f2f4),
                      avatar: Icon(
                        Icons.location_on,
                        color: Color(0xffababab),
                      ),
                      label: Text(
                        jobposts[index].companyaddress,
                        style: TextStyle(
                          color: Color(0xffababab),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Chip(
                      backgroundColor: Color(0xfff1f2f4),
                      label: Text(
                        jobposts[index].jobtype,
                        style: TextStyle(
                          color: Color(0xffababab),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Chip(
                      backgroundColor: Color(0xfff1f2f4),
                      label: Text(
                        jobposts[index].qualification,
                        style: TextStyle(
                          color: Color(0xffababab),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                //skils
                Text(
                  jobposts[index].skills,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color(0xffababab),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // _fetchPosts();
    super.initState();
    _populateJobPosts();
  }

  void _populateJobPosts() {
    _fetchPosts().then((posts) {
      setState(() {
        jobposts.clear();
        jobposts = posts;
      });
    });
  }

  Future<List<JobPost>> _fetchPosts() async {
    var url = ApiHelper.jobPosts;
    var response =
        await http.get(Uri.parse(url), headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var responseJson = json.decode(response.body);
      print(responseJson['datas']);
      final items =
          (responseJson["datas"] as List).map((i) => JobPost.fromJson(i));
      return items.toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<void> _refresh() {
    setState(() {
      jobposts.clear();
    });
    return _fetchPosts().then((posts) {
      setState(() {
        jobposts = posts;
      });
    });
  }
}
