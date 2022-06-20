import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taboo/models/db_helper.dart';
import 'package:taboo/models/Settings.dart';
import 'package:taboo/screens/main_menu_screen.dart';

main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
  DBHelper.init().then((value) async {
    await DBHelper.openDB();
  });
  Settings.init();
}

class MyApp extends StatelessWidget {
  static const Color primaryColor = Color(0xFFFFC400);
  static const Color secondaryColor = Color(0xFFFFC400);
  static const Color disabledColor = Color(0xFFFFE082);
  static const Color disabledTextColor = Color(0xFFDDDDDD);
  static const Color colorOnPrimary = Color(0xFF222222);
  static const Color colorOnSecondary = Color(0xFF222222);
  static const Color backgroundColor = Color(0xFFE6E6E6);
  static const Color colorOnBackground = Color(0xFF222222);
  static const double elevatedButtonHeight = 50;

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.disabled,
      };
      if (states.any(interactiveStates.contains)) {
        return disabledColor;
      }
      return secondaryColor;
    }

    Color getForegroundColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.disabled,
      };
      if (states.any(interactiveStates.contains)) {
        return disabledTextColor;
      }
      return colorOnPrimary;
    }

    return MaterialApp(
      title: "Taboo",
      theme: ThemeData(
        // brightness: ,
        // visualDensity: ,
        // primarySwatch: ,
        primaryColor: primaryColor,
        // primaryColorBrightness: ,
        // primaryColorLight: ,
        // primaryColorDark: ,
        // accentColor: ,
        // accentColorBrightness: ,
        // canvasColor: ,
        // shadowColor: ,
        scaffoldBackgroundColor: backgroundColor,
        // bottomAppBarColor: ,
        cardColor: primaryColor,
        // dividerColor: ,
        // focusColor: ,
        // hoverColor: ,
        // highlightColor: ,
        // splashColor: ,
        // splashFactory: ,
        // selectedRowColor: ,
        // unselectedWidgetColor: ,
        // disabledColor: ,
        // buttonColor: ,
        // buttonTheme: ,
        // toggleButtonsTheme: ,
        // secondaryHeaderColor: ,
        // backgroundColor: ,
        // dialogBackgroundColor: ,
        // indicatorColor: ,
        // hintColor: ,
        // errorColor: ,
        // toggleableActiveColor: ,
        fontFamily: "SouthAtlanta",
        textTheme: TextTheme(
          // headline1: ,
          // headline2: ,
          // headline3: ,
          // headline4: ,
          // headline5: ,
          // headline6: ,
          // subtitle1: ,
          // subtitle2: ,
          // bodyText1: ,
          bodyText2: TextStyle(
            color: colorOnBackground,
            fontSize: 32,
          ),
          // caption: ,
          // button: ,
        ),
        // primaryTextTheme: ,
        // accentTextTheme: ,
        // inputDecorationTheme: ,
        iconTheme: IconThemeData(
          color: primaryColor,
          size: 32,
        ),
        // primaryIconTheme: ,
        // accentIconTheme: ,
        // sliderTheme: ,
        // tabBarTheme: ,
        // tooltipTheme: ,
        // cardTheme: ,
        // chipTheme: ,
        // platform: ,
        // materialTapTargetSize: ,
        // applyElevationOverlayColor: ,
        // pageTransitionsTheme: ,
        // appBarTheme: ,
        // scrollbarTheme: ,
        // bottomAppBarTheme: ,
        colorScheme: ColorScheme(
          primary: primaryColor,
          background: backgroundColor,
          onPrimary: colorOnPrimary,
          onSecondary: colorOnSecondary,
          onSurface: colorOnBackground,
          primaryVariant: primaryColor,
          secondary: secondaryColor,
          brightness: Brightness.light,
          error: disabledColor,
          onBackground: colorOnBackground,
          onError: disabledColor,
          secondaryVariant: secondaryColor,
          surface: backgroundColor,
        ),
        // dialogTheme: ,
        // floatingActionButtonTheme: ,
        // navigationRailTheme: ,
        // typography: ,
        // cupertinoOverrideTheme: ,
        // snackBarTheme: ,
        // bottomSheetTheme: ,
        // popupMenuTheme: ,
        // bannerTheme: ,
        // dividerTheme: ,
        // buttonBarTheme: ,
        // bottomNavigationBarTheme: ,
        // timePickerTheme: ,
        // textButtonTheme: ,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith(getBackgroundColor),
              foregroundColor:
                  MaterialStateProperty.resolveWith(getForegroundColor),
              minimumSize:
                  MaterialStateProperty.all(Size(120, elevatedButtonHeight)),
              textStyle: MaterialStateProperty.all(
                TextStyle(
                  fontSize: 18,
                  fontFamily: "SouthAtlanta",
                ),
              )),
        ),
        // outlinedButtonTheme: ,
        // textSelectionTheme: ,
        // dataTableTheme: ,
        // checkboxTheme: ,
        // radioTheme: ,
        // switchTheme: ,
        // fixTextFieldOutlineLabel: ,
      ),
      home: MainMenuScreen(),
    );
  }
}
