import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite/utils/database_helper.dart';
import 'models/contact.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQliter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'SQlite Demo '),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  Contact _contact = Contact();
  final _formKey = GlobalKey<FormState>();
  List<Contact> _contacts =[];
  DatabaseHelper _databaseHelper ;
  final _ctrlName = TextEditingController();
  final _ctrlmobile = TextEditingController();
  @override
  void initState(){
    super.initState();
    setState(() {
      _databaseHelper =  DatabaseHelper.instance;
    });
    _refreshContactList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[500],
      appBar: AppBar(
        title:Center(
        child:Text(widget.title,
        style: TextStyle(color: Colors.white ),
        ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _form(),_list()
          ],
        ),
      ),
     // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  _form() =>Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
    child: Form(
      key: _formKey,
      child: Column(
      children: <Widget>[
       TextFormField(
         controller: _ctrlName,
         decoration: InputDecoration(labelText: "Full Name"),
         onSaved: (val) => setState(()=> _contact.name = val),
         validator: (value) => (value.length == 0? 'this is required' :null),
       ),
       TextFormField(
         controller: _ctrlmobile,
         decoration: InputDecoration(labelText: "Mobile"),
         onSaved: (val) => setState(()=> _contact.mobile = val),
         validator: (value) => (value.length <10 ?'At least 10 characters required' :null),
       ),
        Container(
          margin:EdgeInsets.all(10.0),
          child: RaisedButton(
            onPressed: ()=>_onSubmit() ,
            child: Text ('Submit'),
            color: Colors.blue,
            textColor: Colors.white,

          )
        )
      ]
      )
    )
  );


  _refreshContactList() async{
   List<Contact> x = await _databaseHelper.fetchContact();
   setState(() {
     _contacts = x;
   });
  }

_onSubmit() async {
  var form = _formKey.currentState;
  if (form.validate()) {
    form.save();
    await _databaseHelper.insertContact(_contact);
    _refreshContactList();
    form.reset();
    }
  }
  _list() =>Expanded(
    child: Card(
      margin: EdgeInsets.fromLTRB(20, 30, 2, 0),
      child: ListView.builder(
        padding: EdgeInsets.all(8),
      itemBuilder: (context, index){
          return Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                    Icons.account_circle,
                  color: Colors.blue,
                  size: 40.0
                ),
                title: Text(_contacts[index].name.toUpperCase(),
                  style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_contacts[index].mobile),
                onTap: (){
                  setState(() {
                    _contact = _contacts[index];
                    _ctrlName.text = _contacts[index].name;
                    _ctrlmobile.text = _contacts[index].name;
                  });

                },
                ),

              Divider(
                height: 5.0,
              ),
            ]
          );
      },
        itemCount: _contacts.length,

      )

    ),
  );

}
