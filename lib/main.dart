import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:journal_app/blocs/authentication_bloc.dart';
import 'package:journal_app/blocs/authentication_bloc_provider.dart';
import 'package:journal_app/blocs/home_bloc.dart';
import 'package:journal_app/blocs/home_bloc_provider.dart';
import 'package:journal_app/pages/home.dart';
import 'package:journal_app/pages/login.dart';
import 'package:journal_app/services/authentication.dart';
import 'package:journal_app/services/db_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        } else if (snapshot.hasError) {
          return Center(child: Text('deu ruim meu pivete :('));
        } else {
          return _buildSuccess();
        }
      },
    );
  }

  Container _buildLoading() {
    return Container(
      color: Colors.lightGreen,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildSuccess() {
    final authenticationService = AuthenticationService();
    final authenticationBloc = AuthenticationBloc(
      authenticationApi: authenticationService,
    );

    return AuthenticationBlocProvider(
      child: StreamBuilder(
        initialData: null,
        stream: authenticationBloc.user,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          } else if (snapshot.hasData && snapshot.data != '') {
            return HomeBlocProvider(
              homeBloc: HomeBloc(
                authenticationApi: authenticationService,
                dbApi: DbFirestoreService(),
              ),
              child: _buildMaterialApp(Home()),
              uid: snapshot.data.toString(),
            );
          } else {
            return _buildMaterialApp(Login());
          }
        },
      ),
      authenticationBloc: authenticationBloc,
    );
  }

  MaterialApp _buildMaterialApp(Widget homePage) {
    return MaterialApp(
      title: 'Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        canvasColor: Colors.lightGreen.shade50,
        bottomAppBarColor: Colors.lightGreen,
      ),
      home: homePage,
    );
  }
}
