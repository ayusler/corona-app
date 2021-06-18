
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

enum casesGraphEnum { graph1, graph2, graph3, graph4 }
enum vaccineGraphEnum { graph1, graph2, graph3, graph4 }
enum casesDeathsTable { table1, table2 }
enum vaccineTable { table1, table2 }
enum loginEnum {login1, login2}
enum loginError {no, yes}

class MyModel extends Model {

  // Enum for cases/Death page ==============================
  casesGraphEnum selectedCaseGraph = casesGraphEnum.graph1;
  casesDeathsTable selectedCasesDeathTable = casesDeathsTable.table1;
  loginError selectedError = loginError.no;

  // Cases/Death Graph 1 to 4 Button Functions ======================
  graph1() {
    selectedCaseGraph = casesGraphEnum.graph1;
    notifyListeners();
  }

  graph2() {
    selectedCaseGraph = casesGraphEnum.graph2;
    notifyListeners();
  }

  graph3() {
    selectedCaseGraph = casesGraphEnum.graph3;
    notifyListeners();
  }

  graph4() {
    selectedCaseGraph = casesGraphEnum.graph4;
    notifyListeners();
  }

  // Cases/Death Table 1 to 2 Button Functions ======================
  table1() {
    selectedCasesDeathTable = casesDeathsTable.table1;
    notifyListeners();
  }

  table2() {
    selectedCasesDeathTable = casesDeathsTable.table2;
    notifyListeners();
  }

  onError() {
    selectedError = loginError.yes;
    notifyListeners();
  }

  offError() {
    selectedError = loginError.no;
    notifyListeners();
  }


// Cases/Death Change Table Switch Case ============================================
  Widget casesDeathTableBody() {
    switch (selectedCasesDeathTable) {
      case casesDeathsTable.table1:
        return Container(
          child: Text("Table1"),
        );
        break;
      case casesDeathsTable.table2:
        return Text("Table2");
        break;
      default:
        return Container();
    }
  }


// Cases/Death Change Graph switch case Switch Case ============================================
  Widget casesDeathGraphBody() {
    switch (selectedCaseGraph) {
      case casesGraphEnum.graph1:
        return Container(
          child: Text("Graph1"),
        );
        break;
      case casesGraphEnum.graph2:
        return Text("Graph2");
        break;
      case casesGraphEnum.graph3:
        return Text("Graph3");
        break;
      case casesGraphEnum.graph4:
        return Text("Graph4");
        break;
      default:
        return Container();
    }
  }

  // Enum for Vaccine page ===================================
  casesGraphEnum selectedVaccineGraph = casesGraphEnum.graph1;

  // Vaccine Graph 1 to 4 Button Functions ===================
  vaccineGraph1() {
    selectedCaseGraph = casesGraphEnum.graph1;
    notifyListeners();
  }

  vaccineGraph2() {
    selectedCaseGraph = casesGraphEnum.graph2;
    notifyListeners();
  }

  vaccineGraph3() {
    selectedCaseGraph = casesGraphEnum.graph3;
    notifyListeners();
  }

  vaccineGraph4() {
    selectedCaseGraph = casesGraphEnum.graph4;
    notifyListeners();
  }

  // Vaccine Table 1 to 2 Button Functions ===================
  vaccineTable1() {
    selectedVaccineTable = vaccineTable.table1;
    notifyListeners();
  }

  vaccineTable2() {
    selectedVaccineTable = vaccineTable.table2;
    notifyListeners();
  }

  // Vaccine Change Table Switch Case ============================================
  vaccineTable selectedVaccineTable = vaccineTable.table1;
  Widget vaccineTableBody() {
    switch (selectedVaccineTable) {
      case vaccineTable.table1:
        return Container(
          child: Text("Table1"),
        );
        break;
      case vaccineTable.table2:
        return Text("Table2");
        break;
      default:
        return Container();
    }
  }

  // Vaccine Change Graph Switch Case============================================
  Widget vaccineGraphBody() {
    switch (selectedCaseGraph) {
      case casesGraphEnum.graph1:
        return Container(
          child: Text("Graph1"),
        );
        break;
      case casesGraphEnum.graph2:
        return Text("Graph2");
        break;
      case casesGraphEnum.graph3:
        return Text("Graph3");
        break;
      case casesGraphEnum.graph4:
        return Text("Graph4");
        break;
      default:
        return Container();
    }
  }


  notifyListeners();
}
