import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

enum vaccineGraphs {graph1, graph2, graph3, graph4}
enum vaccineTables {countryTable, totalVacTable, defaultTable}
enum vaccineMainBody {on, off}
class VaccineClass extends Model{
  vaccineGraphs selectedVaccineGraph = vaccineGraphs.graph1;
  vaccineTables selectedTable = vaccineTables.defaultTable;
  vaccineMainBody selectedBody = vaccineMainBody.on;
  String parsedLatestDate;
  int totalVac;
  int totalFullyVac;
  int dailyVac;

  List twentyEightDaysXAxisDateList = [];
  List twentyEightDaysDateList = [];

  List sevenDaysDateList = [];
  List sevenDaysXAxisDateList = [];

  List sevenDaysTotalVacValuesList = [];
  List sevenDaysDailyVacValuesList = [];

  List twentyEightDaysTotalVacValuesList = [];
  List twentyEightDaysDailyVacValuesList = [];

  List countryTableData = [];
  List totalVacTableData = [];


  Future<void> getData() async{
    try {
      // Make request from https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/vaccinations.json
      Response response = await get(
          'https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/vaccinations.json');
      var decodedData = jsonDecode(response.body);

      // Retrieving parsed Latest date for South Korea ======================================================
      for (int i = 0; i <= (decodedData.length - 1); i++){
        if (decodedData[i]["country"] == "South Korea"){
          for (int x = 0; x <= (decodedData[i]["data"].length - 1); x++){
            if (x == decodedData[i]["data"].length - 1){
              parsedLatestDate = decodedData[i]["data"][x]["date"];
            }
          }
          break;
        }
      }


      // Calculating Total Vacc. – World Total Vaccinations for parsed Latest date =========================================
      int tvAnswer = 0;
      for (int x = 0; x <= (decodedData.length - 1); x++){
        List checkList = []; // Adding countries with parsed date into the list
        for (int i = 0; i <= decodedData[x]["data"].length - 1; i++){
          if (decodedData[x]["data"][i]["date"] == parsedLatestDate){
            if (decodedData[x]["data"][i]["total_vaccinations"] != null){
              tvAnswer += decodedData[x]["data"][i]["total_vaccinations"];
              checkList.add(decodedData[x]["data"][i]["total_vaccinations"]);
            }
          } else {
            continue;
          }
        }

        // Checking If some country’s data list do not have “data” list for parsed latest date ====================================
        if (checkList.isEmpty) {
          if (decodedData[x]["data"][decodedData[x]["data"].length - 1]["total_vaccinations"] != null){
            tvAnswer += decodedData[x]["data"][decodedData[x]["data"].length - 1]["total_vaccinations"];
          } else if (decodedData[x]["data"][decodedData[x]["data"].length - 1]["people_vaccinated"] != null){
            tvAnswer += decodedData[x]["data"][decodedData[x]["data"].length - 1]["people_vaccinated"];
          } else if (decodedData[x]["data"][decodedData[x]["data"].length - 1]["people_fully_vaccinated"] != null){
            tvAnswer += decodedData[x]["data"][decodedData[x]["data"].length - 1]["people_fully_vaccinated"];
          }
        }
      }
      totalVac = tvAnswer;


      // Calculating Total fully Vacc  for parsed Latest date =====================================
      int tfvAnswer = 0;
      for (int v = 0; v <= (decodedData.length - 1); v++){
        List checkFullList = []; // Adding countries with parsed date into the list
        for (int i = 0; i <= decodedData[v]["data"].length - 1; i++){
          if (decodedData[v]["data"][i]["date"] == parsedLatestDate){
            if (decodedData[v]["data"][i]["people_fully_vaccinated"] != null){
              checkFullList.add(decodedData[v]["data"][i]["people_fully_vaccinated"]);
              tfvAnswer += decodedData[v]["data"][i]["people_fully_vaccinated"];
            }
          } else{
            continue;
          }
        }

        // Checking If some country’s data list do not have “data” list for parsed latest date=====================
        if (checkFullList.isEmpty){

          // Retrieving Date prior parse latest Date ==========================================================
          var date = DateFormat("yyyy-MM-dd").parse(parsedLatestDate);
          var newDate = DateTime(date.year, date.month, date.day-1);
          var finalDate = DateFormat("yyyy-MM-dd").format(newDate).toString();
          if (decodedData[v]["data"][decodedData[v]["data"].length - 1]["people_fully_vaccinated"] != null){
            tfvAnswer += decodedData[v]["data"][decodedData[v]["data"].length - 1]["people_fully_vaccinated"];
          }
          else for (int i = 0; i <= decodedData[v]["data"].length - 1; i++){
            if (decodedData[v]["data"][i]["date"] == finalDate){
              if (decodedData[v]["data"][i]["people_fully_vaccinated"] != null){
                tfvAnswer += decodedData[v]["data"][i]["people_fully_vaccinated"];
              }
            }
          }
        }
      }
      totalFullyVac = tfvAnswer;


      // Calculating Daily Vacc for parsed Latest date ====================================
      int dVAnswer = 0;
      for (int v = 0; v <= (decodedData.length - 1); v++){
        List checkFullList = []; // Adding countries with parsed date into the list============================
        for (int i = 0; i <= decodedData[v]["data"].length - 1; i++){
          if (decodedData[v]["data"][i]["date"] == parsedLatestDate){
            if (decodedData[v]["data"][i]["daily_vaccinations"] != null){
              checkFullList.add(decodedData[v]["data"][i]["daily_vaccinations"]);
              dVAnswer += decodedData[v]["data"][i]["daily_vaccinations"];
            }
          } else{
            continue;
          }
        }

        // Checking If some country’s data list do not have “data” list for parsed latest date=====================
        if (checkFullList.isEmpty){
          //Retrieving Date prior parse latest Date ========================================================
          var date = DateFormat("yyyy-MM-dd").parse(parsedLatestDate);
          var newDate = DateTime(date.year, date.month, date.day-1);
          var finalDate = DateFormat("yyyy-MM-dd").format(newDate).toString();
          if (decodedData[v]["data"][decodedData[v]["data"].length - 1]["daily_vaccinations"] != null){
            dVAnswer += decodedData[v]["data"][decodedData[v]["data"].length - 1]["daily_vaccinations"];
          }
          else for (int i = 0; i <= decodedData[v]["data"].length - 1; i++){
            if (decodedData[v]["data"][i]["date"] == finalDate){
              if (decodedData[v]["data"][i]["daily_vaccinations"] != null){
                dVAnswer += decodedData[v]["data"][i]["daily_vaccinations"];
              }
            }
          }
        }
      }
      dailyVac = dVAnswer;


      // Extracting 7 days From parsed latest date ==================================================
      var initialDate = DateFormat("yyyy-MM-dd").parse(parsedLatestDate);
      for (int d=0; d<=6; d++){
        var  formattedDate = DateTime(initialDate.year, initialDate.month, initialDate.day-d);
        var newDateValue1 = DateFormat("yyyy-MM-dd").format(formattedDate).toString().replaceFirst("2021-", "");
        var newDateValue2 = DateFormat("yyyy-MM-dd").format(formattedDate).toString();
        sevenDaysXAxisDateList.add(newDateValue1);
        sevenDaysDateList.add(newDateValue2);
      }


      //Calculating total vac for seven days, each date from parse latest date excluding parse latest date. ===========================
      // Parse latest date value is not calculated because it is already known which is value stored in totalVac variable=============
      for (int day=1; day <=6; day ++){
        int fn= 0;
        for (int x = 0; x <= (decodedData.length - 1); x++) {
          for (int i = 0; i <= decodedData[x]["data"].length - 1; i++) {
            if (decodedData[x]["data"][i]["date"] == sevenDaysDateList[day]) {
              if (decodedData[x]["data"][i]["total_vaccinations"] != null){
                fn += decodedData[x]["data"][i]["total_vaccinations"];
              }
            } else {
              continue;
            }
          }
        }
        sevenDaysTotalVacValuesList.add(fn);
      }

      //Calculating Daily vac for seven days, each date from parse latest date excluding parse latest date. ============================
      // Parse latest date value is not calculated because it is already known which is value stored in dailyVac variable ===============
      for (int day=1; day <=6; day ++){
        int dv= 0;
        for (int x = 0; x <= (decodedData.length - 1); x++) {
          for (int i = 0; i <= decodedData[x]["data"].length - 1; i++) {
            if (decodedData[x]["data"][i]["date"] == sevenDaysDateList[day]) {
              if (decodedData[x]["data"][i]["daily_vaccinations"] != null){
                dv += decodedData[x]["data"][i]["daily_vaccinations"];
              }
            } else {
              continue;
            }
          }
        }
        sevenDaysDailyVacValuesList.add(dv);
      }


      // Extracting 28 days From parsed latest date =========================================================
      var defaultDate = DateFormat("yyyy-MM-dd").parse(parsedLatestDate);
      for (int d=0; d<=27; d++){
        var  formattedDate = DateTime(defaultDate.year, defaultDate.month, defaultDate.day-d);
        var newDateValue1 = DateFormat("yyyy-MM-dd").format(formattedDate).toString().replaceFirst("2021-", "");
        var newDateValue2 = DateFormat("yyyy-MM-dd").format(formattedDate).toString();
        twentyEightDaysXAxisDateList.add(newDateValue1);
        twentyEightDaysDateList.add(newDateValue2);
      }

      //Calculating Total vac for 28 days each date from parse latest date excluding parse latest date. =================================
      // Parse latest date value is not calculated because it is already known which is value stored in totalVac variable ===============
      for (int day=1; day <=27; day ++){
        int tv= 0;
        for (int x = 0; x <= (decodedData.length - 1); x++) {
          for (int i = 0; i <= decodedData[x]["data"].length - 1; i++) {
            if (decodedData[x]["data"][i]["date"] == twentyEightDaysDateList[day]) {
              if (decodedData[x]["data"][i]["total_vaccinations"] != null){
                tv += decodedData[x]["data"][i]["total_vaccinations"];
              }
            } else {
              continue;
            }
          }
        }
        twentyEightDaysTotalVacValuesList.add(tv);
      }

      //Calculating Daily vac for 28 days each date from parse latest date excluding parse latest date. ============================
      // Parse latest date value is not calculated because it is already known which is value stored in dailyVac variable ==============
      for (int day=1; day <=27; day ++){
        int dv= 0;
        for (int x = 0; x <= (decodedData.length - 1); x++) {
          for (int i = 0; i <= decodedData[x]["data"].length - 1; i++) {
            if (decodedData[x]["data"][i]["date"] == twentyEightDaysDateList[day]) {
              if (decodedData[x]["data"][i]["daily_vaccinations"] != null){
                dv += decodedData[x]["data"][i]["daily_vaccinations"];
              }
            } else {
              continue;
            }
          }
        }
        twentyEightDaysDailyVacValuesList.add(dv);
      }

    //  Fetching All country Names and Data ===============================
        for (int x = 0; x <= (decodedData.length - 1); x++){
          List checkFullList = [];
          for (int i = 0; i <= decodedData[x]["data"].length - 1; i++){
            if (decodedData[x]["data"][i]["date"] == parsedLatestDate) {

              //Adding item to countryTableData ==============================
              countryTableData.add({
                "country":"${decodedData[x]["country"]}",
                "total": "${decodedData[x]["data"][i]["total_vaccinations"]}",
                "fully":"${decodedData[x]["data"][i]["people_fully_vaccinated"]}",
                "daily":"${decodedData[x]["data"][i]["daily_vaccinations"]}",
              });

              //Adding item to totalVacTableData =============================
              totalVacTableData.add({
                "country":"${decodedData[x]["country"]}",
                "total": "${decodedData[x]["data"][i]["total_vaccinations"]}",
                "fully":"${decodedData[x]["data"][i]["people_fully_vaccinated"]}",
                "daily":"${decodedData[x]["data"][i]["daily_vaccinations"]}",
              });
              checkFullList.add(decodedData[x]["country"]);
            }
          }
          if(checkFullList.isEmpty){
            //Adding item to countryTableData ================================
            countryTableData.add({
              "country":"${decodedData[x]["country"]}",
              "total": "${decodedData[x]["data"][decodedData[x]["data"].length-1]["total_vaccinations"]}",
              "fully":"${decodedData[x]["data"][decodedData[x]["data"].length-1]["people_fully_vaccinated"]}",
              "daily":"${decodedData[x]["data"][decodedData[x]["data"].length-1]["daily_vaccinations"]}",
            });

            //Adding item to totalVacTableData ==============================
            totalVacTableData.add({
              "country":"${decodedData[x]["country"]}",
              "total": "${decodedData[x]["data"][decodedData[x]["data"].length-1]["total_vaccinations"]}",
              "fully":"${decodedData[x]["data"][decodedData[x]["data"].length-1]["people_fully_vaccinated"]}",
              "daily":"${decodedData[x]["data"][decodedData[x]["data"].length-1]["daily_vaccinations"]}",
            });
          }
        }

      // Sorting countryTableData alphabetical order(A->Z) of country names ==================================
        countryTableData.sort((a,b) => a["country"].toString().compareTo(b["country"].toString()));

        // Sorting totalVacTableData in descending order of the value of “Total vacc.” =======================
         totalVacTableData.sort((a,b) => b["total"].compareTo(a["total"]));

    } catch (e) {
      print("caught error  $e");
    }
  }

