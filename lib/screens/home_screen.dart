import 'package:docs/constants/colors.dart';
import 'package:docs/constants/secrets.dart';
import 'package:docs/constants/widgets/loader.dart';
import 'package:docs/models/document_model.dart';
import 'package:docs/models/error_model.dart';
import 'package:docs/repository/auth_repo.dart';
import 'package:docs/repository/documet_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';



class HomeScreen extends ConsumerWidget{

  HomeScreen({super.key});


  void signOut(WidgetRef ref){
    ref.read(AuthRepoProvider).signout();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(WidgetRef ref,BuildContext context) async {
    String token  = ref.read(userProvider)!.token;
    if(token != null){
      final navigator = Routemaster.of(context);
      final snackBar = ScaffoldMessenger.of(context);

    final ErrorModel res = await ref.read(documetnRepProvider).createDocument(token);
    // print('created an error model');
    // print(res.data);

      if(res.data != null){
        navigator.push('/document/${res.data.id}'); 
      }else{
        snackBar.showSnackBar(SnackBar(content: Text(res.error!  )));
      }
    }
  }

  void navigaeToDocument(BuildContext context,String documentID){
    Routemaster.of(context).push('/document/$documentID');
  }

  // void getData(WidgetRef ref) async {
  //   print('button pressed');
  //   String token  = ref.read(userProvider)!.token;
  //   ErrorModel error = await ref.read(documetnRepProvider).getDocuments(token);
  // }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        actions: [
          IconButton(
          onPressed: ()=>createDocument(ref, context),  
          icon: Icon(Icons.add,color: BlackColor,)),
          IconButton(
            onPressed: ()=>signOut(ref), 
            icon: Icon(Icons.logout,color: RedColor,)),
        ],
      ),
      body: FutureBuilder(
        future: ref.read(documetnRepProvider)
        .getDocuments(ref.watch(userProvider)!.token), 
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return  Loader();
          }

          return ListView.builder(
            itemCount: snapshot.data!.data.length,
            itemBuilder: (context,index){
              DocumentModel documet = snapshot.data!.data[index]; 
              return InkWell(
                onTap: ()=>navigaeToDocument(context, documet.id),
                child: SizedBox(
                  height: 100,
                  child: Card(
                    child: Center(
                      child: Text(
                        documet.title,
                        style: TextStyle(
                          fontSize: 18
                        ),
                        ),
                    ),
                  ),
                ),
              );
            });
        })
    );
  }
}