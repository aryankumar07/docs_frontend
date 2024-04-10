import 'package:docs/constants/colors.dart';
import 'package:docs/models/error_model.dart';
import 'package:docs/repository/auth_repo.dart';
import 'package:docs/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerWidget{

  void signInWithGoole(WidgetRef ref,BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    ErrorModel result = await ref.read(AuthRepoProvider).signInWithGoole();
    if(result.error==null){
      ref.watch(userProvider.notifier).update((state) => result.data);
      navigator.replace(
        '/'
      );
    }else{
      sMessenger.showSnackBar(
        SnackBar(content: Text(result.error!)),
      );
    }
  }


  @override
  Widget build(BuildContext context,WidgetRef ref) { 
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: ()=>signInWithGoole(ref,context), 
          icon: Image.asset('assets/images/g-logo-2.png',height: 20,), 
          label: Text(
            'Sign With Google',
            style: TextStyle(
              color: BlackColor,
            ),
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(150, 50),
            backgroundColor: WhiteColor,
          ),
          ),
          ),
    );
  }
}