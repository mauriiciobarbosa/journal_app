import 'package:flutter/material.dart';
import 'package:journal_app/blocs/login_bloc.dart';
import 'package:journal_app/services/authentication.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late LoginBloc _loginBloc;

  @override
  void initState() {
    _loginBloc = LoginBloc(AuthenticationService());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Icon(
            Icons.account_circle,
            size: 88,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder(
                stream: _loginBloc.email,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      icon: Icon(Icons.mail_outline),
                      errorText: snapshot.error?.toString(),
                    ),
                    onChanged: (email) => _loginBloc.emailChanged.add(email),
                  );
                },
              ),
              StreamBuilder(
                stream: _loginBloc.password,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      icon: Icon(Icons.security),
                      errorText: snapshot.error?.toString(),
                    ),
                    onChanged: (email) => _loginBloc.passwordChanged.add(email),
                  );
                },
              ),
              SizedBox(height: 48),
              _buildLoginAndCreateButtons(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  Widget _buildLoginAndCreateButtons() {
    return StreamBuilder(
      initialData: 'Login',
      stream: _loginBloc.loginOrCreateButton,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == 'Login') {
          return buttonsLogin();
        } else {
          return buttonsCreateAccount();
        }
      },
    );
  }

  Widget buttonsLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.enableLoginCreateButton,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ElevatedButton(
              child: Text('Login'),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(16),
                backgroundColor: MaterialStateProperty.all(
                  Colors.lightGreen.shade200,
                ),
                foregroundColor: MaterialStateProperty.all(
                  Colors.white,
                ),
              ),
              onPressed: snapshot.data
                  ? () => _loginBloc.loginOrCreateChanged.add('Login')
                  : null,
            );
          },
        ),
        TextButton(
          child: Text('Create Account'),
          onPressed: () {
            _loginBloc.loginOrCreateButtonChanged.add('Create Account');
          },
        ),
      ],
    );
  }

  Widget buttonsCreateAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.enableLoginCreateButton,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ElevatedButton(
              child: Text('Create Account'),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(16),
                backgroundColor: MaterialStateProperty.all(
                  Colors.lightGreen.shade200,
                ),
                foregroundColor: MaterialStateProperty.all(
                  Colors.white,
                ),
              ),
              onPressed: snapshot.data
                  ? () => _loginBloc.loginOrCreateChanged
                      .add('Create Account')
                  : null,
            );
          },
        ),
        TextButton(
          child: Text('Login'),
          onPressed: () {
            _loginBloc.loginOrCreateButtonChanged.add('Login');
          },
        ),
      ],
    );
  }
}
