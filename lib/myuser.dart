import 'package:flutter/material.dart';
import 'package:pretest/dbhelper.dart';
import 'package:pretest/user.dart';

class MyUser extends StatefulWidget {
  const MyUser({super.key});
  @override
  State<MyUser> createState() => _MyUserState();
}

class _MyUserState extends State<MyUser> {
  late List<Map<String, dynamic>> userdata = [];
  late String txt = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    late List<Map<String, dynamic>> users = []; // get data
    users = await Dbhelper.instance.queryAll();
    setState(() {
      userdata = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 246, 255),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.list,
              size: 30,
            ),
            SizedBox(
              width: 15,
            ),
            const Text(
              "User CRUD",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 151, 186, 255),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 3, 144, 60),
                          foregroundColor: Colors.white),
                      onPressed: () {
                        todoInsert();
                      },
                      icon: Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Add User",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 500,
                child: ListView.builder(
                  itemCount: userdata.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      // เลื่อนรายการทิ้งโดยปัดซ้ายขวา
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        // จะถูกเรียกเมื่อรายการถูกเลื่อนออกจนหมดหน้าจอ
                        setState(() {
                          userdata.removeAt(index);
                        });
                      },
                      child: Container(
                        height: 70,
                        child: ListTile(
                          leading: const Icon(Icons.description),
                          title: Text(
                            "id: ${userdata[index]["id"]} ${userdata[index]["name"]}",
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text("Age: ${userdata[index]["age"]} year Hobby:  ${userdata[index]["hobby"]} Internet: ${userdata[index]["internet"]}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  // icon edit
                                  onPressed: () {
                                    String name = userdata[index]["name"];
                                    String age =
                                        userdata[index]["age"].toString();
                                    int id = userdata[index]["id"];
                                    int hobby = userdata[index]["hobby"];
                                    bool hashobby = (hobby == 1);
                                    String internet = userdata[index]["internet"];
                                    todoUpdate(name, age, hashobby, id, internet);
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  // icon delete
                                  onPressed: () {
                                    int id = userdata[index]["id"];
                                    deleteDog(id);
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void todoInsert() {
    TextEditingController userName = TextEditingController();
    TextEditingController userAge = TextEditingController();
    bool hobby = false;
    Map<String, bool> internet = {
      "AIS": false,
      "truemoveH": false,
      "dtac": false,
    };

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("User Register"),
              content: SingleChildScrollView(
                child: Column(children: [
                  TextField(
                    controller: userName,
                    decoration: const InputDecoration(
                      labelText: "Enter your Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: userAge,
                    decoration: const InputDecoration(
                      labelText: "Enter your Age",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text("Hobby:"),
                      SizedBox(width: 10,),
                      Checkbox(
                        value: hobby, 
                        onChanged: (value) => setStateDialog(() => hobby = value!)
                      )                            
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Internet:"),
                  ...internet.keys.map((choice) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            value: internet[choice],
                            onChanged: (value) => setStateDialog(
                                () => internet[choice] = value!)),
                        Text(choice)
                      ],
                    );
                  }),
                ]),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        List<String> selInternet = internet.entries
                            .where((element) => element.value)
                            .map((e) => e.key)
                            .toList();
                    
                        var doginfo = User(
                            name: userName.text,
                            age: int.parse(userAge.text),
                            hobby: hobby,
                            internet: selInternet.toString()); // ใช้ gender ที่เลือก
                        await Dbhelper.instance.insertDog(doginfo);
                        userdata = await Dbhelper.instance.queryAll();
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: const Text("Record")
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")
                    ),
                  ],
                ),
                
              ],
            );
          });
        });
  }

  void todoUpdate(name, age, hobby, id, internetSel) {
    TextEditingController newUserName = TextEditingController(text: name);
    TextEditingController newUserAge = TextEditingController(text: age);
    Map<String, bool> internet = {
      "AIS": internetSel.contains("AIS"),
      "truemoveH": internetSel.contains("truemoveH"),
      "dtac": internetSel.contains("dtac")
    };

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Edit User"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: newUserName,
                      decoration: InputDecoration(
                        labelText: "Enter your name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: newUserAge,
                      decoration: InputDecoration(
                        labelText: "Enter your age",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text("Hobby:"),
                        Checkbox(
                            value: hobby,
                            onChanged: (value) => setStateDialog(() => hobby= value!)
                        ),
                      ]
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Row(
                      // children: [
                    Text("Internet:"),
                    ...internet.keys.map((choice) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                              value: internet[choice],
                              onChanged: (value) => setStateDialog(
                                  () => internet[choice] = value!)),
                          Text(choice)
                        ],
                      );
                    }),
                      // ],
                    // ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () async {
                      List<String> selInternet = internet.entries
                          .where((element) => element.value)
                          .map((e) => e.key)
                          .toList();

                      var doginfo = User(
                          id: id,
                          name: newUserName.text,
                          age: int.parse(newUserAge.text),
                          hobby: hobby,
                          internet: selInternet.toString()); // ใช้ gender ที่เลือก
                      await Dbhelper.instance.update(doginfo);
                      userdata = await Dbhelper.instance.queryAll();
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Text("Update")),
                SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
              ],
            );
          });
        });
  }

  void deleteDog(int id) async {
    await Dbhelper.instance.delete(id);
    userdata = await Dbhelper.instance.queryAll();
    setState(() {});
  }
}
