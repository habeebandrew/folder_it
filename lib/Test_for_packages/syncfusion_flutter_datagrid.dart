
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Employee {
  Employee(this.id, this.name, this.salary);
  final int id;
  final String name;
  final double salary;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<Employee> employees}) {
    _employees = employees
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'ID', value: e.id),
      DataGridCell<String>(columnName: 'Name', value: e.name),
      DataGridCell<double>(columnName: 'Salary', value: e.salary),
    ]))
        .toList();
  }

  List<DataGridRow> _employees = [];

  @override
  List<DataGridRow> get rows => _employees;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: row.getCells().map<Widget>((cell) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(cell.value.toString()),
      );
    }).toList());
  }
}

class MyDataGridPage extends StatelessWidget {
  final List<Employee> employees = [
    Employee(1001, 'John', 60000),
    Employee(1002, 'Jane', 65000),
    Employee(1003, 'Doe', 70000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Syncfusion DataGrid Example'),
      ),
      body: SfDataGrid(
        source: EmployeeDataSource(employees: employees),
        columns: <GridColumn>[
          GridColumn(
              columnName: 'ID',
              label: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text('ID'))),
          GridColumn(
              columnName: 'Name',
              label: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text('Name'))),
          GridColumn(
              columnName: 'Salary',
              label: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text('Salary'))),
        ],
      ),
    );
  }
}
