import 'package:flutter/material.dart';
import 'package:ignite/models/department.dart';

class DepartmentScreen extends StatelessWidget {
  final Department department;
  DepartmentScreen({@required this.department});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dipartimento"),
      ),
      body: Center(
        child: Text(department.getCity()),
      ),
    );
  }
}
