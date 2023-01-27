import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pass_manager/db/db_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:expandable/expandable.dart';
import 'package:pass_manager/model/data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_tooltip/simple_tooltip.dart';

class developersScreen extends StatefulWidget {
  final VoidCallback notifyParent;
  developersScreen({Key? key, required this.notifyParent}) : super(key: key);

  @override
  State<developersScreen> createState() => _developersScreenState();
}

class _developersScreenState extends State<developersScreen> {
  IconData _uploadIcon = Icons.cloud_upload;
  IconData _downloadIcon = Icons.cloud_download;
  static String user = "";

  void uploadDataToFirebase() async {
    final _firestore = FirebaseFirestore.instance;
    print("Uploading...");
    final List datas = await DBHandler.dataBase.getData();
    for (var data in datas) {
      _firestore.collection(user).add(
          data); //use firebase_auth username in place of UserData after creating collection reference
    }
    setState(() {
      _uploadIcon = Icons.done;
    });
  }

  void downloadDataFromFirebase() async {
    final _firestore = FirebaseFirestore.instance;
    print("Downloading...");
    final _dataOnCloud = await _firestore.collection("UserData").get();
    if (_dataOnCloud != null) {
      for (var _data in _dataOnCloud.docs) {
        Map<String, dynamic> newData = _data.data();
        DBHandler.dataBase.addNewDataFromMap(newData);
      }
    }
    setState(() {
      _downloadIcon = Icons.done;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff050e2d),
        elevation: 8,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5, top: 10, bottom: 5),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_outlined,
              size: 26,
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 5, top: 10, bottom: 5),
          child: Text(
            "Settings",
            style: GoogleFonts.ubuntu(
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 30),
        children: [
          // SizedBox(
          //   height: 30,
          // ),
          ExpandablePanel(
            theme: ExpandableThemeData(
              hasIcon: true,
              iconColor: Colors.white54,
              iconPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            ),
            header: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  child: Icon(
                    _uploadIcon,
                    size: 45,
                  ),
                ),
                Text(
                  "SAVE PASSWORDS IN CLOUD",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                      letterSpacing: 1.2,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
            collapsed: Text(""),
            expanded: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: TextField(
                    cursorColor: Colors.white70,
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) {
                      user = value;
                    },
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Color(0xff099185), width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Color(0xff099185), width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Color(0xff099185), width: 2),
                      ),
                      hintText: "Create Username",
                      hintStyle: GoogleFonts.poppins(color: Colors.white70),
                      // labelStyle: GoogleFonts.poppins(color: Colors.white70),
                      // floatingLabelBehavior: FloatingLabelBehavior.never,
                      // floatingLabelStyle: GoogleFonts.poppins(color: Colors.white70),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: TextField(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    cursorColor: Colors.white70,
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) {
                      setState(() {});
                    },
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Color(0xff099185), width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Color(0xff099185), width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Color(0xff099185), width: 2),
                      ),
                      hintText: "Password",
                      hintStyle: GoogleFonts.poppins(color: Colors.white70),
                      // labelStyle: GoogleFonts.poppins(color: Colors.white70),
                      // floatingLabelBehavior: FloatingLabelBehavior.never,
                      // floatingLabelStyle: GoogleFonts.poppins(color: Colors.white70),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff099185),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    uploadDataToFirebase();
                  },
                  child: Text(
                    "Upload to Cloud",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ExpandablePanel(
            theme: ExpandableThemeData(
              hasIcon: true,
              iconColor: Colors.white54,
              iconPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            ),
            header: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  child: Icon(
                    _downloadIcon,
                    size: 45,
                  ),
                ),
                Text(
                  "DOWNLOAD PASSWORDS",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                      letterSpacing: 1.2,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
            collapsed: Text(""),
            expanded: Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: TextField(
                    cursorColor: Colors.white70,
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) {
                      setState(() {});
                    },
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        BorderSide(color: Color(0xff099185), width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        BorderSide(color: Color(0xff099185), width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        BorderSide(color: Color(0xff099185), width: 2),
                      ),
                      hintText: "Username",
                      hintStyle: GoogleFonts.poppins(color: Colors.white70),
                      // labelStyle: GoogleFonts.poppins(color: Colors.white70),
                      // floatingLabelBehavior: FloatingLabelBehavior.never,
                      // floatingLabelStyle: GoogleFonts.poppins(color: Colors.white70),
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: TextField(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    cursorColor: Colors.white70,
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) {
                      setState(() {});
                    },
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        BorderSide(color: Color(0xff099185), width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        BorderSide(color: Color(0xff099185), width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        BorderSide(color: Color(0xff099185), width: 2),
                      ),
                      hintText: "Password",
                      hintStyle: GoogleFonts.poppins(color: Colors.white70),
                      // labelStyle: GoogleFonts.poppins(color: Colors.white70),
                      // floatingLabelBehavior: FloatingLabelBehavior.never,
                      // floatingLabelStyle: GoogleFonts.poppins(color: Colors.white70),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff099185),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Download passwords",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 40,
          // ),
          ExpandablePanel(
            theme: ExpandableThemeData(
              hasIcon: true,
              iconColor: Colors.white54,
              iconPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 2),
            ),
            header: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Text(
                "DEVELOPER",
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  letterSpacing: 1.6,
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            collapsed: Text(""),
            expanded: Column(
              children: [
                DeveloperTile(
                  kicon: Icons.code_outlined,
                  ktitle: "Github",
                  ksubtitle: "@SayanK",
                  kURL:
                      "",
                ),
                DeveloperTile(
                  kicon: Icons.domain_outlined,
                  ktitle: "LinkedIn",
                  ksubtitle: "Sayan Kabir",
                  kURL: "https://www.linkedin.com/in/sayan-kabir-b3a52a204/",
                ),
                DeveloperTile(
                  kicon: Icons.campaign_outlined,
                  ktitle: "Twitter",
                  ksubtitle: "@SayanK",
                  kURL: "https://twitter.com/account/access?flow=login",
                ),
              ],
            ),
          ),
          // DeveloperTile(
          //   kicon: Icons.code_outlined,
          //   ktitle: "Github",
          //   ksubtitle: "@SayanK",
          //   kURL:
          //       "",
          // ),
          // DeveloperTile(
          //   kicon: Icons.domain_outlined,
          //   ktitle: "LinkedIn",
          //   ksubtitle: "Sayan Kabir",
          //   kURL: "https://www.linkedin.com/in/sayan-kabir-b3a52a204/",
          // ),
          // DeveloperTile(
          //   kicon: Icons.campaign_outlined,
          //   ktitle: "Twitter",
          //   ksubtitle: "@SayanK",
          //   kURL: "https://twitter.com/account/access?flow=login",
          // ),
        ],
      ),
    );
  }
}

class DeveloperTile extends StatelessWidget {
  final IconData kicon;
  final String ktitle;
  final String ksubtitle;
  final String kURL;
  const DeveloperTile({
    Key? key,
    required this.kicon,
    required this.ktitle,
    required this.ksubtitle,
    required this.kURL,
  }) : super(key: key);

  void _launchURL(String _url) async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  static Future<void> lightImpact() async {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.lightImpact',
    );
  }

  static Future<void> mediumImpact() async {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.mediumImpact',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 0),
      child: GestureDetector(
        onTap: () {
          _launchURL(kURL);
        },
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Icon(
                    kicon,
                    size: 30,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ktitle,
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      ksubtitle,
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ],
            ),
          ),
          height: 70,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff091743), Color(0xff081642)]),
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

class BackupButton extends StatelessWidget {
  const BackupButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          ),
          height: 80,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff091743), Color(0xff081642)]),
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
