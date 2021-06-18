import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

enum casesDeathGraphs {graph1, graph2, graph3, graph4}
enum casesDeathTables {totalCasesTableEnum, totalDeathTableEnum, defaultTable}
enum casesDeathMainBody {on, off}
class CasesDeathClass extends Model {

  casesDeathGraphs selectedVaccineGraph = casesDeathGraphs.graph1;
  casesDeathTables selectedTable = casesDeathTables.defaultTable;
  casesDeathMainBody selectedBody = casesDeathMainBody.on;

  String parsedLatestDate;
  int totalCases;
  int totalDeath;
  int dailyCases;

  List twentyEightDaysXAxisDateList = [];
  List twentyEightDaysDateList = [];

  List sevenDaysDateList = [];
  List sevenDaysXAxisDateList = [];

  List sevenDaysTotalCasesValuesList = [];
  List sevenDaysDailyCasesValuesList = [];

  List twentyEightDaysTotalCasesValuesList = [];
  List twentyEightDaysDailyCasesValuesList = [];

  List totalCasesTableDataList = [];
  List totalDeathTableDataList = [];


  Future <void> getData() async {
    try {

      // Make request from 'https://covid.ourworldindata.org/data/owid-covid-data.json

      Response response = await get('https://covid.ourworldindata.org/data/owid-covid-data.json');
      var decodedData = jsonDecode(response.body);

      // Retrieving parsed Latest date for South Korea ====================================
      for (var document in decodedData.entries){
        if (document.key == "KOR"){
          for (var x in document.value.entries){
            if (x.key == "data"){
              for (int n =0; n <= x.value.length-1; n++){
                if (n == x.value.length-1){
                  parsedLatestDate = x.value[n]["date"];
                }
              }
            }
          }
          break;
        }
      }

      // Calculating Total Cases. World Total Cases ====================================
      double tcAnswer = 0;
      for (var document in decodedData.entries){
        for (var x in document.value.entries){
          if (x.key == "data"){
            for (int n = 0; n <= x.value.length-1; n++){
              if (x.value[n]["date"]==parsedLatestDate){
                if (x.value[n]["total_cases"] != null){
                  tcAnswer += x.value[n]["total_cases"];

                }else{

                //  Use date prior parse Latest Date =================================
                  // Retrieving Date prior parse latest Date =========================
                  var date = DateFormat("yyyy-MM-dd").parse(parsedLatestDate);
                  var newDate = DateTime(date.year, date.month, date.day-1);
                  var finalDate = DateFormat("yyyy-MM-dd").format(newDate).toString();

                  if (x.value[n-1]["date"]==finalDate){
                    if (x.value[n-1]["total_cases"] != null){
                      tcAnswer += x.value[n-1]["total_cases"];
                    }
                  }
                }

                // Use latest updated Date =================================
              }else if (x.value[n]["date"] != parsedLatestDate && n == x.value.length-1){
                if (x.value[n]["total_cases"]!=null){
                  tcAnswer += x.value[n]["total_cases"];
                }
              }
            }
          }
        }

      }
      totalCases = tcAnswer.toInt();


      // Calculating Total Death. ======================================
      double tdAnswer = 0;
      for (var document in decodedData.entries){
        for (var x in document.value.entries){
          if (x.key == "data"){
            for (int n = 0; n <= x.value.length-1; n++){
              if (x.value[n]["date"]==parsedLatestDate){
                if (x.value[n]["total_deaths"] != null){
                  tdAnswer += x.value[n]["total_deaths"];

                }else{

                  //  Use date prior parse Latest Date =================================
                  // Retrieving Date prior parse latest Date ===========================
                  var date = DateFormat("yyyy-MM-dd").parse(parsedLatestDate);
                  var newDate = DateTime(date.year, date.month, date.day-1);
                  var finalDate = DateFormat("yyyy-MM-dd").format(newDate).toString();

                  if (x.value[n-1]["date"]==finalDate){
                    if (x.value[n-1]["total_deaths"] != null){
                      tdAnswer += x.value[n-1]["total_deaths"];
                    }
                  }
                }

                // Use latest updated Date =======================================

              }else if (x.value[n]["date"] != parsedLatestDate && n == x.value.length-1){
                if (x.value[n]["total_deaths"]!=null){
                  tdAnswer += x.value[n]["total_deaths"];
                }
              }
            }
          }
        }

      }
      totalDeath = tdAnswer.toInt();


      // Calculating Daily Cases. =======================================
      double dcAnswer = 0;
      for (var document in decodedData.entries){
        for (var x in document.value.entries){
          if (x.key == "data"){
            for (int n = 0; n <= x.value.length-1; n++){
              if (x.value[n]["date"]==parsedLatestDate){
                if (x.value[n]["new_cases"] != null){
                  dcAnswer += x.value[n]["new_cases"];

                }else{
                  //  Use date prior parse Latest Date
                  // Retrieving Date prior parse latest Date
                  var date = DateFormat("yyyy-MM-dd").parse(parsedLatestDate);
                  var newDate = DateTime(date.year, date.month, date.day-1);
                  var finalDate = DateFormat("yyyy-MM-dd").format(newDate).toString();

                  if (x.value[n-1]["date"]==finalDate){
                    if (x.value[n-1]["new_cases"] != null){
                      dcAnswer += x.value[n-1]["new_cases"];
                    }
                  }
                }

                // Use latest updated Date
              }else if (x.value[n]["date"] != parsedLatestDate && n == x.value.length-1){
                if (x.value[n]["new_cases"]!=null){
                  dcAnswer += x.value[n]["new_cases"];
                }
              }
            }
          }
        }

      }
      dailyCases = dcAnswer.toInt();


      // Extracting 7 days From parsed latest date =============================================
      var initialDate = DateFormat("yyyy-MM-dd").parse(parsedLatestDate);
      for (int d=0; d<=6; d++){
        var  formattedDate = DateTime(initialDate.year, initialDate.month, initialDate.day-d);
        var newDateValue1 = DateFormat("yyyy-MM-dd").format(formattedDate).toString().replaceFirst("2021-", "");
        var newDateValue2 = DateFormat("yyyy-MM-dd").format(formattedDate).toString();
        sevenDaysXAxisDateList.add(newDateValue1);
        sevenDaysDateList.add(newDateValue2);
      }


      //Calculating total cases for seven days, each date from parse latest date excluding parse latest date.
      // Parse latest date value is not calculated because it is already known which is value stored in totalCases variable
      for (int day=1; day <=6; day ++){
        double adder = 0;
        for (var document in decodedData.entries){
          for (var x in document.value.entries){
            if (x.key == "data"){
              for (int n = 0; n <= x.value.length-1; n++){
                if (x.value[n]["date"]==sevenDaysDateList[day]){
                  if (x.value[n]["total_cases"] != null) {
                    adder += x.value[n]["total_cases"];
                  }
                }
              }
            }
          }
        }
        sevenDaysTotalCasesValuesList.add(adder.toInt());
      }


      //Calculating Daily cases for seven days, each date from parse latest date excluding parse latest date.
      // Parse latest date value is not calculated because it is already known which is value stored in dailyCases variable
      for (int day=1; day <=6; day ++){
        double adder2 = 0;
        for (var document in decodedData.entries){
          for (var x in document.value.entries){
            if (x.key == "data"){
              for (int n = 0; n <= x.value.length-1; n++){
                if (x.value[n]["date"]==sevenDaysDateList[day]){
                  if (x.value[n]["new_cases"] != null) {
                    adder2 += x.value[n]["new_cases"];
                  }
                }
              }
            }
          }
        }
        sevenDaysDailyCasesValuesList.add(adder2.toInt());
      }


      // Extracting 28 days From parsed latest date =============================================
      var defaultDate = DateFormat("yyyy-MM-dd").parse(parsedLatestDate);
      for (int d=0; d<=27; d++){
        var  formattedDate = DateTime(defaultDate.year, defaultDate.month, defaultDate.day-d);
        var newDateValue1 = DateFormat("yyyy-MM-dd").format(formattedDate).toString().replaceFirst("2021-", "");
        var newDateValue2 = DateFormat("yyyy-MM-dd").format(formattedDate).toString();
        twentyEightDaysXAxisDateList.add(newDateValue1);
        twentyEightDaysDateList.add(newDateValue2);
      }

      //Calculating total cases for 28 days, each date from parse latest date excluding parse latest date.
      // Parse latest date value is not calculated because it is already known which is value stored in totalCases variable
      for (int day=1; day <=27; day ++){
        double adder3 = 0;
        for (var document in decodedData.entries){
          for (var x in document.value.entries){
            if (x.key == "data"){
              for (int n = 0; n <= x.value.length-1; n++){
                if (x.value[n]["date"]==twentyEightDaysDateList[day]){
                  if (x.value[n]["total_cases"] != null) {
                    adder3 += x.value[n]["total_cases"];
                  }
                }
              }
            }
          }
        }
        twentyEightDaysTotalCasesValuesList.add(adder3.toInt());
      }


      //Calculating Daily cases for 28 days, each date from parse latest date excluding parse latest date.
      // Parse latest date value is not calculated because it is already known which is value stored in dailyCases variable
      for (int day=1; day <=27; day ++){
        double adder4 = 0;
        for (var document in decodedData.entries){
          for (var x in document.value.entries){
            if (x.key == "data"){
              for (int n = 0; n <= x.value.length-1; n++){
                if (x.value[n]["date"]==twentyEightDaysDateList[day]){
                  if (x.value[n]["new_cases"] != null) {
                    adder4 += x.value[n]["new_cases"];
                  }
                }
              }
            }
          }
        }
        twentyEightDaysDailyCasesValuesList.add(adder4.toInt());
      }

      //  Fetch All country Names and Data

      for (var document in decodedData.entries){
        String cName = "";
        for (var x in document.value.entries){
          if(x.key=="location"){
            cName = x.value;
          }else if (x.key == "data"){
            for (int n = 0; n <= x.value.length-1; n++){
              if (x.value[n]["date"]==parsedLatestDate){

                //Adding item to totalCasesTableDataList
                totalCasesTableDataList.add({
                  "country":"$cName",
                  "total cases": "${x.value[n]["total_cases"]}",
                  "daily cases":"${x.value[n]["new_cases"]}",
                  "total deaths":"${x.value[n]["total_deaths"]}",
                });

                //Adding item to totalDeathTableDataList
                totalDeathTableDataList.add({
                  "country":"$cName",
                  "total cases": "${x.value[n]["total_cases"]}",
                  "daily cases":"${x.value[n]["new_cases"]}",
                  "total deaths":"${x.value[n]["total_deaths"]}",
                });


              }else if (x.value[n]["date"] != parsedLatestDate && n == x.value.length-1){

                //Adding item to totalCasesTableDataList
                totalCasesTableDataList.add({
                  "country":"$cName",
                  "total cases": "${x.value[n]["total_cases"]}",
                  "daily cases":"${x.value[n]["new_cases"]}",
                  "total deaths":"${x.value[n]["total_deaths"]}",
                });

                //Adding item to totalDeathTableDataList
                totalDeathTableDataList.add({
                  "country":"$cName",
                  "total cases": "${x.value[n]["total_cases"]}",
                  "daily cases":"${x.value[n]["new_cases"]}",
                  "total deaths":"${x.value[n]["total_deaths"]}",
                });
              }
            }
          }
        }
      }

      // Sorting totalCasesTableDataList in descending order of the value of “Total Cases.”.
      totalCasesTableDataList.sort((a,b) => b["total cases"].compareTo(a["total cases"]));

      // Sorting totalDeathTableDataList in descending order of the value of “Total Deaths.”.
      totalDeathTableDataList.sort((a,b) => b["total deaths"].compareTo(a["total deaths"]));


    } catch (e) {
      print("caught error  $e");
    }
  }

