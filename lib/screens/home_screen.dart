import 'package:flutter/material.dart';
import 'package:sqlite_test/helper/db_helper.dart';
import 'package:sqlite_test/models/student_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Student> students = [];
  DatabaseHelper dbHelper = DatabaseHelper.instance;
// initstate
  @override
  void initState() {
   
    super.initState();
     _updatStudentList();
  }
// update student list
_updatStudentList() async {
    final List<Map<String, dynamic>> studentsMapList =
        await dbHelper.getStudentsMapList();
    setState(() {
      students = studentsMapList
          .map((studentMap) => Student.fromMap(studentMap))
          .toList();
    });
  }

void _showFromDialog({Student? student}) {
    final _nameController = TextEditingController(text: student?.name ?? "");
    final _ageController =
        TextEditingController(text: student?.age.toString() ?? "");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(student == null ? "Add Student" : "Edit Student"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(hintText: "Name"),
              ),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(hintText: "Age"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text;
                final age = int.tryParse(_ageController.text) ;
                if (name.isNotEmpty && age != null) {
                  if (student == null) {
                    int result = await dbHelper
                        .insertStudent({"name": name, "age": age});
                    print("insert result: $result");
                    _updatStudentList();
                  } else {
                    int result = await dbHelper.updateStudent(
                        {"id": student.id, "name": name, "age": age});
                    print("update result: $result");
                    _updatStudentList();
                  }
                   Navigator.of(context).pop();
                }
                
                 else {
                  // print("Name or Age is invalid");
                 
                }
                
              },
              
              child: Text(student == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }

  

  _deleteStudent(int id) {
    dbHelper.deleteStudent(id).then(
          (value) => 
          _updatStudentList(),
        );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student List"),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          // final student = students[index];
          return ListTile(
              title: Text(students[index].name),
              subtitle: Text("Age: ${students[index].age}"),
              trailing: SizedBox(width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showFromDialog(student: students[index]);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteStudent(students[index].id!);
                      },
                    ),
                  ],
                ),
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFromDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  
}
