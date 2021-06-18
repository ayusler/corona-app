import 'package:corona_live/content/cases_death_class.dart';
import 'package:corona_live/content/cases_death_content_page.dart';
import 'package:corona_live/models/scoped_model.dart';
import 'package:corona_live/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'navigation_page.dart';

class CasesDeathsPage extends StatelessWidget {
  final String username;
  const CasesDeathsPage({Key key, this.username}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ScopedModelDescendant<CasesDeathClass>(
        builder: (context, child, model) =>
    model.selectedBody == casesDeathMainBody.off ? ProgressIndicatorWidget() :
        Container(
          child: Column(
            children: [

              SizedBox(
                height: 70,
              ),

              Container(
                height: 70,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey.shade500),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [

                    // First Row for Cases and Deaths ==============================
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RaisedButton(
                              color: Colors.deepPurple,
                              child: Text("Cases/Deaths", style: TextStyle(color: Colors.white),),
                              onPressed: () async{
                                model.offCasesDeathsBody();
                                await model.getData();
                                model.onCasesDeathsBody();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CasesDeathContentPage()));
                              },
                            ),
                            Text("Page", style: TextStyle(color: Colors.deepPurpleAccent),)
                          ],
                        ),
                      ),


                    // Second Row for Content and Page ===========================================
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Contents", style: TextStyle(color: Colors.deepPurpleAccent),),
                          Text("Will be field", style: TextStyle(color: Colors.deepPurpleAccent),)
                        ],
                      ),
                    )
                  ],
                ),
              ),

              // Second Container For Graphs ========================================
              ScopedModelDescendant<MyModel>(
                builder: (context, child, model) => Expanded(
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

                        // First Container for 1 to 4 Graphs ===========================================
                        Container(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [

                              GestureDetector(
                                child: Text(
                                  "Graph1",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.deepPurpleAccent),
                                ),
                                onTap: () {
                                  model.graph1();
                                },
                              ),

                              GestureDetector(
                                child: Text(
                                  "Graph2",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.deepPurpleAccent),
                                ),
                                onTap: () {
                                  model.graph2();
                                },
                              ),

                              GestureDetector(
                                child: Text(
                                  "Graph3",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.deepPurpleAccent),
                                ),
                                onTap: () {
                                  model.graph3();
                                },
                              ),

                              GestureDetector(
                                child: Text(
                                  "Graph4",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.deepPurpleAccent),
                                ),
                                onTap: () {
                                  model.graph4();
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

                        //Container for Graph Text Display
                        Expanded(
                          flex: 2,
                          child: model.casesDeathGraphBody(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              // Third Container For Table ===========================================
              ScopedModelDescendant<MyModel>(
                builder: (context, child, model) => Expanded(
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
                              GestureDetector(
                                child: Text(
                                  "Table1",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.deepPurpleAccent),
                                ),
                                onTap: () {
                                  model.table1();
                                },
                              ),

                              GestureDetector(
                                child: Text(
                                  "Table2",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.deepPurpleAccent),
                                ),
                                onTap: () {
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

                        //Container for  Graph Text Display ===========================================
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                // First Row for table1 and contents ===========================================
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    model.casesDeathTableBody(),
                                    Text("Contents"),
                                  ],
                                ),

                                // Second Row for Will be and Filed ===============================
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("will be"),
                                    Text("filed"),
                                  ],
                                ),

                                // Third Row for ---- Text ===========================================
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("..."),
                                    Text("..."),
                                  ],
                                ),

                                // Last Row for ---- ============================================
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("..."),
                                    Text("..."),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),


      floatingActionButton: ScopedModelDescendant<CasesDeathClass>(
          builder: (context, child, model) =>
        FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.list),
          onPressed: () {
            if(model.selectedBody == casesDeathMainBody.on){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavigationPage(username: username, pageName: "Cases/Deaths Page",)));
            }else{

            }
          },
        ),
      ),


    );
  }
}