  // Cases/Death Graph 1 to 4 Button Functions to switch between graphs
  graph1() {
    selectedVaccineGraph = casesDeathGraphs.graph1;
    notifyListeners();
  }

  graph2() {
    selectedVaccineGraph = casesDeathGraphs.graph2;
    notifyListeners();
  }

  graph3() {
    selectedVaccineGraph = casesDeathGraphs.graph3;
    notifyListeners();
  }

  graph4() {
    selectedVaccineGraph = casesDeathGraphs.graph4;
    notifyListeners();
  }

  onCasesDeathsBody() {
    selectedBody = casesDeathMainBody.on;
    notifyListeners();
  }

  offCasesDeathsBody() {
    selectedBody = casesDeathMainBody.off;
    notifyListeners();
  }

  // Selector for the graph to be displayed on Cases/Death Page
  Widget casesDeathGraphBody() {
    switch (selectedVaccineGraph) {
      case casesDeathGraphs.graph1:
         return lineGraph1();
        break;
      case casesDeathGraphs.graph2:
        return lineGraph2();
        break;
      case casesDeathGraphs.graph3:
        return lineGraph3();
        break;
      case casesDeathGraphs.graph4:
        return lineGraph4();
        break;
      default:
        return Container();
    }
  }

  // Linear Graphs to display Total Cases and Daily Cases for 7 days and 28 days
  lineGraph1(){
    return LineChart(
      LineChartData(
        axisTitleData: FlAxisTitleData(
          show: true,
          leftTitle: AxisTitle(showTitle: true, titleText: 'People', margin: 16),
          bottomTitle: AxisTitle(
              showTitle: true,
              margin: 1,
              titleText: 'Date',
              // textStyle: dateTextStyle,
              textAlign: TextAlign.right),
        ),

        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade500,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.shade500,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 8,
            getTextStyles: (val) =>
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 9),
            getTitles: (val) {
              switch (val.toInt()) {
                case 1:
                  return sevenDaysXAxisDateList[6];
                case 3:
                  return sevenDaysXAxisDateList[5];
                case 5:
                  return sevenDaysXAxisDateList[4];
                case 7:
                  return sevenDaysXAxisDateList[3];
                case 9:
                  return sevenDaysXAxisDateList[2];
                case 11:
                  return sevenDaysXAxisDateList[1];
                case 13:
                  return sevenDaysXAxisDateList[0];
              }
              return '';
            },
            margin: 5,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            getTitles: (val) {
              switch (val.toInt()) {
                case 1:
                  return '1B';
                case 3:
                  return '3B';
                case 5:
                  return '5B';
                case 7:
                  return '7B';
                case 9:
                  return '9B';
                case 11:
                  return '12B';
              }
              return '';
            },
            reservedSize: 5,
            margin: 10,
          ),
        ),

