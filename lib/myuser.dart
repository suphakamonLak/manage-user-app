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
        backgroundColor: const Color.fromARGB(255, 235, 246, 255),
        title: Row(
          children: [
            const Text(
              "Manage users",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 110),
            TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor:const Color.fromARGB(255, 84, 107, 197),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 5)
              ),
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
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        // backgroundColor: const Color.fromARGB(255, 162, 187, 238),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: 800,
            decoration: BoxDecoration(
              // color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(12)
            ),
            child: ListView.builder(
              shrinkWrap: true,// ให้ list ตามขนาดเนื้อหา
              physics: NeverScrollableScrollPhysics(),// ปิด scroll ซ้อน
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
                  child: Column(
                    children: [
                      Container(
                        height: 180,
                        width: double.infinity,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                          ),
                          color: const Color.fromARGB(255, 213, 227, 255),
                          child: Column(
                            children: [
                              ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)
                                ),
                                leading: const Icon(Icons.person_pin, size: 40),
                                title: Text(
                                  "${userdata[index]["name"]}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                subtitle: Text("Age: ${userdata[index]["age"]}\nInternet: ${formatData(userdata[index]["internet"])}\n"
                                  "Hobby:  ${formatData(userdata[index]["hobby"])}"
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                        // icon edit
                                        onPressed: () {
                                          String name = userdata[index]["name"];
                                          String age =
                                              userdata[index]["age"].toString();
                                          int id = userdata[index]["id"];
                                          String hobby = userdata[index]["hobby"];
                                          String internet = userdata[index]["internet"];
                                          todoUpdate(name, age, hobby, id, internet);
                                        },
                                        icon: const Icon(Icons.edit)),
                                    IconButton(
                                        onPressed: () {
                                          String name = userdata[index]["name"];
                                          int id = userdata[index]["id"];
                                          showConfirm(name, id);
                                        },
                                        icon: const Icon(Icons.delete)
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8,)
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String formatData(String datas) {
    List<String> item = datas
      .replaceAll('[', '')
      .replaceAll(']', '')
      .split(',')
      .map((item) => item.trim())// ลบช่องว่างซ้ายขวา
      .toList();

    return item.join(', ');
  }

  void showConfirm(String name, int id) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: const Color.fromARGB(255, 216, 197, 24), size: 30,),
              SizedBox(width: 10),
              Text("Warning"),
            ],
          ),
          content: Text("Do you want to Delete $name ?", style: TextStyle(fontSize: 16),),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[300],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    )
                  ),
                  onPressed: () {
                    deleteUser(id);
                    Navigator.pop(context);
                  }, 
                  child: Text("delete")
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    )
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                  child: Text("cancel")
                )
              ],
            )
          ],
        );
      }
    );
  }

  void todoInsert() {
    TextEditingController userName = TextEditingController();
    TextEditingController userAge = TextEditingController();
    Map<String, bool> hobby = {
      "cycling": false,
      "dancing": false,
      "cooking": false,
      "photography": false,
      "gaming": false
    };
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
              title: const Text("User Register", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              content: SingleChildScrollView(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: userName,
                    decoration: const InputDecoration(
                      labelText: "Enter your Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
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
                  Text("Hobby: ", style: TextStyle(fontWeight: FontWeight.bold),),
                  ...hobby.keys.map((choice) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: hobby[choice], 
                          onChanged: (value) => setStateDialog(
                            () => hobby[choice] = value!),
                        ),
                        Text(choice)
                      ],
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Internet:", style: TextStyle(fontWeight: FontWeight.bold),),
                  ...internet.keys.map((choice) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            value: internet[choice],
                            onChanged: (value) => setStateDialog(
                                () => internet[choice] = value!)
                        ),
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
                        List<String> selHobby = hobby.entries
                          .where((element) => element.value)
                          .map((e) => e.key)
                          .toList();
                    
                        var doginfo = User(
                            name: userName.text,
                            age: int.parse(userAge.text),
                            hobby: selHobby.toString(),
                            internet: selInternet.toString()); // ใช้ gender ที่เลือก
                        await Dbhelper.instance.insertDog(doginfo);
                        userdata = await Dbhelper.instance.queryAll();
                        setState(() {});// update UI
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

  void todoUpdate(name, age, hobbySel, id, internetSel) {
    TextEditingController newUserName = TextEditingController(text: name);
    TextEditingController newUserAge = TextEditingController(text: age);
    Map<String, bool> internet = {
      "AIS": internetSel.contains("AIS"),
      "truemoveH": internetSel.contains("truemoveH"),
      "dtac": internetSel.contains("dtac")
    };
    Map<String, bool> hobby = {
      "cycling": hobbySel.contains("cycling"),
      "dancing": hobbySel.contains("dancing"),
      "cooking": hobbySel.contains("cooking"),
      "photography": hobbySel.contains("photography"),
      "gaming": hobbySel.contains("gaming")
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
                    Text("Hobby:"),
                    ...hobby.keys.map((choice) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: hobby[choice], 
                            onChanged: (value) => setStateDialog(
                              () => hobby[choice] = value!)
                          ),
                          Text(choice)
                        ],
                      );
                    }),
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

                      List<String> selHobby = hobby.entries
                        .where((element) => element.value)
                        .map((e) => e.key)
                        .toList();

                      var doginfo = User(
                          id: id,
                          name: newUserName.text,
                          age: int.parse(newUserAge.text),
                          hobby: selHobby.toString(),
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

  void deleteUser(int id) async {
    await Dbhelper.instance.delete(id);
    userdata = await Dbhelper.instance.queryAll();
    setState(() {});
  }
}
