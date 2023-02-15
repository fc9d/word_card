import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  List testList = [];
  String input = '';

  void initState() {
    super.initState();
    testList.add("Item1");
    testList.add("Item2");
    testList.add("Item3");
    testList.add("Item4");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text("Add Todolist"),
                    content: TextField(
                      onChanged: (String value) {
                        input = value;
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            setState(() {
                              testList.add(input);
                            });
                            Navigator.of(context).pop(); // input 입력 후 창 닫히도록
                          },
                          child: Text("Add"))
                    ]);
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
          itemCount: testList.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                // 삭제 버튼 및 기능 추가
                key: Key(testList[index]),
                child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      title: Text(testList[index]),
                      trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              testList.removeAt(index);
                            });
                          }),
                    )));
          }),
    );
  }
}
