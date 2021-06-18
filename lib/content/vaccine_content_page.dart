import 'package:corona_live/content/vaccine_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fl_chart/fl_chart.dart';

class VaccineContentPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant<VaccineClass>(
        builder: (context, child, model) =>
        Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),

                    // First container FOR Total Vacc, Parsed Latest Date, Total Fully Vacc and "Daily Vacc. values =================
                      Container(
                        height: 120,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            // First Row for Total Vacc and Parsed Latest Date =======================================
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text("Total Vacc."),
                                            Text(model.totalVac == null ? "": "${model.totalVac} People")
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text("Parsed Latest Date"),
                                            Text(model.parsedLatestDate == null ? "" : "${model.parsedLatestDate}")
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),


                            // Second Row for Total Fully Vacc and Daily Vacc ===========================================
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("Total Fully Vacc."),
                                      Text(model.totalFullyVac == null ? "" : "${model.totalFullyVac} people")
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("Daily Vacc."),
                                      Text(model.dailyVac == null ? "" : "${model.dailyVac} people"),
                                    ],
                                  )],
                              ),
                            )
                          ],
                        ),
                      ),


                    // Second Container For Graphs========================================
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: Colors.grey.shade500),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  // First Container for 1 to 4 Graphs Clickable Texts ===========================================
                                  Container(
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Flexible(
                                          child: RaisedButton(
                                            color: Colors.deepPurple,
                                            padding: EdgeInsets.symmetric(horizontal: 1),
                                            child: Text(
                                              "Graph1",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                color: Colors.white),
                                            ),
                                            onPressed: (){
                                              model.graph1();
                                            },
                                          ),
                                        ),

                                        SizedBox(width: 2,),
                                        Flexible(
                                          child: RaisedButton(
                                            padding: EdgeInsets.symmetric(horizontal: 1),
                                            color: Colors.deepPurple,
                                            child: Text(
                                              "Graph2",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            ),
                                            onPressed: (){
                                              model.graph2();
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 2,),
                                        Flexible(
                                          child: RaisedButton(
                                            padding: EdgeInsets.symmetric(horizontal: 1),
                                            color: Colors.deepPurple,
                                            child: Text(
                                              "Graph3",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                color: Colors.white),
                                            ),
                                            onPressed: (){
                                              model.graph3();
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 2,),
                                        Flexible(
                                          child: RaisedButton(
                                            color: Colors.deepPurple,
                                            padding: EdgeInsets.symmetric(horizontal: 1),
                                            child: Text(
                                              "Graph4",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            ),
                                            onPressed: (){
                                              model.graph4();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Divider(
                                    height: 8,
                                    color: Colors.grey.shade500,
                                    thickness: 2,
                                  ),

                                  //Container for displaying Graphs
                                  Expanded(
                                    flex: 2,
                                    child: model.vaccineGraphBody(),
                                    ),
                                ],
                              ),
                            ),
                          ),

                    // Third Container For Table ===========================================
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: Colors.grey.shade500),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // First Container for 1 to 4 Graphs
                                  Container(
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        RaisedButton(
                                          color: Colors.deepPurple,
                                          child: Text(
                                            "Country name",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white),
                                          ),
                                          onPressed: (){
                                            model.table1();
                                          },
                                        ),
                                        RaisedButton(
                                          color: Colors.deepPurple,
                                          child: Text(
                                            "Total vacc",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white),
                                          ),
                                          onPressed: (){
                                            model.table2();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 8,
                                    color: Colors.grey.shade500,
                                    thickness: 2,
                                  ),

                                  //Container for largest Graph1 ===========================================
                                  Expanded(
                                    flex: 2,
                                    child: model.vaccineTableBody(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
