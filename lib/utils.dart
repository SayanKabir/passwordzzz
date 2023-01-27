import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pass_manager/model/sharedPrefs_handler.dart';
import 'package:pass_manager/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'passwordUnit.dart';
import 'package:provider/provider.dart';

import 'db/db_handler.dart';
import 'model/data_model.dart';

enum ListViewForm { MANAGER, SEARCH }
enum PassGeneratorForm { CREATE, MODIFY }
enum HapticType {Selection, Action}

Future<void> hapticFeedback(BuildContext context, HapticType type) async{

  bool? isHapticsEnabled;
  final prefs = await SharedPreferences.getInstance();
  isHapticsEnabled = prefs.getBool("isHapticsEnabled") ?? true;

  if(isHapticsEnabled){
    if(type==HapticType.Selection)
      await HapticFeedback.selectionClick();
    else
      await HapticFeedback.lightImpact();
  }
}

SnackBar mySnackbar(BuildContext context, String message) => SnackBar(
  elevation: 0,
  padding: EdgeInsets.all(20),
  width: MediaQuery.of(context).size.width * 0.021 * message.length,
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
  ),
  duration: Duration(milliseconds: 2000),
  backgroundColor: Colors.white.withOpacity(0.9),
  content: Text(
    message,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.black87,
    ),
  ),
);

List<Data> totalList = [];
List<Data> searchResult = [];
void getAllDataFromDB() async{
  final List datas = await DBHandler.dataBase.getData();
  for(var data in datas){
    Data newData = Data(id: data["id"],Site: data["site"].toString(), Username: data["user"].toString());
    totalList.add(newData);
  }
}
void updateSearchList(String query){
  searchResult = totalList.where((element) => element.Site.toLowerCase().contains(query.toLowerCase()) || element.Username.toLowerCase().contains(query.toLowerCase())).toList();
}

Widget getSearchOverlay(bool show, int _len){
  print("${totalList.length}");
  print("${searchResult.length}  $_len");
  if(show){
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          color: Colors.transparent,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 125, horizontal: 0),
            itemCount: _len,
            itemBuilder: (context, index){
              return PasswordUnit(
                notifyParent: (){},
                id: searchResult[index].id??-1,
                kSite: searchResult[index].Site,
                kUsername: searchResult[index].Username,
                form: ListViewForm.SEARCH,
              );
            },
          ),
        ),
      ),
    );
  }else{
    return SizedBox.shrink();
  }
}

class SearchStateProvider extends ChangeNotifier{
  int state = 0;
  int resLen = searchResult.length;
  SearchStateProvider();

  bool get isSearchShowing => state==1;
  int get getSearchResLen => resLen;

  void setSearchState(int _state){
    state = _state;
    notifyListeners();
  }
  void updateSearchResLen(){
    resLen = searchResult.length;
    notifyListeners();
  }
}

class SearchBar extends StatefulWidget {

  final double width;
  final TextEditingController textController;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final String helpText;
  final int animationDurationInMilli;
  final bool rtl;
  final bool autoFocus;
  final TextStyle? style;
  final bool closeSearchOnSuffixTap;
  final Color? color;
  final List<TextInputFormatter>? inputFormatters;

