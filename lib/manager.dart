import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pass_manager/settings_page.dart';
import 'package:provider/provider.dart';
import 'developers_screen.dart';
import 'model/themes_handler.dart';
import 'passGenerator.dart';
import 'db/db_handler.dart';
import 'utils.dart';
import 'passwordUnit.dart';

class Manager extends StatefulWidget {
  const Manager({Key? key}) : super(key: key);

  @override
  _ManagerState createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {
  void refreshPage() {
    setState(() {});
  }

  getData() async {
    final List datas = await DBHandler.dataBase.getData();
    return datas;
  }

  @override
  Widget build(BuildContext context) {
    var __isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    TextEditingController textController = TextEditingController();
    return ChangeNotifierProvider(
      create: (_) => SearchStateProvider(),
      builder: (context, _) => Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size(
            double.infinity,
            75.0,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
              child: AppBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(3)),
                ),
                centerTitle: false,
                leadingWidth: 0,
                actions: [
                  SearchBar(
                    autoFocus: true,
                    style: TextStyle(
                      color: __isDarkMode
                          ? Colors.white70
                          : Colors.black87,
                    ),
                    color: Colors.transparent,
                    prefixIcon: Icon(Icons.search_outlined, color: __isDarkMode ? Color(0xffddfffa) : Color(0xff0ba99b).withOpacity(0.7),),
                    width: 300,
                    textController: textController,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 15, top: 5),
                    child: IconButton(
                      onPressed: () async {
                        hapticFeedback(context, HapticType.Selection);
                        final provider =
                            Provider.of<ThemeProvider>(context, listen: false);
                        provider.toggleTheme();
                      },
                      icon: Icon(
                        __isDarkMode
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                        // color: Color(0xffddfffa),
                        size: 28,
                        color: __isDarkMode ? Color(0xffddfffa) : Color(0xff0ba99b).withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
                elevation: 0,
                // backgroundColor: __isDarkMode?Colors.transparent:Color(0xff0ba99b).withOpacity(0.8),
                backgroundColor: Colors.transparent.withOpacity(0.03),
                toolbarHeight: 75,
                title: Padding(
                  padding: const EdgeInsets.only(left: 0, right: 35),
                  child: GestureDetector(
                    onTap: (){
                      Feedback.forTap(context);
                      hapticFeedback(context, HapticType.Selection);
                      print("Open Settings");
                      Navigator.of(context).push(
                        // MaterialPageRoute(
                        //   builder: (context) => SettingsPage(),
                        // ),
                        SlideAnimationRoute(
                          page: SettingsPage(),
                        ),
                      );
                    },
                    child: Image.asset(
                      "assets/logodraft1_3.png",
                      color: __isDarkMode ? Color(0xffddfffa) : Color(0xff0ba99b).withOpacity(0.7),
                      // color: Color(0xffddfffa),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: FutureBuilder<dynamic>(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text(
                          "You have no saved password",
                          style: GoogleFonts.montserrat(
                            color: __isDarkMode ? Colors.white38 : Colors.black38,
                            fontSize: 20,
                          ),
                        ),
                      );
                    } else if (snapshot.data.length != null) {
                      return RefreshIndicator(
                        edgeOffset: 100,
                        strokeWidth: 2.5,
                        backgroundColor: __isDarkMode ? Colors.black : Colors.white,
                        color: Color(0xff0ba99b),
                        onRefresh: () async {
                          await Future.delayed(Duration(milliseconds: 800));
                          refreshPage();
                        },
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(vertical: 100),
                            itemCount: snapshot.data.length + 1,
                            itemBuilder: (context, index) {
                              if (index < snapshot.data.length) {
                                return PasswordUnit(
                                  id: snapshot.data[index]['id'],
                                  kSite: snapshot.data[index]['site'],
                                  kUsername: snapshot.data[index]['user'],
                                  notifyParent: refreshPage,
                                  form: ListViewForm.MANAGER,
                                );
                              } else {
                                return SizedBox(
                                  height: 0,
                                );
                              }
                            }),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff0ba99b),
                      ),
                    );
                  }
                  throw 'TODO';
                },
              ),
            ),
            getSearchOverlay(Provider.of<SearchStateProvider>(context).isSearchShowing, Provider.of<SearchStateProvider>(context).getSearchResLen),
          ],
        ),
        floatingActionButton:
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
                      child: FloatingActionButton.extended(
                        elevation: 0,
                        backgroundColor: Color(0xff0ba99b).withOpacity(0.8),
                        label: Text(
                          "Create new password",
                          style: GoogleFonts.poppins(
                            letterSpacing: 1,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        icon: Icon(
                          Icons.add,
                          size: 26,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          hapticFeedback(context, HapticType.Selection);
                          showModalBottomSheet<void>(
                            clipBehavior: Clip.antiAlias,
                            barrierColor: Colors.transparent,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
                            backgroundColor: Colors.transparent,
                            // backgroundColor:
                            //     Provider.of<ThemeProvider>(context, listen: false).isDarkMode
                            //         ? Color(0xff1d5c5c)
                            //         : Color(0xffddffff),
                            context: context,
                            builder: (BuildContext context) {
                              return passGeneratorScreen(
                                notifyParent: refreshPage,
                                form: PassGeneratorForm.CREATE,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class SlideAnimationRoute extends PageRouteBuilder{
  final Widget page;
  SlideAnimationRoute({required this.page}):super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: Duration(milliseconds: 100),
    reverseTransitionDuration: Duration(milliseconds: 100),
    transitionsBuilder: (context, animation, secondaryAnimation, page) => SlideTransition(
      position: Tween<Offset>(
        begin: Offset(-1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: page,
    ),
  );
}