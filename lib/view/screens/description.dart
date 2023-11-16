import 'package:attendence_geofence/view/screens/adminscreen.dart';
import 'package:flutter/material.dart';
import 'package:select_dialog/select_dialog.dart';
import '../../Services/get/division.dart';
import '../../app_constants/appconstants.dart';
import '../model/month_Model.dart';
import '../model/userdetail_model.dart';
import '../model/date_model.dart';
import '../model/firstname_model.dart';

class UserDescriptionPage extends StatefulWidget {
  final String name;
  final String division_value;
  //final String date;
  UserDescriptionPage(this.name, this.division_value,{super.key});
 // UserDescriptionPage(this.name, this.division_value, this.date, {super.key});


  @override
  State<UserDescriptionPage> createState() => _UserDescriptionPageState();
}

class _UserDescriptionPageState extends State<UserDescriptionPage> {
  List<String> dateList = [];
  List<String> tempdateList = [];
  List<FirstNameModel> firstNameList = [];
  List<FirstNameModel> tempfirstNameList = [];

  List<DatumValue> userDataList = [];
  List<DatumValue> tempuserDataList = [];

  final dateController = TextEditingController();
  final NameController = TextEditingController();
  List<String> monthNameList = [];
  List<String> tempmonthNameList = [];
  final monthNameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMonthList();
    //getUSerDetailValue();
  }

  getMonthList() {
    DivisionServices.getMonthList(context).then(
          (value) {
        setState(
              () {
                monthNameList =
                MonthResponse.list.map((e) => e.month!).toList();
                tempmonthNameList.addAll(monthNameList);
                tempmonthNameList.add("Other");
          },
        );
      },
    );
  }

  getUSerDetailValue() {
    //print(widget.name);
    //print(monthNameController.text);
    //getUserValue(widget.name,monthNameController.text);
  }

  getDateList() {
    DivisionServices.getDate(context).then(
      (value) {
        setState(
          () {
            dateList = DateResponse.list.map((e) => e.month!).toList();
            tempdateList.addAll(dateList);
          },
        );
      },
    );
  }

  Future<List<DatumValue>> getUserValue(String first_name,String month) async {
    userDataList = await DivisionServices.getUserDetail(context,first_name,month);
    setState(() {
      tempuserDataList.addAll(userDataList);
    });
    return tempuserDataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff9a8ec4),
        title: Text(
          "Employee Name : " + widget.name,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined, color: Colors.white),
          onPressed: () {
            AppConstants.pageTransition(context, const AdminScreenS());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 30),
              child: Text(
                "Division Name : " + widget.division_value,
                style: TextStyle(fontSize: 15, color: Color(0xff5e4f9c)),
              ),
            ),
            // Padding(
            //   padding:
            //       const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
            //   child: Container(
            //     padding: const EdgeInsets.all(5.0),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(5),
            //       color: Colors.white,
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const Text(
            //           "  Select Month",
            //           style: TextStyle(fontSize: 15, color: Color(0xff5e4f9c)),
            //         ),
            //         const SizedBox(height: 10),
            //         Container(
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(12),
            //             color: Colors.grey.withOpacity(0.1),
            //           ),
            //           child: TextFormField(
            //             style: const TextStyle(color: Color(0xff5e4f9c)),
            //             controller: dateController,
            //             readOnly: true,
            //             onTap: () {
            //               SelectDialog.showModal<String>(
            //                 context,
            //                 label: "Select Month",
            //                 searchBoxDecoration:
            //                     const InputDecoration(hintText: 'Search...'),
            //                 items: tempdateList,
            //                 onChange: (String selected) async {
            //                   setState(
            //                     () {
            //                       dateController.text = selected;
            //                       //getFirstName(selected);
            //                     },
            //                   );
            //                 },
            //               );
            //             },
            //             decoration: const InputDecoration(
            //               fillColor: Colors.white,
            //               contentPadding: EdgeInsets.all(15),
            //               border: OutlineInputBorder(),
            //               counterText: "",
            //               hintText: "Select Month",
            //               hintStyle: TextStyle(color: Color(0xff9a8ec4)),
            //               suffixIcon: RotatedBox(
            //                 quarterTurns: 1,
            //                 child: Icon(
            //                   Icons.navigate_next_outlined,
            //                   color: Color(0xff5e4f9c),
            //                   size: 18,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 25,right: 25),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.withOpacity(0.1),
                ),
                child: TextFormField(
                  style: const TextStyle(color: Color(0xff5e4f9c)),
                  controller: monthNameController,
                  readOnly: true,
                  onTap: () {
                    SelectDialog.showModal<String>(
                      context,
                      label: "Select Month",
                      searchBoxDecoration: const InputDecoration(
                          hintText: 'Search...'),
                      items: tempmonthNameList,
                      onChange: (String selected) async {
                        setState(
                              () {
                                monthNameController.text = selected;
                                getUserValue(widget.name,monthNameController.text);
                                //tempmonthNameList.clear();
                                tempuserDataList.clear();

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
                    hintText: "Select Month",
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
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                height: 50,
                width: 370,
                color: Color(0xff9a8ec4),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text( "  Date",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: 100),
                    Text("Time",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 45),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Text("Attendance",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)
                      ),
                    )
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),

                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: tempuserDataList!.length,
                    itemBuilder: (context, index) {
                      var list = tempuserDataList[index];
                      return GestureDetector(
                        child: Card(
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                style: TextStyle(
                                  color: Color(0xff5e4f9c)
                                ),
                                list.date_n +
                                  "            " +
                                   list.time_n
                                +
                                  "         " +
                                  list.present
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TableRow(
//     decoration: BoxDecoration(color: Colors.deepPurple),
//     children: [
//       TableCell(
//         verticalAlignment:
//             TableCellVerticalAlignment.middle,
//         child: Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Center(
//             child: Text(
//               'Date',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontStyle: FontStyle.italic),
//             ),
//           ),
//         ),
//       ),
//       TableCell(
//         verticalAlignment:
//             TableCellVerticalAlignment.middle,
//         child: Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Center(
//             child: Text(
//               'Time',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontStyle: FontStyle.italic),
//             ),
//           ),
//         ),
//       ),
//       TableCell(
//         verticalAlignment:
//             TableCellVerticalAlignment.middle,
//         child: Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Center(
//             child: Text(
//               'Attendance',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontStyle: FontStyle.italic),
//             ),
//           ),
//         ),
//       ),
//     ]),
// ...List.generate(
//     20,
//     (index) => TableRow(children: [
//           TableCell(
//             verticalAlignment:
//                 TableCellVerticalAlignment.middle,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//                 child: Text(
//                   "Cell 1",
//                   style: TextStyle(
//                       color: Color(0xff5e4f9c),
//                       fontSize: 18,
//                       fontStyle: FontStyle.normal),
//                 ),
//               ),
//             ),
//           ),
//           TableCell(
//             verticalAlignment:
//                 TableCellVerticalAlignment.middle,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//                 child: Text(
//                   "Cell 2",
//                   style: TextStyle(
//                       color: Color(0xff5e4f9c),
//                       fontSize: 18,
//                       fontStyle: FontStyle.normal),
//                 ),
//               ),
//             ),
//           ),
//           TableCell(
//             verticalAlignment:
//                 TableCellVerticalAlignment.middle,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//                 child: Text(
//                   "Cell 3",
//                   style: TextStyle(
//                       color: Color(0xff5e4f9c),
//                       fontSize: 18,
//                       fontStyle: FontStyle.normal),
//                 ),
//               ),
//             ),
//           ),
//         ],
//     ),
// ),