  const SearchBar({
    Key? key,
    required this.width,
    required this.textController,
    this.suffixIcon,
    this.prefixIcon,
    this.helpText = "Search...",
    this.color = Colors.white,
    this.animationDurationInMilli = 375,
    this.rtl = false,
    this.autoFocus = false,
    this.style,
    this.closeSearchOnSuffixTap = false,
    this.inputFormatters,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

///toggle - 0 => false or closed
///toggle 1 => true or open
int toggle = 0;

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  ///initializing the AnimationController
  late AnimationController _con;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _con = AnimationController(
      vsync: this,

      /// animationDurationInMilli is optional, the default value is 375
      duration: Duration(milliseconds: widget.animationDurationInMilli),
    );
  }

  // int get getSearchBarState => toggle;
  unfocusKeyboard() {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    var searchStateProvider = Provider.of<SearchStateProvider>(context);
    return Container(
      padding: EdgeInsets.only(top: 6),
      height: 100.0,

      ///if the rtl is true, search bar will be from right to left
      alignment: widget.rtl ? Alignment.centerRight : Alignment(-1.0, 0.0),

      ///Using Animated container to expand and shrink the widget
      child: AnimatedContainer(
        duration: Duration(milliseconds: widget.animationDurationInMilli),
        height: 48.0,
        width: (toggle == 0) ? 48.0 : widget.width,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          /// can add custom color or the color will be white
          color: widget.color,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Stack(
          children: [
            ///Using Animated Positioned widget to expand and shrink the widget
            AnimatedPositioned(
              duration: Duration(milliseconds: widget.animationDurationInMilli),
              top: 6.0,
              right: 7.0,
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: (toggle == 0) ? 0.0 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    /// can add custom color or the color will be white
                    color: widget.color,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: AnimatedBuilder(
                    child: GestureDetector(
                      onTap: () {
                        try {
                          ///trying to execute the onSuffixTap function
                          widget.textController.clear();
                          searchResult = [];
                          searchStateProvider.updateSearchResLen();

                          ///closeSearchOnSuffixTap will execute if it's true
                          if (widget.closeSearchOnSuffixTap) {
                            unfocusKeyboard();
                            setState(() {
                              toggle = 0;
                              searchStateProvider.setSearchState(toggle);
                            });
                          }
                        } catch (e) {
                          ///print the error if the try block fails
                          print(e);
                        }
                      },

                      ///suffixIcon is of type Icon
                      child: widget.suffixIcon != null
                          ? widget.suffixIcon
                          : Icon(
                        Icons.close,
                        size: 20.0,
                        color: widget.prefixIcon!.color,
                      ),
                    ),
                    builder: (context, widget) {
                      ///Using Transform.rotate to rotate the suffix icon when it gets expanded
                      return Transform.rotate(
                        angle: _con.value * 2.0 * pi,
                        child: widget,
                      );
                    },
                    animation: _con,
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: widget.animationDurationInMilli),
              left: (toggle == 0) ? 20.0 : 40.0,
              curve: Curves.easeOut,
              top: 11.0,

              ///Using Animated opacity to change the opacity of th textField while expanding
              child: AnimatedOpacity(
                opacity: (toggle == 0) ? 0.0 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  alignment: Alignment.topCenter,
                  width: widget.width / 1.7,
                  child: TextField(
                    ///Text Controller. you can manipulate the text inside this textField by calling this controller.
                    controller: widget.textController,
                    inputFormatters: widget.inputFormatters,
                    focusNode: focusNode,
                    cursorRadius: Radius.circular(10.0),
                    cursorWidth: 2.0,
                    onChanged: (value){
                      if(value=="")
                        searchResult = [];
                      else
                        updateSearchList(value);
                      searchStateProvider.updateSearchResLen();


                        // widget.callback();
                    },
                    onEditingComplete: () {
                      /// on editing complete the keyboard will be closed and the search bar will be closed
                      unfocusKeyboard();
                      // setState(() {
                      //   toggle = 0;
                      //   searchStateProvider.setSearchState(toggle);
                      // });
                    },

                    ///style is of type TextStyle, the default is just a color black
                    style: widget.style != null
                        ? widget.style
                        : TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(bottom: 5),
                      isDense: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: widget.helpText,
                      labelStyle: widget.style,
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            ///Using material widget here to get the ripple effect on the prefix icon
            Material(
              /// can add custom color or the color will be white
              color: widget.color,
              borderRadius: BorderRadius.circular(30.0),
              child: IconButton(
                iconSize: 28,
                splashRadius: 19.0,

                ///if toggle is 1, which means it's open. so show the back icon, which will close it.
                ///if the toggle is 0, which means it's closed, so tapping on it will expand the widget.
                ///prefixIcon is of type Icon
                icon: widget.prefixIcon != null
                    ? toggle == 1
                    ? Icon(Icons.arrow_back_ios, color: widget.prefixIcon!.color,)
                    : widget.prefixIcon!
                    : Icon(
                  toggle == 1 ? Icons.arrow_back_ios : Icons.search,
                  size: 28,
                ),
                onPressed: () {
                  setState(
                        () {
                      ///if the search bar is closed
                      if (toggle == 0) {
                        toggle = 1;
                        searchStateProvider.setSearchState(toggle);
                        getAllDataFromDB();
                        setState(() {
                          ///if the autoFocus is true, the keyboard will pop open, automatically
                          if (widget.autoFocus)
                            FocusScope.of(context).requestFocus(focusNode);
                        });

                        ///forward == expand
                        _con.forward();
                      } else {
                        ///if the search bar is expanded
                        widget.textController.clear();
                        totalList = [];
                        searchResult = [];
                        searchStateProvider.updateSearchResLen();
                        toggle = 0;
                        searchStateProvider.setSearchState(toggle);
                        ///if the autoFocus is true, the keyboard will close, automatically
                        setState(() {
                          if (widget.autoFocus) unfocusKeyboard();
                        });

                        ///reverse == close
                        _con.reverse();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
