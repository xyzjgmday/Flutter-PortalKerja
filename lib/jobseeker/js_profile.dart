import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:online_job_portal/jobseeker/js_profile_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:online_job_portal/helpers/api_helper.dart';
import 'package:url_launcher/url_launcher.dart';
//screens
import '../widgets/loading.dart';

class JsProfile extends StatefulWidget {
  const JsProfile({Key? key}) : super(key: key);

  @override
  _JsProfileState createState() => _JsProfileState();
}

class _JsProfileState extends State<JsProfile> {
  List profiledata = [];
  bool isloading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Widget cv = profiledata == null && profiledata[0]["cv"] == 'no'
        ? const Text('no cv uploaded')
        : MaterialButton(
            onPressed: () {
              _viewCV();
            },
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(
                'View CV.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JsProfileEdit()),
                );
              })
        ],
      ),
      body: isloading
          ? const LoadingLayout()
          : profiledata.isEmpty
              ? const Text('Opps!')
              : SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        //Email
                        ListTile(
                          title: const Text('Email'),
                          subtitle: profiledata[0]["email"] != null
                              ? Text(profiledata[0]["email"])
                              : const Text('-'),
                        ),
                        //fullname
                        ListTile(
                          title: const Text('Fullname'),
                          subtitle: profiledata[0]["fullname"] != null
                              ? Text(profiledata[0]["fullname"])
                              : const Text('-'),
                        ),
                        //phone_no
                        ListTile(
                          title: const Text('Phone'),
                          subtitle: profiledata[0]["phone_no"] != null
                              ? Text(profiledata[0]["phone_no"])
                              : const Text('-'),
                        ),
                        //address
                        ListTile(
                          title: const Text('Address'),
                          subtitle: profiledata[0]["address"] != null
                              ? Text(profiledata[0]["address"])
                              : const Text('-'),
                        ),
                        //address
                        ListTile(
                          title: const Text('CV'),
                          subtitle: cv,
                          trailing: MaterialButton(
                            onPressed: () {
                              _uploadCV();
                            },
                            color: Theme.of(context).hintColor,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Text(
                                'Upload CV.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  @override
  void initState() {
    // _downloaderPluginInitialize();
    _fetchProfileData();
    super.initState();
  }

  Future<void> _fetchProfileData() async {
    setState(() {
      isloading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getInt('user_id');

    var url = ApiHelper.jsProfileData;
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

  Future<void> _uploadCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      print(file.path);

      setState(() {
        isloading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userid = prefs.getInt('user_id');

      Dio dio = Dio();
      FormData formdata = FormData.fromMap({
        'user_id': userid.toString(),
        //  'cv': file,
        'cv': await MultipartFile.fromFile(file.path.toString(),
            filename: "cv.pdf"),
      }); // just like JS

      var url = ApiHelper.jsUploadCv;
      var response = await dio.post(url, data: formdata);
      print(response.data.toString());
      var data = response.data;
      if (data['status'] == 200) {
        //show snackbar
        const snackBar = SnackBar(
          content: Text("Cv Uploaded!"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _fetchProfileData();
      }
      setState(() {
        isloading = false;
      });
    }

    if (mounted) _fetchProfileData();
  }

  void _viewCV() async {
    final url = ApiHelper.jsDownloadCv + profiledata[0]['cv'];
    if (!await launch(url)) throw 'Could not launch';
  }
}
