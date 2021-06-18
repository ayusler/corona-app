import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


import 'cases_death_class.dart';

class CasesDeathContentPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant<CasesDeathClass>(
        builder: (context, child, model) =>
            Container(
              child: Column(
                children: [

                  SizedBox(
                    height: 15,
                  ),

                  // First container for Total Cases, Parsed Latest Date, Total Deaths and Daily Cases. ===========================
                  Container(
                    height: 120,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        // First Row for Total Cases and Parsed Latest Date =======================================
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Total Cases."),
                                  Text(model.totalCases == null ? "": "${model.totalCases} people")
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


                        // Second Row for Total Deaths and Daily Cases ===========================================
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Total Deaths"),
                                  Text(model.totalDeath == null ? "" : "${model.totalDeath} people")
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Daily Cases."),
                                  Text(model.dailyCases == null ? "" : "${model.dailyCases} people"),
                                ],
                              )],
                          ),
                        )
                      ],
                    ),
                  ),

                  // Second Container For Graphs Aspect ===============================
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

                          // First Container for 1 to 4 Graphs selectors ===========================================
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
                                    color: Colors.deepPurple,
                                    padding: EdgeInsets.symmetric(horizontal: 1),
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
                                    padding: EdgeInsets.symmetric(horizontal: 1),
                                    color: Colors.deepPurple,
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

                          //Container to display Graphs ==================================
                          Expanded(
                            flex: 2,
                            child: model.casesDeathGraphBody(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Third Container For Table Aspect ===========================================
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

                          // First Container for Total Cases and Total Deaths text
                          Container(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                RaisedButton(
                                  color: Colors.deepPurple,
                                  child: Text(
                                    "Total Cases",
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
                                    "Total Deaths",
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

                          //Container for Graph Contents ===========================================
                          Expanded(
                            flex: 2,
                            child: model.casesDeathsTableBody(context),

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