  // Vaccine Graph 1 to 4 Button Functions to switch between graphs ===================================
  graph1() {
    selectedVaccineGraph = vaccineGraphs.graph1;
    notifyListeners();
  }

  graph2() {
    selectedVaccineGraph = vaccineGraphs.graph2;
    notifyListeners();
  }

  graph3() {
    selectedVaccineGraph = vaccineGraphs.graph3;
    notifyListeners();
  }

  graph4() {
    selectedVaccineGraph = vaccineGraphs.graph4;
    notifyListeners();
  }

  onVaccineBody() {
    selectedBody = vaccineMainBody.on;
    notifyListeners();
  }

  offVaccineBody() {
    selectedBody = vaccineMainBody.off;
    notifyListeners();
  }


  // Selector for the graph to be displayed ========================================
  Widget vaccineGraphBody() {
    switch (selectedVaccineGraph) {
      case vaccineGraphs.graph1:
        return lineGraph1();
        break;
      case vaccineGraphs.graph2:
        return lineGraph2();
        break;
      case vaccineGraphs.graph3:
        return lineGraph3();
        break;
      case vaccineGraphs.graph4:
        return lineGraph4();
        break;
      default:
        return Container();
    }
  }

  // Linear Graphs to display Total Vacc and daily vacc for seven days and 28 days =======================
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
        minY: 0,
        maxY: 12,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(1, sevenDaysTotalVacValuesList[5]/1000000000),
              FlSpot(3, sevenDaysTotalVacValuesList[4]/1000000000),
              FlSpot(5, sevenDaysTotalVacValuesList[3]/1000000000),
              FlSpot(7, sevenDaysTotalVacValuesList[2]/1000000000),
              FlSpot(9, sevenDaysTotalVacValuesList[1]/1000000000),
              FlSpot(11, sevenDaysTotalVacValuesList[0]/1000000000),
              FlSpot(13, totalVac/1000000000),

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
              FlSpot(1, sevenDaysDailyVacValuesList[5]/1000000000),
              FlSpot(3, sevenDaysDailyVacValuesList[4]/1000000000),
              FlSpot(5, sevenDaysDailyVacValuesList[3]/1000000000),
              FlSpot(7, sevenDaysDailyVacValuesList[2]/1000000000),
              FlSpot(9, sevenDaysDailyVacValuesList[1]/1000000000),
              FlSpot(11, sevenDaysDailyVacValuesList[0]/1000000000),
              FlSpot(13, dailyVac/1000000000),
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
        minY: 0,
        maxY: 12,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(1, twentyEightDaysTotalVacValuesList[26]/1000000000),
              FlSpot(4, twentyEightDaysTotalVacValuesList[25]/1000000000),
              FlSpot(7, twentyEightDaysTotalVacValuesList[24]/1000000000),
              FlSpot(10, twentyEightDaysTotalVacValuesList[23]/1000000000),
              FlSpot(13, twentyEightDaysTotalVacValuesList[22]/1000000000),
              FlSpot(16, twentyEightDaysTotalVacValuesList[21]/1000000000),

