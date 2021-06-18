import 'package:corona_live/content/vaccine_class.dart';
import 'package:corona_live/content/vaccine_content_page.dart';
import 'package:corona_live/models/scoped_model.dart';
import 'package:corona_live/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'navigation_page.dart';


class VaccinePage extends StatelessWidget {
  final String username;
  const VaccinePage({Key key, this.username}) : super(key: key);
  static final VaccineClass vaccineClass = VaccineClass();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ScopedModelDescendant<VaccineClass>(
        builder: (context, child, model) =>
       model.selectedBody == vaccineMainBody.off ? ProgressIndicatorWidget() : Container(
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

                      // First Row for Cases and Deaths ==================================
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RaisedButton(
                                color: Colors.deepPurple,
                                  child: Text("Vaccine", style: TextStyle(color: Colors.white),),
                                onPressed: () async{
                                  model.offVaccineBody();
                                  await model.getData();
                                  model.onVaccineBody();
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => VaccineContentPage()),
                                  );
                                },
                              ),
                              Text("Page", style: TextStyle(color: Colors.deepPurpleAccent),),
                            ],
                          ),
                        ),

                      // Second Row for Content and Page ===========================================
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Contents", style: TextStyle(color: Colors.deepPurpleAccent),),
                            Text("Will be field", style: TextStyle(color: Colors.deepPurpleAccent),)],
                        ),
                      )
                    ],
                  ),
                ),

                // Second Container For Graphs ======================================
                ScopedModelDescendant<MyModel>(
                  builder: (context, child, model) =>
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

                          // First Container for 1 to 4 Graphs Clickable Texts===========================================
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
                                  onTap: (){
                                    model.vaccineGraph1();
                                  },
                                ),

                                GestureDetector(
                                  child: Text(
                                    "Graph2",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.deepPurpleAccent),
                                  ),
                                  onTap: (){
                                    model.vaccineGraph2();
                                  },
                                ),

                                GestureDetector(
                                  child: Text(
                                    "Graph3",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.deepPurpleAccent),
                                  ),
                                  onTap: (){
                                    model.vaccineGraph3();
                                  },
                                ),

                                GestureDetector(
                                  child: Text(
                                    "Graph4",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.deepPurpleAccent),
                                  ),
                                  onTap: (){
                                    model.vaccineGraph4();
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

                          //Container for Graph Text Display ============================
                          Expanded(
                            flex: 2,
                            child: model.vaccineGraphBody(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Third Container For Table ===========================================
                ScopedModelDescendant<MyModel>(
                  builder: (context, child, model) =>
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

                          // First Container Table1 and Table2 Texts=========================
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
                                  onTap: (){
                                    model.vaccineTable1();
                                  },
                                ),

                                GestureDetector(
                                  child: Text(
                                    "Table2",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.deepPurpleAccent),
                                  ),
                                  onTap: (){
                                    model.vaccineTable2();
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

                          //Container for Table Text Display ===========================================
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  // First Row for table1 and contents ===========================================
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      model.vaccineTableBody(),
                                      Text("Contents"),
                                    ],
                                  ),

                                  // Second Row for Will be and Filed Texts =================================
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("will be"),
                                      Text("filed"),
                                    ],
                                  ),

                                  // Third Row for ---- ===========================================
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("..."),
                                      Text("..."),
                                    ],
                                  ),

                                  // Last Row for ---- ============================================
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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


      floatingActionButton: ScopedModelDescendant<VaccineClass>(
          builder: (context, child, model) =>
          FloatingActionButton(
          child: Icon(Icons.list),
          backgroundColor: Colors.deepPurple,
          onPressed: (){
            if (model.selectedBody == vaccineMainBody.on){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavigationPage(username: username, pageName: "Vaccine Page",)));
            }else{

            }
          },
        ),
      ),


    );
  }
}
