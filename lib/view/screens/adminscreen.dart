import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:select_dialog/select_dialog.dart';
import '../../Services/get/division.dart';
import '../../app_constants/appconstants.dart';
import '../model/division_model.dart';
import '../model/firstname_model.dart';
import '../model/userdetail_model.dart';
import 'attendance_view.dart';
import 'description.dart';



class AdminScreenS extends StatefulWidget {
  const AdminScreenS({super.key});

  @override
  State<AdminScreenS> createState() => _AdminScreenSState();
}

class _AdminScreenSState extends State<AdminScreenS> {
  List<String> divisionNameList = [];
  List<String> tempdivisionNameList = [];
  List<Datum> firstNameList = [];
  List<Datum> tempfirstNameList = [];
  List<String> filteredList = [];

  final divisionNameController = TextEditingController();

  List<DatumValue> userDataList = [];
  List<DatumValue> tempuserDataList = [];

  String dateValue=" ";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDivisionList();

  }

  getDivisionList() {
    DivisionServices.getDivision(context).then(
      (value) {
        setState(
          () {
            divisionNameList =
                DivisionResponse.list.map((e) => e.division!).toList();
            tempdivisionNameList.addAll(divisionNameList);
            tempdivisionNameList.add("Other");
          },
        );
      },
    );
  }



  Future<List<Datum>> getFirstName(String division) async {
    firstNameList = await DivisionServices.getName(context, division);
    setState(() {
      tempfirstNameList.addAll(firstNameList);
    });
    return tempfirstNameList;
  }

  // Future<List<DatumValue>> getUserValue(String first_name) async {
  //   userDataList = await DivisionServices.getUserDetail(context, first_name);
  //   setState(() {
  //     tempuserDataList.addAll(userDataList);
  //   });
  //   return tempuserDataList;
  // }

  updatelist(String v){
    setState(() {
      tempfirstNameList = firstNameList.where((element) => element.toLowerCase().contains(v)).toList();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff9a8ec4),
          title: const Text(
            "view user info",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined, color: Colors.white),
            onPressed: () {
              AppConstants.pageTransition(context, AttendanceScreen());
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 60.0, bottom: 20.0),
                  child: TextField(
                    onChanged: (v) {
                      updatelist(v.toLowerCase());
                      //filterSearchResults(v);

                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: "Search",
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10.0),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            child: TextFormField(
                              style: const TextStyle(color: Color(0xff5e4f9c)),
                              controller: divisionNameController,
                              readOnly: true,
                              onTap: () {
                                SelectDialog.showModal<String>(
                                  context,
                                  label: "Select Division Name",
                                  searchBoxDecoration: const InputDecoration(
                                      hintText: 'Search...'),
                                  items: tempdivisionNameList,
                                  onChange: (String selected) async {
                                    setState(
                                      () {
                                        divisionNameController.text = selected;
                                        tempfirstNameList.clear();
                                        getFirstName(selected);
                                      },
                                    );
                                  },
                                );
                              },
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.all(15),
                                border: OutlineInputBorder(),
                                counterText: "",
                                hintText: "Select Division Name",
                                hintStyle: TextStyle(color: Color(0xff9a8ec4)),
                                suffixIcon: RotatedBox(
                                  quarterTurns: 1,
                                  child: Icon(
                                    Icons.navigate_next_outlined,
                                    color: Color(0xff5e4f9c),
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10,bottom: 30),
                    child: ListView.builder(
                        //scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: tempfirstNameList.length,
                        itemBuilder: (context, index) {
                          var list = tempfirstNameList[index];
                          return GestureDetector(
                            onTap: () {
                              String name = list.firstName.toString();
                              print(name);
                              // getUserValue(name);
                              // int n= tempuserDataList.length;
                              // for(int i = 0;i<n;i++){
                              //   dateValue = tempuserDataList[i].date_n;
                              //   print(dateValue);
                              // }

                              String division_name = divisionNameController.text;
                              String division_value = division_name.toString();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UserDescriptionPage(name,division_value)),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 15.0, left: 15.0, top: 20.0),
                              child: Card(
                                child: ListTile(
                                  title: Text(list.firstName),
                                ),
                              ),
                            ),
                          );
                        }
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}