              FlSpot(19, twentyEightDaysTotalVacValuesList[20]/1000000000),
              FlSpot(21, twentyEightDaysTotalVacValuesList[19]/1000000000),
              FlSpot(24, twentyEightDaysTotalVacValuesList[18]/1000000000),
              FlSpot(27, twentyEightDaysTotalVacValuesList[17]/1000000000),
              FlSpot(30, twentyEightDaysTotalVacValuesList[16]/1000000000),
              FlSpot(33, twentyEightDaysTotalVacValuesList[15]/1000000000),

              FlSpot(36, twentyEightDaysTotalVacValuesList[14]/1000000000),
              FlSpot(39, twentyEightDaysTotalVacValuesList[13]/1000000000),
              FlSpot(41, twentyEightDaysTotalVacValuesList[12]/1000000000),
              FlSpot(44, twentyEightDaysTotalVacValuesList[11]/1000000000),
              FlSpot(47, twentyEightDaysTotalVacValuesList[10]/1000000000),
              FlSpot(50, twentyEightDaysTotalVacValuesList[9]/1000000000),

              FlSpot(53, twentyEightDaysTotalVacValuesList[8]/1000000000),
              FlSpot(56, twentyEightDaysTotalVacValuesList[7]/1000000000),
              FlSpot(59, twentyEightDaysTotalVacValuesList[6]/1000000000),
              FlSpot(62, twentyEightDaysTotalVacValuesList[5]/1000000000),
              FlSpot(65, twentyEightDaysTotalVacValuesList[4]/1000000000),
              FlSpot(68, twentyEightDaysTotalVacValuesList[3]/1000000000),
              FlSpot(71, twentyEightDaysTotalVacValuesList[2]/1000000000),
              FlSpot(74, twentyEightDaysTotalVacValuesList[1]/1000000000),
              FlSpot(77, twentyEightDaysTotalVacValuesList[0]/1000000000),
              FlSpot(80, totalVac/1000000000),
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
              FlSpot(1, twentyEightDaysDailyVacValuesList[26]/1000000000),
              FlSpot(4, twentyEightDaysDailyVacValuesList[25]/1000000000),
              FlSpot(7, twentyEightDaysDailyVacValuesList[24]/1000000000),
              FlSpot(10, twentyEightDaysDailyVacValuesList[23]/1000000000),
              FlSpot(13, twentyEightDaysDailyVacValuesList[22]/1000000000),
              FlSpot(16, twentyEightDaysDailyVacValuesList[21]/1000000000),

