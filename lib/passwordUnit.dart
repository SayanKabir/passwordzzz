import 'dart:async';
import 'dart:ui';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pass_manager/passGenerator.dart';
import 'package:provider/provider.dart';
import 'db/db_handler.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'model/data_model.dart';
import 'model/themes_handler.dart';
import 'utils.dart';


class PasswordUnit extends StatelessWidget {
  final ListViewForm form;
  final VoidCallback notifyParent;
  final String kSite, kUsername;
  final int id;
  const PasswordUnit({
    Key? key,
    required this.kSite,
    required this.kUsername,
    required this.id,
    required this.notifyParent,
    required this.form,
  }) : super(key: key);

  Future<String> getPassword() async => await DBHandler.dataBase.queryPassword(id);

  Future openDialog(BuildContext context,String _displaySite, bool __isDarkMode) async {
    String pass = await getPassword();
    late Timer _timer;
    return showAnimatedDialog(
      // barrierDismissible: true,
        barrierColor: Colors.transparent,
        animationType: DialogTransitionType.scale,
        duration: Duration(milliseconds: 300),
        alignment: Alignment.center,
        context: context,
        builder: (context) {
          // _timer = Timer(Duration(seconds: pass.length * 3), () {
          //   Navigator.of(context).pop();
          // });
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
              child: AlertDialog(
                actionsAlignment: MainAxisAlignment.center,
                actionsPadding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
                contentPadding: EdgeInsets.only(top: 20, bottom: 0, right: 0, left: 5),
                insetPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 200),
                clipBehavior: Clip.hardEdge,
                elevation: 0,
                backgroundColor: Theme.of(context).cardColor.withOpacity(0.7),
                // backgroundColor: Color(0xff0ba99b).withOpacity(0.8),
                // backgroundColor: Colors.transparent,
                // backgroundColor:
                // Provider.of<ThemeProvider>(context, listen: false).isDarkMode
                //     ? Color(0xff1d5c5c).withOpacity(0.7)
                //     : Color(0xffddffff).withOpacity(0.7),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                // title: Text(
                //   pass,
                //   textAlign: TextAlign.center,
                //   style: TextStyle(fontSize: 24, letterSpacing: 1),
                // ),
                content: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //FAVICON
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: CachedNetworkImage(
                                // imageUrl: "https://retired-bronze-bovid.faviconkit.com/${kSite}/64",
                                imageUrl: "https://www.google.com/s2/favicons?domain=${kSite}&sz=64",
                                imageBuilder: (context, imageProvider) => Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => SizedBox(width: 40, height: 40,),
                                errorWidget: (context, _, __){
                                  String _firstLetter = kSite[0].toUpperCase();
                                  return Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xff0ba99b).withOpacity(0.5),
                                          Color(0xff0ba99b).withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                    width: 40,
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        _firstLetter,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            //TEXTS
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //SITE TEXT
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        _displaySite,
                                        style: GoogleFonts.montserrat(
                                          // color: Colors.white,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                    //USERNAME TEXT
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        kUsername,
                                        style: GoogleFonts.montserrat(
                                          color: __isDarkMode
                                              ? Color(0xffcfcfcf)
                                              : Color(0xff3f3f3f),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //EDIT BUTTON
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.2),
                                borderRadius: BorderRadius.circular(60),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.yellow.withOpacity(0.5),
                                    Colors.yellow.withOpacity(0.7),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () async {
                                  hapticFeedback(context, HapticType.Selection);
                                  openEditDataBottomSheet(context);
                                },
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 24,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                            ),
                          ]
                      ),
                      Row(
                        children: [
                          //PASSWORD CONTAINER
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff0ba99b).withOpacity(0.3),
                                    Color(0xff0ba99b).withOpacity(0.4),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              height: 100,
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  pass,
                                  overflow: TextOverflow.visible,
                                  style: GoogleFonts.poppins(
                                    fontSize: 21,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //COPY BUTTON
                          Container(
                            margin: EdgeInsets.all(10),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff0ba99b).withOpacity(0.3),
                                  Color(0xff0ba99b).withOpacity(0.4),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () async {
                                hapticFeedback(context, HapticType.Selection);
                                FlutterClipboard.copy(pass);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  mySnackbar(
                                      context, "Password copied to clipboard"),
                                );
                              },
                              child: Icon(
                                Icons.content_copy_outlined,
                                size: 20,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      hapticFeedback(context, HapticType.Selection);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff0ba99b).withAlpha(200)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> openEditDataBottomSheet(context) async {
    var localAuth = LocalAuthentication();
    bool didAuthenticate =
    await localAuth.authenticate(
        localizedReason:
        'Please authenticate to modify password');
    if (didAuthenticate) {
      String pass = await getPassword();
      Navigator.of(context).pop();
      showModalBottomSheet<void>(
        clipBehavior: Clip.antiAlias,
        barrierColor: Colors.transparent,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return passGeneratorScreen(
            notifyParent: notifyParent,
            form: PassGeneratorForm.MODIFY,
            prevSite: kSite,
            prevUser: kUsername,
            prevPass: pass,
            prevID: id,
          );
        },
      );
    }
  }

  void openPopup(BuildContext context, int id, bool __isDarkMode){
    showAlignedDialog(context: context, builder: (context) => AlertDialog(
      actionsOverflowDirection: VerticalDirection.down,
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
      contentPadding: EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 0),
      insetPadding: EdgeInsets.only(left: 200, top: 300, bottom: 200, right: 15),
      clipBehavior: Clip.hardEdge,
      elevation: 0,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            highlightColor: Color(0xfffada5e),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.edit_outlined),
                  Text("Edit"),
                ],
              ),
            ),
            onTap: () async {
              hapticFeedback(context, HapticType.Selection);
              openEditDataBottomSheet(context);
            },
          ),
          InkWell(
            highlightColor: Colors.redAccent,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.delete_outlined),
                  Text("Delete"),
                ],
              ),
            ),
            onTap: () async {
              hapticFeedback(context, HapticType.Action);
              var localAuth = LocalAuthentication();
              bool didAuthenticate =
              await localAuth.authenticate(
                  localizedReason:
                  'Please authenticate to delete password');
              if (didAuthenticate) {
                DBHandler.dataBase.deleteData(id);
                notifyParent();
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  mySnackbar(
                      context, "Password deleted"),
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      // actions: [
      //   TextButton(
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //     child: Text(
      //       "Edit",
      //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff0ba99b).withAlpha(200)),
      //     ),
      //   ),
      //   TextButton(
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //     child: Text(
      //       "Delete",
      //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff0ba99b).withAlpha(200)),
      //     ),
      //   ),
      // ],
    ),
      barrierColor: Colors.transparent,
    );
  }
  // Future<void> copyPasswordToClipboard() async{
  //   String pass = await getPassword();
  //   FlutterClipboard.copy(pass);
  // }
  String getDisplaySite(){
    String displaySite = kSite.split('.')[0];
    displaySite = displaySite.trim();
    displaySite = displaySite[0].toUpperCase() + displaySite.substring(1);
    return displaySite;
  }
  @override
  Widget build(BuildContext context) {
    var __isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    String displaySite = getDisplaySite();
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
      child: InkWell(
        splashColor: Colors.blue,
        onTap: () async{
          hapticFeedback(context, HapticType.Selection);
          print(id);
          var localAuth = LocalAuthentication();
          bool didAuthenticate = await localAuth.authenticate(
              localizedReason:
              'Please authenticate to access password');
          if (didAuthenticate) {
            openDialog(context, displaySite, __isDarkMode);
          }
        },
        onLongPress: (){
          if(form == ListViewForm.MANAGER)
            openPopup(context, id, __isDarkMode);
        },
        child: Container(
          // child: Material(
          //   type: MaterialType.card,
          //   borderOnForeground: false,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   elevation: 0,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         Padding(
          //           padding: EdgeInsets.only(left: 10, right: 0),
          //           child: SizedBox(
          //             width: 45,
          //             height: 45,
          //             child: CachedNetworkImage(
          //               imageUrl: "https://retired-bronze-bovid.faviconkit.com/${kSite}/64",
          //               // placeholder: (context, url) => CircularProgressIndicator(),
          //               errorWidget: (context, _, __){
          //                 String _firstLetter = kSite[0].toUpperCase();
          //                 return Text(_firstLetter);
          //               },
          //             ),
          //           ),
          //         ),
          //         //TEXTS
          //         Padding(
          //           padding: const EdgeInsets.only(left: 25),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             mainAxisAlignment: MainAxisAlignment.spaceAround,
          //             children: [
          //               //SITE TEXT
          //               Text(
          //                 kSite,
          //                 style: GoogleFonts.montserrat(
          //                   // color: Colors.white,
          //                   fontSize: 20,
          //                 ),
          //               ),
          //
          //               //USERNAME TEXT
          //               Padding(
          //                 padding: const EdgeInsets.only(left: 1),
          //                 child: Text(
          //                   kUsername,
          //                   style: GoogleFonts.montserrat(
          //                     color: __isDarkMode
          //                         ? Color(0xffcfcfcf)
          //                         : Color(0xff3f3f3f),
          //                     fontSize: 14,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //
          //         //BUTTONS
          //         // Row(
          //         //   mainAxisAlignment: MainAxisAlignment.end,
          //         //   children: [
          //         //     //SEE BUTTON
          //         //     SizedBox(
          //         //       width: 40,
          //         //       child: TextButton(
          //         //         style: TextButton.styleFrom(
          //         //           // minimumSize: Size(8, 8),
          //         //           shape: RoundedRectangleBorder(
          //         //             borderRadius: BorderRadius.circular(30),
          //         //           ),
          //         //         ),
          //         //         onPressed: () async {
          //         //           lightImpact();
          //         //           var localAuth = LocalAuthentication();
          //         //           bool didAuthenticate = await localAuth.authenticate(
          //         //               localizedReason:
          //         //               'Please authenticate to access password');
          //         //           if (didAuthenticate) {
          //         //             openDialog(context);
          //         //           } else {}
          //         //         },
          //         //         child: Icon(
          //         //           Icons.visibility_outlined,
          //         //           size: 21,
          //         //         ),
          //         //       ),
          //         //     ),
          //         //
          //         //     //COPY BUTTON
          //         //     SizedBox(
          //         //       width: 40,
          //         //       child: TextButton(
          //         //         style: TextButton.styleFrom(
          //         //           shape: RoundedRectangleBorder(
          //         //             borderRadius: BorderRadius.circular(30),
          //         //           ),
          //         //         ),
          //         //         onPressed: () async {
          //         //           lightImpact();
          //         //           var localAuth = LocalAuthentication();
          //         //           bool didAuthenticate = await localAuth.authenticate(
          //         //               localizedReason:
          //         //               'Please authenticate to access password');
          //         //           if (didAuthenticate) {
          //         //             copyPasswordToClipboard();
          //         //             ScaffoldMessenger.of(context).showSnackBar(
          //         //               mySnackbar(
          //         //                   context, "Password copied to clipboard"),
          //         //             );
          //         //           } else {}
          //         //         },
          //         //         child: Icon(
          //         //           Icons.content_copy_outlined,
          //         //           size: 21,
          //         //         ),
          //         //       ),
          //         //     ),
          //         //   ],
          //         // ),
          //       ],
          //     ),
          //   ),
          // ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //FAVICON
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 0),
                  child: CachedNetworkImage(
                    // imageUrl: "https://retired-bronze-bovid.faviconkit.com/${kSite}/64",
                    imageUrl: "https://www.google.com/s2/favicons?domain=${kSite}&sz=64",
                    imageBuilder: (context, imageProvider) => Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => SizedBox(width: 40, height: 40,),
                    errorWidget: (context, _, __){
                      String _firstLetter = kSite[0].toUpperCase();
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff0ba99b).withOpacity(0.5),
                              Color(0xff0ba99b).withOpacity(0.7),
                            ],
                          ),
                        ),
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Text(
                            _firstLetter,
                            style: GoogleFonts.montserrat(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                //TEXTS
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //SITE TEXT
                        Text(
                          displaySite,
                          style: GoogleFonts.montserrat(
                            // color: Colors.white,
                            fontSize: 20,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        //USERNAME TEXT
                        Padding(
                          padding: const EdgeInsets.only(left: 1),
                          child: Text(
                            kUsername,
                            style: GoogleFonts.montserrat(
                              color: __isDarkMode
                                  ? Color(0xffcfcfcf)
                                  : Color(0xff3f3f3f),
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //BUTTONS
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     //SEE BUTTON
                //     SizedBox(
                //       width: 40,
                //       child: TextButton(
                //         style: TextButton.styleFrom(
                //           // minimumSize: Size(8, 8),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(30),
                //           ),
                //         ),
                //         onPressed: () async {
                //           lightImpact();
                //           var localAuth = LocalAuthentication();
                //           bool didAuthenticate = await localAuth.authenticate(
                //               localizedReason:
                //               'Please authenticate to access password');
                //           if (didAuthenticate) {
                //             openDialog(context);
                //           } else {}
                //         },
                //         child: Icon(
                //           Icons.visibility_outlined,
                //           size: 21,
                //         ),
                //       ),
                //     ),
                //
                //     //COPY BUTTON
                //     SizedBox(
                //       width: 40,
                //       child: TextButton(
                //         style: TextButton.styleFrom(
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(30),
                //           ),
                //         ),
                //         onPressed: () async {
                //           lightImpact();
                //           var localAuth = LocalAuthentication();
                //           bool didAuthenticate = await localAuth.authenticate(
                //               localizedReason:
                //               'Please authenticate to access password');
                //           if (didAuthenticate) {
                //             copyPasswordToClipboard();
                //             ScaffoldMessenger.of(context).showSnackBar(
                //               mySnackbar(
                //                   context, "Password copied to clipboard"),
                //             );
                //           } else {}
                //         },
                //         child: Icon(
                //           Icons.content_copy_outlined,
                //           size: 21,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          height: 75,
        ),
      ),
    );
  }
}