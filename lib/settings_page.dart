import 'dart:ui';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pass_manager/model/sharedPrefs_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'db/db_handler.dart';
import 'model/themes_handler.dart';

class P2PHandler {}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);


  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
  @override
  Widget build(BuildContext context) {
    var __isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    // String text = "Sayan";
    // text = Encryption.encryptAES(text);
    // print(text);
    // text = Encryption.decryptAES(text);
    // print(text);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          double.infinity,
          75.0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
            child: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(3)),
              ),
              centerTitle: false,
              leadingWidth: 56,
              automaticallyImplyLeading: false,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    color: __isDarkMode
                        ? Color(0xffddfffa)
                        : Color(0xff0ba99b).withOpacity(0.7),
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              elevation: 0,
              backgroundColor: Colors.transparent.withOpacity(0.03),
              toolbarHeight: 75,
              title: Padding(
                padding: const EdgeInsets.only(left: 0, right: 35),
                child: Text(
                  "Settings",
                  style: GoogleFonts.poppins(
                    letterSpacing: 1,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: __isDarkMode
                        ? Color(0xffddfffa)
                        : Color(0xff0ba99b).withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 10),
          children: [
            SettingsTile(
              text: "Haptics",
              prefsTag: "isHapticsEnabled",
            ),
            SettingsTile(
                text: "Encrypt Passwords", prefsTag: "shouldEncryptPassword"),
            // Container(
            // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10),
            //   gradient: LinearGradient(
            //     colors: [
            //       Color(0xff0ba99b).withOpacity(0.5),
            //       Color(0xff0ba99b).withOpacity(0.6),
            //     ],
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //   ),
            // ),
            // height: 75,
            // padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Expanded(
            //       child: Padding(
            //         padding: EdgeInsets.only(left: 20),
            //         child: Text(
            //           "Share data across websockets",
            //           style: GoogleFonts.poppins(
            //             color: Colors.white,
            //             fontSize: 22,
            //           ),
            //         ),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.only(right: 20),
            //       child: Transform.scale(
            //         scale: 1.2,
            //         child: IconButton(
            //           onPressed: (){
            //
            //           },
            //           icon: Icon(
            //             Icons.ios_share,
            //             size: 28,
            //             // color: __isDarkMode ? Color(0xffddfffa) : Color(0xff0ba99b).withOpacity(0.7),
            //             color: Colors.white,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // ),
            SizedBox(
              height: 10,
            ),
            ExpandablePanel(
              theme: ExpandableThemeData(
                hasIcon: true,
                iconColor: __isDarkMode
                    ? Color(0xffddfffa)
                    : Color(0xff0ba99b).withOpacity(0.7),
                iconPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 2),
              ),
              header: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Text(
                  "PRIVACY POLICY",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    letterSpacing: 1.6,
                    color: __isDarkMode
                        ? Color(0xffddfffa)
                        : Color(0xff0ba99b).withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              collapsed: Text(""),
              expanded: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Center(
                      child: StyledText(
                        text: "<heading>----- No bullshit privacy policy -----</heading>\n\nAll data are stored in <bold>this device only</bold>. No one else has access to it. For improved security and peace of mind, your passwords are <bold>encrypted</bold> and all data are stored in <bold>local database</bold>. ",
                        tags: {
                          'bold': StyledTextTag(style: GoogleFonts.roboto(fontWeight: FontWeight.w600)),
                          'heading': StyledTextTag(style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600))
                        },
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          color: __isDarkMode?Colors.white70:Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ExpandablePanel(
              theme: ExpandableThemeData(
                hasIcon: true,
                iconColor: __isDarkMode
                    ? Color(0xffddfffa)
                    : Color(0xff0ba99b).withOpacity(0.7),
                iconPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 2),
              ),
              header: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Text(
                  "DEVELOPER",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    letterSpacing: 1.6,
                    color: __isDarkMode
                        ? Color(0xffddfffa)
                        : Color(0xff0ba99b).withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              collapsed: Text(""),
              expanded: Column(
                children: [
                  DeveloperTile(
                    type: urlType.web,
                    kicon: Icons.code_outlined,
                    ktitle: "Github",
                    ksubtitle: "@SayanK",
                    kURL: Uri.parse("https://www.github.com/SayanKabir"),
                    isDarkMode: __isDarkMode,
                  ),
                  DeveloperTile(
                    type: urlType.web,
                    kicon: Icons.domain_outlined,
                    ktitle: "LinkedIn",
                    ksubtitle: "Sayan Kabir",
                    kURL: Uri.parse("https://www.linkedin.com/in/sayan-kabir-b3a52a204/"),
                    isDarkMode: __isDarkMode,
                  ),
                  DeveloperTile(
                    type: urlType.mail,
                    kicon: Icons.bug_report_outlined,
                    ktitle: "Report Bug",
                    ksubtitle: "",
                    // kURL: Uri.parse("mailto:kabirsayan93@gmail.com?subject=Bug report/ Feedback for Passworzzz&body="),
                    kURL: Uri(
                      scheme: 'mailto',
                      path: 'kabirsayan93@gmail.com',
                      query: encodeQueryParameters(<String, String>{
                        'subject': 'Bug report/ Feedback for Passworzzz',
                      }),
                    ),
                    isDarkMode: __isDarkMode,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsTile extends StatefulWidget {
  final String text;
  final String prefsTag;
  SettingsTile({Key? key, required this.text, required this.prefsTag})
      : super(key: key);

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {
  bool switchState = true;
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      switchState = prefs.getBool(widget.prefsTag) ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            Color(0xff0ba99b).withOpacity(0.5),
            Color(0xff0ba99b).withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      height: 75,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                widget.text,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Transform.scale(
              scale: 1.2,
              child: Switch(
                value: switchState,
                onChanged: (bool value) {
                  setState(() {
                    switchState = value;
                    SharedPrefsHandler.saveData(
                        tag: widget.prefsTag, data: value);
                  });
                },
                activeTrackColor: Color(0xff0ed9a0).withOpacity(0.8),
                activeColor: Colors.white,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.transparent.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum urlType {web, mail}
class DeveloperTile extends StatelessWidget {
  final urlType type;
  final IconData kicon;
  final String ktitle;
  final String ksubtitle;
  final Uri kURL;
  final bool isDarkMode;
  const DeveloperTile({
    Key? key,
    required this.kicon,
    required this.ktitle,
    required this.ksubtitle,
    required this.kURL,
    required this.isDarkMode,
    required this.type,
  }) : super(key: key);

  void _launchURL(Uri _url) async {
    if(type == urlType.mail){
      await launchUrl(
        _url,

      );
    }else{
      if (await canLaunchUrl(_url)) {
        await launchUrl(
          _url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $_url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchURL(kURL);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              Color(0xff0ba99b).withOpacity(0.5),
              Color(0xff0ba99b).withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        height: 75,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Icon(
                kicon,
                size: 30,
                color: Colors.white,
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
    );
  }
}