              FlSpot(19, twentyEightDaysDailyVacValuesList[20]/1000000000),
              FlSpot(21, twentyEightDaysDailyVacValuesList[19]/1000000000),
              FlSpot(24, twentyEightDaysDailyVacValuesList[18]/1000000000),
              FlSpot(27, twentyEightDaysDailyVacValuesList[17]/1000000000),
              FlSpot(30, twentyEightDaysDailyVacValuesList[16]/1000000000),
              FlSpot(33, twentyEightDaysDailyVacValuesList[15]/1000000000),

              FlSpot(36, twentyEightDaysDailyVacValuesList[14]/1000000000),
              FlSpot(39, twentyEightDaysDailyVacValuesList[13]/1000000000),
              FlSpot(41, twentyEightDaysDailyVacValuesList[12]/1000000000),
              FlSpot(44, twentyEightDaysDailyVacValuesList[11]/1000000000),
              FlSpot(47, twentyEightDaysDailyVacValuesList[10]/1000000000),
              FlSpot(50, twentyEightDaysDailyVacValuesList[9]/1000000000),

              FlSpot(53, twentyEightDaysDailyVacValuesList[8]/1000000000),
              FlSpot(56, twentyEightDaysDailyVacValuesList[7]/1000000000),
              FlSpot(59, twentyEightDaysDailyVacValuesList[6]/1000000000),
              FlSpot(62, twentyEightDaysDailyVacValuesList[5]/1000000000),
              FlSpot(65, twentyEightDaysDailyVacValuesList[4]/1000000000),
              FlSpot(68, twentyEightDaysDailyVacValuesList[3]/1000000000),
              FlSpot(71, twentyEightDaysDailyVacValuesList[2]/1000000000),
              FlSpot(74, twentyEightDaysDailyVacValuesList[1]/1000000000),
              FlSpot(77, twentyEightDaysDailyVacValuesList[0]/1000000000),
              FlSpot(80, dailyVac/1000000000),
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


