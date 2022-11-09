import 'dart:convert';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mybook/pages/tambahdata/add.dart';

class Home extends StatefulWidget {
  static String routesName = '/home';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> name = [];
  bool isLoading = false;
  var deletionMsg = "";
  var username = "";
  @override
  void initState() {
    super.initState();
    setState(() {
      _getDataDB();
    });
  }

  Future _getDataDB() async {
    setState(() {
      isLoading = true;
    });
    var baseURL = "http://10.0.2.2:3400/gettasks";

    try {
      var result = await http.post(
        Uri.parse(baseURL),
      );
      if (result.statusCode == 200) {
        var val = jsonDecode(result.body);

        setState(() {
          if (val == "tasks not found!") {
            name = [];
          } else {
            name = val['data'];
          }
        });
      }
    } catch (e) {
      Future.error(e);
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<String?> _delete(context) async {
    setState(() {
      isLoading = true;
    });
    var baseURL = "http://10.0.2.2:3400/deletetask";
    try {
      var result = await http.post(Uri.parse(baseURL),
          body: jsonEncode({
            "id": context,
          }),
          headers: {"content-type": "application/json"});
      setState(() {
        deletionMsg = result.body;
      });
      await _getDataDB();
      return deletionMsg;
    } catch (e) {
      Future.error(e);
      print("Exception Delete :$e");
    }
    setState(() {
      isLoading = false;
    });
    return deletionMsg;
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    setState(() {
      if (arguments.isEmpty) {
        username = "Kelash";
      } else {
        username = arguments['username'];
      }
    });
    return Scaffold(
        bottomNavigationBar: ConvexButton.fab(
          onTap: () {
            Navigator.pushReplacementNamed(context, Add.routesName);
          },
          icon: Icons.add,
          color: Colors.white,
          backgroundColor: Colors.purple,
          top: 50,
          thickness: 7,
        ),
        body: LoadingOverlay(
          isLoading: isLoading,
          progressIndicator: SpinKitChasingDots(
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.purple : Colors.amber,
                ),
              );
            },
          ),
          child: !isLoading
              ? viewDB()
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Loading...",
                        style: GoogleFonts.montserrat(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }

  viewDB() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.only(right: 10.0, top: 10),
              width: 120,
              child: Column(children: [
                const Align(
                  alignment: Alignment.centerRight,
                  child: CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Hi,${username.replaceAll(' ', '')}",
                  style: const TextStyle(fontSize: 20),
                )
              ]),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.07,
            ),
            child: Text(
              "To Do List",
              style: GoogleFonts.montserrat(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: !isLoading && name.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No Data Available!",
                          style: GoogleFonts.montserrat(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                    ),
                    child: ListView.builder(
                      itemCount: name.length,
                      // shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                name[index]['name'],
                                style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                ),
                              ),
                              trailing: GestureDetector(
                                onTap: () async {
                                  final msg = await _delete(name[index]['_id']);
                                  if (msg != null) {
                                    showDialog(
                                        context: this.context,
                                        builder: (BuildContext context) {
                                          Future.delayed(
                                              Duration(milliseconds: 1500), () {
                                            Navigator.pop(context);
                                          });
                                          return Container(
                                            width: 100,
                                            height: 200,
                                            margin: EdgeInsets.symmetric(
                                              vertical: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.38,
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.purple,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Center(
                                                child: Text(
                                                  msg,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                },
                                child: Text(
                                  "Delete",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
