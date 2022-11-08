import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mybook/pages/tambahdata/add.dart';

class Home extends StatefulWidget {
  static String routesName = '/home';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> name = [];
  var deletionMsg = "";
  @override
  void initState() {
    super.initState();
    setState(() {
      _getDataDB();
    });
  }

  Future _getDataDB() async {
    var baseURL = "http://10.0.2.2:3400/gettasks";
    try {
      var result = await http.post(
        Uri.parse(baseURL),
      );
      if (result.statusCode == 200) {
        var val = jsonDecode(result.body);

        setState(() {
          name = val['data'];
        });
      }
    } catch (e) {
      Future.error(e);
    }
  }

  Future _delete(context) async {
    var baseURL = "http://10.0.2.2:3400/deletetask";
    try {
      var result = await http.post(Uri.parse(baseURL),
          body: jsonEncode({
            "id": context,
          }),
          headers: {"content-type": "application/json"});

      setState(() {
        _getDataDB();
        deletionMsg = jsonDecode(result.body);
      });
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: name.isNotEmpty
          ? viewDB()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No Data Available",
                    style: GoogleFonts.montserrat(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  viewDB() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.3,
            ),
            child: Text(
              "To Do List",
              style: GoogleFonts.montserrat(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
            ),
            child: ListView.builder(
              itemCount: name.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Text(
                      name[index]['name'],
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        _delete(name[index]['_id']);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Container(
                                  width: 100,
                                  height: 200,
                                  color: Colors.orange,
                                  child: Center(
                                    child: Text(
                                      deletionMsg,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
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
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, Add.routesName);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              fixedSize: const Size(50, 50),
              shadowColor: Colors.transparent,
              backgroundColor: const Color(0xFF80489C),
            ),
            child: const Icon(
              IconData(
                0xe047,
                fontFamily: 'MaterialIcons',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