  // Vaccine Tables Button Functions  to switch between Tables ===================================
  table1() {
    selectedTable = vaccineTables.countryTable;
    notifyListeners();
  }

  table2() {
    selectedTable = vaccineTables.totalVacTable;
    notifyListeners();
  }

  // Selector for the Table to be displayed ==========================================
  Widget vaccineTableBody(BuildContext context) {
    switch (selectedTable) {
      case vaccineTables.defaultTable:
        return Text("");
        break;
      case vaccineTables.countryTable:
        return countryTable(context);
        break;
      case vaccineTables.totalVacTable:
        return totalVacTable(context);
        break;
      default:
        return Container();
    }
  }

  // Country name Table to be displayed================================================
  Widget countryTable(BuildContext context){
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
          itemCount: countryTableData.length,
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
                      Text("total"),
                      Text("fully"),
                      Text("daily"),
                    ],
                  ),
                  SizedBox(height: 17,),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text("${countryTableData[index]["country"]}")),
                  Flexible(child: Text("${countryTableData[index]["total"]}")),
                  Flexible(child: Text("${countryTableData[index]["fully"]}")),
                  Flexible(child: Text("${countryTableData[index]["daily"]}")),
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
                    Flexible(child: Text("${countryTableData[index]["country"]}")),
                    Flexible(child: Text("${countryTableData[index]["total"]}")),
                    Flexible(child: Text("${countryTableData[index]["fully"]}")),
                    Flexible(child: Text("${countryTableData[index]["daily"]}")),
                  ],
                ),
                SizedBox(height: 15,),
              ],
            );
          }),
    );
  }

  // Total Vacc Table to be displayed ==========================================
  Widget totalVacTable(BuildContext context){
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: totalVacTableData.length,
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
                      Text("total"),
                      Text("fully"),
                      Text("daily"),
                    ],
                  ),
                  SizedBox(height: 17,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text("${totalVacTableData[index]["country"]}")),
                      Flexible(child: Text("${totalVacTableData[index]["total"]}")),
                      Flexible(child: Text("${totalVacTableData[index]["fully"]}")),
                      Flexible(child: Text("${totalVacTableData[index]["daily"]}")),
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
                    Flexible(child: Text("${totalVacTableData[index]["country"]}")),
                    Flexible(child: Text("${totalVacTableData[index]["total"]}")),
                    Flexible(child: Text("${totalVacTableData[index]["fully"]}")),
                    Flexible(child: Text("${totalVacTableData[index]["daily"]}")),
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
