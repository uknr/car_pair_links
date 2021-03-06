import 'package:car_pair_links/src/ViewRoomCreateEnterToRoomMain.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:car_pair_links/common/FirebaseWrapper.dart';
import 'package:commons/commons.dart';

List<String> iconList = [
  "images/icon-01.png",
  "images/icon-02.png",
  "images/icon-03.png",
  "images/icon-04.png",
  "images/icon-05.png",
  "images/icon-06.png",
  "images/icon-07.png",
  "images/icon-08.png",
];

List<String> bgimageRoom = [
  "images/header.png",
  "images/header-01.png",
  "images/header-02.png",
  "images/header-03.png",
];

List<String> mockRoomList = [
  "地下鉄かくれんぼ",
  "大阪の市内バス",
  "誰でもおいで",
  "逃走中v1",
  "テスト部屋",
];

class RoomeEnter extends StatefulWidget {
  // 使用するStateを指定
  @override
  _RoomeEnter createState() => _RoomeEnter();
}

// Stateを継承して使う
class _RoomeEnter extends State<RoomeEnter> {
  // 状態変数定義
  bool roomType = true;
  var roomName = TextEditingController();
  var roomPassword = TextEditingController();
  var userNickName = TextEditingController();
  String userIcon = "";
  String choiceRoom = "";
  Color colorPublic = Colors.yellow[700];
  Color colorPrivate = Colors.green[700];

