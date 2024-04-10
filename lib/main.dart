import 'package:docs/models/error_model.dart';
import 'package:docs/repository/auth_repo.dart';
import 'package:docs/router.dart';
import 'package:docs/screens/home_screen.dart';
import 'package:docs/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: Myapp()));
}

class Myapp extends ConsumerStatefulWidget{

  Myapp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MyappState();
  }
}

class _MyappState extends ConsumerState<Myapp>{

  ErrorModel? errormodel;

  @override
  void initState() {
    super.initState();
    getuserdata();
  }

  void getuserdata() async {
    print('checking for user');
    errormodel = await ref.read(AuthRepoProvider).getUserData();
    if( errormodel!=null && errormodel!.data !=null){
      ref.read(userProvider.notifier).update((state) => errormodel!.data);
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Docs",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context){
        final user = ref.watch(userProvider);
        if(user!=null && user.token.isNotEmpty){
          return loggedInRoute;
        }
        return loggedOutRoute;
      }),
      routeInformationParser: const  RoutemasterParser(),
    );
  }
}