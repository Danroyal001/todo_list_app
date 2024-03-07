import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list_app/screens/home.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addTaskToFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    String uid = user!.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(time.toString())
        .set({
      'title': titleController.text,
      'description': descriptionController.text,
      'time': time.toString(),
      'timestamp': time
    });
    Fluttertoast.showToast(msg: 'Data Added');

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Task')),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      labelText: 'Enter Title', border: OutlineInputBorder()),
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      labelText: 'Enter Description',
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.purple.shade100;
                    return Theme.of(context).primaryColor;
                  })),
                  child: Text(
                    'Add Task',
                    style: GoogleFonts.roboto(fontSize: 18),
                  ),
                  // onPressed: () async {
                  //   try {
                  //     // Try to add the task to Firebase
                  //     await addTaskToFirebase();
                  //
                  //     // If successful, pop back to the Home screen
                  //     // This assumes that the Home screen is the root of your navigation stack
                  //     // or at least present in the stack.
                  //     Navigator.of(context).pop();
                  //   } catch (error) {
                  //     // If an error occurs, show an error message
                  //     // You might want to show a dialog or a snackbar with the error
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(
                  //         content: Text('Error adding task: $error'),
                  //       ),
                  //     );
                  //   }
                  // },

                  onPressed: () async {
                    bool taskAdded = await addTaskToFirebase();
                    if (taskAdded) {
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error adding task'),
                        ),
                      );
                    }
                  },

                  // onPressed: () async {
                  //   await addTaskToFirebase();
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => Home()),
                  //   );
                  // },
                ),
                // onPressed: () {
                //   Home();
                //   addTaskToFirebase();
              ),
            ],
          )),
    );
  }
}