        borderData:
        FlBorderData(show: true, border: Border.all(color: Colors.deepPurpleAccent, width: 2)
        ),
        minX: 0,
        maxX: 14,
        minY: -1,
        maxY: 12,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(1, sevenDaysTotalCasesValuesList[5]/1000000000),
              FlSpot(3, sevenDaysTotalCasesValuesList[4]/1000000000),
              FlSpot(5, sevenDaysTotalCasesValuesList[3]/1000000000),
              FlSpot(7, sevenDaysTotalCasesValuesList[2]/1000000000),
              FlSpot(9, sevenDaysTotalCasesValuesList[1]/1000000000),
              FlSpot(11,sevenDaysTotalCasesValuesList[0]/1000000000),
              FlSpot(13, totalCases/1000000000),
            ],
            isCurved: true,
            colors: [ Colors.deepPurpleAccent, Colors.deepPurpleAccent,],
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
            ),
          ),
        ],
      ),
    );
  }
  lineGraph2(){
    return LineChart(
      LineChartData(
        axisTitleData: FlAxisTitleData(
          show: true,
          leftTitle: AxisTitle(showTitle: true, titleText: 'People', margin: 16),
          bottomTitle: AxisTitle(
              showTitle: true,
              margin: 1,
              titleText: 'Date',
              // textStyle: dateTextStyle,
              textAlign: TextAlign.right),
        ),

        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade500,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.shade500,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 8,
            getTextStyles: (val) =>
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 9),
            getTitles: (val) {
              switch (val.toInt()) {
                case 1:
                  return sevenDaysXAxisDateList[6];
                case 3:
                  return sevenDaysXAxisDateList[5];
                case 5:
                  return sevenDaysXAxisDateList[4];
                case 7:
                  return sevenDaysXAxisDateList[3];
                case 9:
                  return sevenDaysXAxisDateList[2];
                case 11:
                  return sevenDaysXAxisDateList[1];
                case 13:
                  return sevenDaysXAxisDateList[0];
              }
              return '';
            },
            margin: 5,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            getTitles: (val) {
              switch (val.toInt()) {
                case 1:
                  return '1M';
                case 3:
                  return '3M';
                case 5:
                  return '5M';
                case 7:
                  return '7M';
                case 9:
                  return '9M';
                case 11:
                  return '12M';
              }
              return '';
            },
            reservedSize: 5,
            margin: 10,
          ),
        ),

        borderData:
        FlBorderData(show: true, border: Border.all(color: Colors.deepPurpleAccent, width: 2)
        ),
        minX: 0,
        maxX: 14,
        minY: 0,
        maxY: 12,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(1, sevenDaysDailyCasesValuesList[5]/1000000),
              FlSpot(3, sevenDaysDailyCasesValuesList[4]/1000000),
              FlSpot(5, sevenDaysDailyCasesValuesList[3]/1000000),
              FlSpot(7, sevenDaysDailyCasesValuesList[2]/1000000),
              FlSpot(9, sevenDaysDailyCasesValuesList[1]/1000000),
              FlSpot(11, sevenDaysDailyCasesValuesList[0]/1000000),
              FlSpot(13, dailyCases/1000000),
            ],
            isCurved: true,
            colors: [ Colors.deepPurpleAccent, Colors.deepPurpleAccent,],
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
            ),
          ),
        ],
      ),
    );
  }
  lineGraph3(){
    return LineChart(
      LineChartData(
        axisTitleData: FlAxisTitleData(
          show: true,
          leftTitle: AxisTitle(showTitle: true, titleText: 'People', margin: 16),
          bottomTitle: AxisTitle(
              showTitle: true,
              margin: 1,
              titleText: 'Date',
              // textStyle: dateTextStyle,
              textAlign: TextAlign.right),
        ),

        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade500,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.shade500,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 8,
            getTextStyles: (val) =>
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 9),
            getTitles: (val) {
              switch (val.toInt()) {
                case 15:
                  return twentyEightDaysXAxisDateList[27];
                case 30:
                  return twentyEightDaysXAxisDateList[21];
                case 45:
                  return twentyEightDaysXAxisDateList[14];
                case 60:
                  return twentyEightDaysXAxisDateList[7];
                case 75:
                  return twentyEightDaysXAxisDateList[0];
              }
              return '';
            },
            margin: 5,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            getTitles: (val) {
              switch (val.toInt()) {
                case 1:
                  return '1B';
                case 3:
                  return '3B';
                case 5:
                  return '5B';
                case 7:
                  return '7B';
                case 9:
                  return '9B';
                case 11:
                  return '12B';
              }
              return '';
            },
            reservedSize: 5,
            margin: 10,
          ),
        ),

        borderData:
        FlBorderData(show: true, border: Border.all(color: Colors.deepPurpleAccent, width: 2)
        ),
        minX: 0,
        maxX: 84,
        minY: -1,
        maxY: 12,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(1, twentyEightDaysTotalCasesValuesList[26]/1000000000),
              FlSpot(4, twentyEightDaysTotalCasesValuesList[25]/1000000000),
              FlSpot(7, twentyEightDaysTotalCasesValuesList[24]/1000000000),
              FlSpot(10, twentyEightDaysTotalCasesValuesList[23]/1000000000),
              FlSpot(13, twentyEightDaysTotalCasesValuesList[22]/1000000000),
              FlSpot(16, twentyEightDaysTotalCasesValuesList[21]/1000000000),

              FlSpot(19, twentyEightDaysTotalCasesValuesList[20]/1000000000),
              FlSpot(21, twentyEightDaysTotalCasesValuesList[19]/1000000000),
              FlSpot(24, twentyEightDaysTotalCasesValuesList[18]/1000000000),
              FlSpot(27, twentyEightDaysTotalCasesValuesList[17]/1000000000),
              FlSpot(30, twentyEightDaysTotalCasesValuesList[16]/1000000000),
              FlSpot(33, twentyEightDaysTotalCasesValuesList[15]/1000000000),

              FlSpot(36, twentyEightDaysTotalCasesValuesList[14]/1000000000),
              FlSpot(39, twentyEightDaysTotalCasesValuesList[13]/1000000000),
              FlSpot(41, twentyEightDaysTotalCasesValuesList[12]/1000000000),
              FlSpot(44, twentyEightDaysTotalCasesValuesList[11]/1000000000),
              FlSpot(47, twentyEightDaysTotalCasesValuesList[10]/1000000000),
              FlSpot(50, twentyEightDaysTotalCasesValuesList[9]/1000000000),

              FlSpot(53, twentyEightDaysTotalCasesValuesList[8]/1000000000),
              FlSpot(56, twentyEightDaysTotalCasesValuesList[7]/1000000000),
              FlSpot(59, twentyEightDaysTotalCasesValuesList[6]/1000000000),
              FlSpot(62, twentyEightDaysTotalCasesValuesList[5]/1000000000),
              FlSpot(65, twentyEightDaysTotalCasesValuesList[4]/1000000000),
              FlSpot(68, twentyEightDaysTotalCasesValuesList[3]/1000000000),
              FlSpot(71, twentyEightDaysTotalCasesValuesList[2]/1000000000),
              FlSpot(74, twentyEightDaysTotalCasesValuesList[1]/1000000000),
              FlSpot(77, twentyEightDaysTotalCasesValuesList[0]/1000000000),
              FlSpot(80, totalCases/1000000000),
            ],
            isCurved: true,
            colors: [ Colors.deepPurpleAccent, Colors.deepPurpleAccent,],
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
            ),
          ),
        ],
      ),
    );
  }
  lineGraph4(){
    return LineChart(
      LineChartData(
        axisTitleData: FlAxisTitleData(
          show: true,
          leftTitle: AxisTitle(showTitle: true, titleText: 'People', margin: 16),
          bottomTitle: AxisTitle(
              showTitle: true,
              margin: 1,
              titleText: 'Date',
              // textStyle: dateTextStyle,
              textAlign: TextAlign.right),
        ),

        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade500,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.shade500,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 8,
            getTextStyles: (val) =>
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 9),
            getTitles: (val) {
              switch (val.toInt()) {
                case 15:
                  return twentyEightDaysXAxisDateList[27];
                case 30:
                  return twentyEightDaysXAxisDateList[21];
                case 45:
                  return twentyEightDaysXAxisDateList[14];
                case 60:
                  return twentyEightDaysXAxisDateList[7];
                case 75:
                  return twentyEightDaysXAxisDateList[0];
              }
              return '';
            },
            margin: 5,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            getTitles: (val) {
              switch (val.toInt()) {
                case 1:
                  return '1M';
                case 3:
                  return '3M';
                case 5:
                  return '5M';
                case 7:
                  return '7M';
                case 9:
                  return '9M';
                case 11:
                  return '12M';
              }
              return '';
            },
            reservedSize: 5,
            margin: 10,
          ),
        ),

        borderData:
        FlBorderData(show: true, border: Border.all(color: Colors.deepPurpleAccent, width: 2)
        ),
        minX: 0,
        maxX: 84,
        minY: 0,
        maxY: 12,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(1, twentyEightDaysDailyCasesValuesList[26]/1000000),
              FlSpot(4, twentyEightDaysDailyCasesValuesList[25]/1000000),
              FlSpot(7, twentyEightDaysDailyCasesValuesList[24]/1000000),
              FlSpot(10, twentyEightDaysDailyCasesValuesList[23]/1000000),
              FlSpot(13, twentyEightDaysDailyCasesValuesList[22]/1000000),
              FlSpot(16, twentyEightDaysDailyCasesValuesList[21]/1000000),

              FlSpot(19, twentyEightDaysDailyCasesValuesList[20]/1000000),
              FlSpot(21, twentyEightDaysDailyCasesValuesList[19]/1000000),
              FlSpot(24, twentyEightDaysDailyCasesValuesList[18]/1000000),
              FlSpot(27, twentyEightDaysDailyCasesValuesList[17]/1000000),
              FlSpot(30, twentyEightDaysDailyCasesValuesList[16]/1000000),
              FlSpot(33, twentyEightDaysDailyCasesValuesList[15]/1000000),

              FlSpot(36, twentyEightDaysDailyCasesValuesList[14]/1000000),
              FlSpot(39, twentyEightDaysDailyCasesValuesList[13]/1000000),
              FlSpot(41, twentyEightDaysDailyCasesValuesList[12]/1000000),
              FlSpot(44, twentyEightDaysDailyCasesValuesList[11]/1000000),
              FlSpot(47, twentyEightDaysDailyCasesValuesList[10]/1000000),
              FlSpot(50, twentyEightDaysDailyCasesValuesList[9]/1000000),

              FlSpot(53, twentyEightDaysDailyCasesValuesList[8]/1000000),
              FlSpot(56, twentyEightDaysDailyCasesValuesList[7]/1000000),
              FlSpot(59, twentyEightDaysDailyCasesValuesList[6]/1000000),
              FlSpot(62, twentyEightDaysDailyCasesValuesList[5]/1000000),
              FlSpot(65, twentyEightDaysDailyCasesValuesList[4]/1000000),
              FlSpot(68, twentyEightDaysDailyCasesValuesList[3]/1000000),
              FlSpot(71, twentyEightDaysDailyCasesValuesList[2]/1000000),
              FlSpot(74, twentyEightDaysDailyCasesValuesList[1]/1000000),
              FlSpot(77, twentyEightDaysDailyCasesValuesList[0]/1000000),
              FlSpot(80, dailyCases/1000000),
            ],
            isCurved: true,
            colors: [ Colors.deepPurpleAccent, Colors.deepPurpleAccent,],
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
            ),
          ),
        ],
      ),
    );
  }

  // Cases/Death Tables Button Functions  to switch between Tables
  table1() {
    selectedTable = casesDeathTables.totalCasesTableEnum;
    notifyListeners();
  }

  table2() {
    selectedTable = casesDeathTables.totalDeathTableEnum;
    notifyListeners();
  }

  // Selector for the Table to be displayed on Cases/Death Page==========================================
  Widget casesDeathsTableBody(BuildContext context) {
    switch (selectedTable) {
      case casesDeathTables.defaultTable:
        return Text("");
        break;
      case casesDeathTables.totalCasesTableEnum:
        return totalCasesTable(context);
        break;
      case casesDeathTables.totalDeathTableEnum:
        return totalDeathsTable(context);
        break;
      default:
        return Container();
    }
  }

  // Total Cases Table to be displayed====================================
  Widget totalCasesTable(BuildContext context){
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: totalCasesTableDataList.length,
          itemBuilder: (context, index){
            return index == 0 ?
            Padding(
              padding: EdgeInsets.only(bottom: 17, top: 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("country"),
                      Text("total cases"),
                      Text("daily cases"),
                      Text("total deaths"),
                    ],
                  ),
                  SizedBox(height: 17,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Flexible(child: Text("${totalCasesTableDataList[index]["country"]}")),
                      Flexible(child: Text("${totalCasesTableDataList[index]["total cases"]}")),
                      Flexible(child: Text("${totalCasesTableDataList[index]["daily cases"]}")),
                      Flexible(child: Text("${totalCasesTableDataList[index]["total death"]}")),
                    ],
                  ),
                ],
              ),
            )
                : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text("${totalCasesTableDataList[index]["country"]}")),
                    Flexible(child: Text("${totalCasesTableDataList[index]["total cases"]}")),
                    Flexible(child: Text("${totalCasesTableDataList[index]["daily cases"]}")),
                    Flexible(child: Text("${totalCasesTableDataList[index]["total death"]}")),
                  ],
                ),
                SizedBox(height: 15,),
              ],
            );
          }),
    );
  }

  // Total Deaths Table to be displayed
  Widget totalDeathsTable(BuildContext context){
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: totalDeathTableDataList.length,
          itemBuilder: (context, index){
            return index == 0 ?
            Padding(
              padding: EdgeInsets.only(bottom: 17, top: 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("country"),
                      Text("total cases"),
                      Text("daily cases"),
                      Text("total deaths"),
                    ],
                  ),
                  SizedBox(height: 17,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text("${totalDeathTableDataList[index]["country"]}")),
                      Flexible(child: Text("${totalDeathTableDataList[index]["total cases"]}")),
                      Flexible(child: Text("${totalDeathTableDataList[index]["daily cases"]}")),
                      Flexible(child: Text("${totalDeathTableDataList[index]["total death"]}")),
                    ],
                  ),
                ],
              ),
            )
                : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text("${totalDeathTableDataList[index]["country"]}")),
                    Flexible(child: Text("${totalDeathTableDataList[index]["total cases"]}")),
                    Flexible(child: Text("${totalDeathTableDataList[index]["daily cases"]}")),
                    Flexible(child: Text("${totalDeathTableDataList[index]["total death"]}")),
                  ],
                ),
                SizedBox(height: 15,),
              ],
            );
          }),
    );
  }

  notifyListeners();
}