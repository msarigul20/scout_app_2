import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/auth.dart';
class LoginPage extends StatefulWidget {
  LoginPage({this.auth,this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;


  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print("Form is valid. Email : $_email and Password: $_password. ");
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {

    if (validateAndSave()) {
      try {
        if(_formType == FormType.login) {
          String userId = await widget.auth.signInWithEmailAndPassword(
              _email,_password);
          print("Signed in : $userId");
        } else {
          String userId = await widget.auth.createUserWithEmailAndPassword(_email, _password);
          print("Registered user : $userId");
        }
        widget.onSignedIn();

      }
      catch (e) {
        print("Error : $e");
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }
  void moveToLogin(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;

    });
  }
  bool passwordVis = true;
  void visibility() {
    setState(() {
      passwordVis = !passwordVis;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Scout Manager"),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: SingleChildScrollView(
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Center(
                    child: Column(
                      children: showLogo()+buildInputs() + buildSubmitButtons(),
                    ),
                  )

                ],),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {

    return [
      new TextFormField(

        decoration: new InputDecoration(labelText: 'Email',
        suffixIcon: Icon(Icons.email)),
        validator: (value) => value.isEmpty || !value.contains('@') ? 'Email is required.' : null,
        onSaved: (value) => _email = value,


      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password',
        suffixIcon: IconButton(
          onPressed: (){
            visibility();
          },
          icon: passwordVis ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
        )),
        obscureText: passwordVis,
        validator: (value) => value.isEmpty || value.length < 6 ? 'at least 6 characters' : null,
        onSaved: (value) => _password = value,
      )
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
          child: new Text("Login", style: new TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text('Create an account',
              style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToRegister,
        )
      ];
    } else {
      return [
        new RaisedButton(
          child: new Text("Create an account", style: new TextStyle(fontSize: 20.0)),
          onPressed:                                                                              validateAndSubmit,

        ),
        new FlatButton(
          child: new Text('Have an account ? Login',
          style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToLogin,
        )
      ];
    }
  }

  List<Widget> showLogo() {
    return [
      new Container(
        child:Image(height: 150,width: 150,image: AssetImage('assets/images/appLogo.png')),
      )
    ];
  }


}
