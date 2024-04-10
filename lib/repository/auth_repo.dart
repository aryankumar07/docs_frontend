import 'dart:convert';
import 'package:docs/constants/colors.dart';
import 'package:docs/constants/secrets.dart';
import 'package:docs/models/error_model.dart';
import 'package:docs/models/user_model.dart';
import 'package:docs/repository/local_store_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final AuthRepoProvider = Provider((ref) => AuthRepository(
  googleSignIn: GoogleSignIn(),
  client: Client(),
  localStrorage: LocalStrorage(),
  ));

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStrorage _localStrorage;
  AuthRepository({
    required GoogleSignIn googleSignIn,
    required Client client,
    required LocalStrorage localStrorage
  }) : _googleSignIn=googleSignIn,_client=client,_localStrorage=localStrorage ;

  Future<ErrorModel> signInWithGoole() async {
    ErrorModel error = ErrorModel(error: "Something went wrong try again", data: null);
    try{
      final user = await _googleSignIn.signIn();
      if(user!=null){
        final userAcc = UserModel(
          name: user.displayName??'', 
          email: user.email, 
          profilePic: user.photoUrl??'', 
          uid: '', 
          token: '');
      
      final res = await _client.post
      (Uri.parse('${baseUri}/api/signup'),
      body: userAcc.toJson(),
      headers: {
        'Content-Type' : 'application/json; charset=UTF-8'
      });

      switch(res.statusCode){
        case 200:
        final newuser = userAcc.copyWith(
          uid: jsonDecode(res.body)['user']['_id'],
          token: jsonDecode(res.body)['token'],
        );
        print('in the signingoogle status code');
        print(newuser.token);
        error = ErrorModel(error: null, data: newuser);
        _localStrorage.setToken(newuser.token);
        break;
      }
      }
    }catch(e){
      error = ErrorModel(error: e.toString(), data: null);
    }

    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(error: "Something went wrong try again", data: null);
    try{
      final String? token = await _localStrorage.getToken();
      print('the token is ${token}');
      if(token!=null){
        final res = await _client.get
        (Uri.parse('${baseUri}/'),
        headers: {
          'Content-Type' : 'application/json; charset=UTF-8',
          'x-auth-token' : token,
          });

          print(res.statusCode);
          print(jsonDecode(res.body));

        switch (res.statusCode) {
          case 200:
            print('start task');

            final data = jsonDecode(res.body);

            final newUser = UserModel(
              name: data['user']['name'], 
              email: data['user']['email'], 
              profilePic: data['user']['profilePic'], 
              uid: data['user']['_id'], 
              token: data['token']);

            //dummy data
            // final newUser = UserModel(
            // name: 'Aryan Kumar', 
            // email: 'ak2839426@gmail.com', 
            // profilePic: 'https://lh3.googleusercontent.com/a/ACg8ocItZYrxjSVBnzkb7yKF-VIMDJEawwrlmenm-qbmOQPbKIk', 
            // uid: '6612e8d4d10ef5d7f12d0553', 
            // token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2MTJlOGQ0ZDEwZWY1ZDdmMTJkMDU1MyIsImlhdCI6MTcxMjUxNTI4N30.pZkzrxIuc1YD3mVokI9GixlykmSiKmSvsPF05wp_7so');

            error = ErrorModel(error: null, data: newUser);
            print('complete task');
            break;
        }
      }
      }
      catch(e){
        error = ErrorModel(error: e.toString(), data: null);
      }
      return error;
    }

    void signout() async {
      await _googleSignIn.signOut();
      _localStrorage.setToken('');

    }


}