  // インスタンス変数初期化
  var firebaseWrapper = new FirebaseWrapper();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'ルーム参加画面',
        home: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
            ),
            Scaffold(
                backgroundColor: Colors.transparent,
                appBar: new AppBar(
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/header.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: const Text(
                    "CAR PAIR LINKS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                    ),
                  ),
                  backgroundColor: Colors.blue.withOpacity(0.3),
                  elevation: 0.0,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, '/roomHome'); //routesで定義した名称を指定する
                    },
                    icon: Icon(Icons.keyboard_arrow_left,
                        size: 45, color: Colors.white),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'ルームへ参加',
                        style: TextStyle(
                          color: Colors.indigo[900],
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(children: <Widget>[
                                Container(
                                    child: Center(
                                        child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.public,
                                      size: 30,
                                      color: roomType
                                          ? colorPublic
                                          : colorPrivate),
                                ))),
                                ToggleSwitch(
                                  minWidth: 137.5,
                                  initialLabelIndex: roomType ? 0 : 1,
                                  cornerRadius: 20.0,
                                  activeFgColor: Colors.black,
                                  inactiveBgColor: Colors.grey,
                                  inactiveFgColor: Colors.white,
                                  labels: ['公開', '非公開'],
                                  activeBgColors: [
                                    Colors.yellow[700],
                                    Colors.green[700]
                                  ],
                                  onToggle: (index) async {
                                    setState(() {
                                      roomType = !roomType;
                                    });
                                    print('switched to: $index');
                                    print(choiceRoom);
                                  },
                                ),
                              ])),
                          if (roomType)
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Container(
                                  height: 250.0,
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: Firestore.instance
                                          .collection('rooms')
                                          .where("ルームタイプ", isEqualTo: "公開中")
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.data == null)
                                          return CircularProgressIndicator();
                                        var roomData = snapshot.data.documents;
                                        return (roomData.length == 0)
                                            ? Container(
                                                child: Text("ルームが存在しません。"),
                                              )
                                            : ListView(
                                                scrollDirection: Axis.vertical,
                                                children: <Widget>[
                                                  for (int index = 0;
                                                      index < roomData.length;
                                                      index++)
                                                    Container(
                                                        height: 50.0,
                                                        margin: EdgeInsets.only(
                                                            bottom: 10),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 25,
                                                                right: 15),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          image:
                                                              new DecorationImage(
                                                            image: AssetImage(
                                                                bgimageRoom[
                                                                    index % 4]),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Container(
                                                                child: Text(
                                                                  roomData[
                                                                          index]
                                                                      .documentID,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                  child: Row(
                                                                children: [
                                                                  Container(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              5,
                                                                          bottom:
                                                                              5),
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomCenter,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                              Icons.group,
                                                                              size: 20,
                                                                              color: Colors.white),
                                                                          StreamBuilder<QuerySnapshot>(
                                                                              stream: Firestore.instance.collection('rooms').document(roomData[index].documentID).collection("users").snapshots(),
                                                                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                                                if (snapshot.data == null) return CircularProgressIndicator();
                                                                                var roomUserData = snapshot.data.documents;
                                                                                return Text(
                                                                                  roomUserData.length.toString(),
                                                                                  style: TextStyle(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                );
                                                                              }),
                                                                        ],
                                                                      )),
                                                                  RaisedButton(
                                                                    child: choiceRoom ==
                                                                            roomData[index].documentID
                                                                        ? Text(
                                                                            '選択中',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black54,
                                                                            ),
                                                                          )
                                                                        : Text(
                                                                            '選択',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black54,
                                                                            ),
                                                                          ),
                                                                    color: choiceRoom ==
                                                                            roomData[index]
                                                                                .documentID
                                                                        ? colorPublic
                                                                        : Colors
                                                                            .white
                                                                            .withOpacity(0.5),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        choiceRoom =
                                                                            roomData[index].documentID;
                                                                      });
                                                                    },
                                                                  ),
                                                                ],
                                                              )),
                                                            ])),
                                                ],
                                              );
                                      })),
                            ),
                          if (!roomType)
                            Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Row(children: <Widget>[
                                  Container(
                                      child: Center(
                                          child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.meeting_room,
                                        size: 30,
                                        color: roomType
                                            ? colorPublic
                                            : colorPrivate),
                                  ))),
                                  SizedBox(
                                      width: 275,
                                      height: 50,
                                      child: TextFormField(
                                          controller: roomName,
                                          decoration: InputDecoration(
                                              labelText: "ルーム名",
                                              hintText:
                                                  roomType ? "ルーム名" : "ルーム名称",
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: BorderSide(),
                                              )))),
                                ])),
                          if (!roomType)
                            Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Row(children: <Widget>[
                                  Container(
                                      child: Center(
                                          child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.https,
                                        size: 30, color: colorPrivate),
                                  ))),
                                  SizedBox(
                                      width: 275,
                                      height: 50,
                                      child: TextFormField(
                                          controller: roomPassword,
                                          decoration: InputDecoration(
                                              labelText: "共有パスワード",
                                              hintText: "共有パスワード",
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: BorderSide(),
                                              )))),
                                ])),
                        ])),
                    Container(
                        padding: const EdgeInsets.only(
                            right: 30, bottom: 10, left: 30),
                        child: Column(children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(children: <Widget>[
                                Container(
                                    child: Center(
                                        child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.face,
                                      size: 30,
                                      color: roomType
                                          ? colorPublic
                                          : colorPrivate),
                                ))),
                                SizedBox(
                                    width: 275,
                                    height: 50,
                                    child: TextFormField(
                                        controller: userNickName,
                                        decoration: InputDecoration(
                                            labelText: "ニックネーム",
                                            hintText: "ニックネーム",
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                              borderSide: BorderSide(),
                                            )))),
                              ])),
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.indigo[900],
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'アイコンを選択 ',
                                      ),
                                    ],
                                  ),
                                ),
                              ])),
                          Padding(
                            padding: EdgeInsets.only(bottom: 50),
                            child: Container(
                              height: 100.0,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  for (var icon in iconList)
                                    Container(
                                        width: 70,
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10.0),
                                        child: Column(children: <Widget>[
                                          Container(
                                            child: CircleAvatar(
                                              backgroundImage: AssetImage(icon),
                                              backgroundColor:
                                                  Colors.transparent, // 背景色
                                            ),
                                          ),
                                          ButtonTheme(
                                            child: RaisedButton(
                                              child: userIcon == icon
                                                  ? Text(
                                                      '選択中',
                                                      style: TextStyle(
                                                        fontSize: 12.5,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  : Text(
                                                      '選択',
                                                      style: TextStyle(
                                                        fontSize: 12.5,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                              color: (() {
                                                if (userIcon != icon) {
                                                  return Colors.white;
                                                } else if (roomType) {
                                                  return colorPublic;
                                                } else {
                                                  return colorPrivate;
                                                }
                                              })(),
                                              shape: Border(
                                                top: BorderSide(
                                                    color: Colors.red),
                                                left: BorderSide(
                                                    color: Colors.blue),
                                                right: BorderSide(
                                                    color: Colors.yellow),
                                                bottom: BorderSide(
                                                    color: Colors.green),
                                              ),
                                              onPressed: () {
                                                print(icon);
                                                setState(() {
                                                  userIcon = icon;
                                                });
                                              },
                                            ),
                                          ),
                                        ])),
                                ],
                              ),
                            ),
                          ),
                        ])),
                  ]),
                )),
            Container(
                width: double.infinity,
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    child: const Text(
                      "参加",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () async {
                      // 入力チェック
                      print(roomType);
                      bool fieldCheck = true;
                      if (roomType) {
                        if (choiceRoom == "" ||
                            userNickName.text == "" ||
                            userIcon == "") fieldCheck = false;
                      } else {
                        if (roomName.text == "" ||
                            roomPassword.text == "" ||
                            userNickName.text == "" ||
                            userIcon == "") fieldCheck = false;
                      }
                      if (fieldCheck == false) {
                        warningDialog(context, "不足入力項目が存在します。\n入力処理を行ってください。");
                        return false;
                      }
                      if (roomType == false) {
                        // ルーム存在チェック
                        Map processRoomCheckExist =
                            await firebaseWrapper.roomCheckExist(roomName.text);
                        if (processRoomCheckExist["isRoomExist"] == false) {
                          errorDialog(context, "ルームが存在しません。");
                          return false;
                        }
                        // パスワードチェック
                        Map processRoomGetDetail =
                            await firebaseWrapper.roomGetDetail(roomName.text);
                        if (processRoomGetDetail["data"]["ルームパスワード"] !=
                            roomPassword.text) {
                          errorDialog(context, "共有パスワードが間違っています。");
                          return false;
                        }
                      }
                      // ルームユーザ作成処理
                      var nowTime = DateTime.now();
                      Map processRoomUserCreate =
                          await firebaseWrapper.roomUserCreate(
                              (roomType) ? choiceRoom : roomName.text,
                              userNickName.text,
                              userIcon,
                              nowTime);
                      if (processRoomUserCreate['process'] == 'Success')
                        Navigator.pushNamed(context, '/roomMain',
                            arguments: ViewRoomCreateEnterToRoomMain(
                              (roomType) ? choiceRoom : roomName.text,
                              processRoomUserCreate['data']['documentID'],
                            ));
                      else
                        print('参加エラー');
                    },
                    elevation: 16,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                    ),
                    color: Colors.indigo[600],
                    textColor: Colors.white,
                  ),
                )),
          ],
        ));
  }
}
