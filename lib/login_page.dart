import 'package:flutter/material.dart';
import 'package:loginfirebaseexample/auth_provider.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.onSignedIn});

  final VoidCallback onSignedIn;
  
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

enum FormType{
  login,
  register,
}

class _LoginPageState extends State<LoginPage>{

  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave(){
    final form = formKey.currentState;
    if (form.validate()){
      formKey.currentState.save();
      return true;
    }
      return false;
    
  }
  void validateAndSubmit() async{

    if (validateAndSave()){
        //authenticate with firebase
        try {
          var auth = AuthProvider.of(context).auth;
          if(_formType == FormType.login){
            String userId = await auth.signInWithEmailAndPassword(_email, _password);
            print('Signed in: $userId');
          }else{
            String userId = await auth.createUserWithEamilAndPassword(_email, _password);
            print('Registered user: $userId');
          }
          widget.onSignedIn();
        }
        catch (e) {
          print('print $e');
          print('error');
        }
    } else {
      print('did not pass the validation somehow');
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Flutter login demo"),

      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInputs() + buildSubmitButtons(),
          ),
        ),
      ),
    );
  }

List<Widget> buildInputs(){
  return [
    new TextFormField(
    decoration: new InputDecoration(labelText: 'Email'),
      validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
      onSaved: (value) => _email = value,
    ),
    new TextFormField(
      decoration: new InputDecoration(labelText: 'Password'),
      validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
      obscureText: true,
      onSaved: (value) => _password = value,
    ),
  ];
}

List<Widget> buildSubmitButtons(){
  if(_formType == FormType.login){
    return[
      new RaisedButton(
      child: new Text("Login", style: TextStyle(fontSize: 18.0)),
      onPressed: validateAndSubmit,
      ),
      new FlatButton(
      child: new Text('Create an account',style: new TextStyle(fontSize: 18.0)),
      onPressed: moveToRegister,
      ),
    ];
  }else{
    return[
      new RaisedButton(
      child: new Text("Create an account", style: TextStyle(fontSize: 18.0)),
      onPressed: validateAndSubmit,
      ),
      new FlatButton(
      child: new Text('Have an account? Login',style: new TextStyle(fontSize: 18.0)),
      onPressed: moveToLogin,
      ),
    ];
  }
}


}