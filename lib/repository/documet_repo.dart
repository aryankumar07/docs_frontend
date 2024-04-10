import 'dart:convert';

import 'package:docs/constants/secrets.dart';
import 'package:docs/models/document_model.dart';
import 'package:docs/models/error_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final documetnRepProvider = Provider((ref)=>DocumentRepository(client: Client()));

class DocumentRepository {
  final Client _client;

  DocumentRepository({
    required Client client
    }) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel error = ErrorModel(error: 'Something went wrong please try again', data: null);
    try{
      final res = await _client.post(
        Uri.parse('$baseUri/doc/create'),
        headers: {
          'Content-Type' : 'application/json; charset=UTF-8',
          'x-auth-token' : token,
        },
        body: jsonEncode({
          "createdAt" : DateTime.now().millisecondsSinceEpoch
        })
        );

        // print('this is the status code for documet ${res.statusCode}');
        // print(jsonDecode(res.body));
        switch(res.statusCode){
          case 200 :
          final gotdata = jsonDecode(res.body);
            DocumentModel documentModel = DocumentModel(
              title: gotdata['document']['title'], 
              uid: gotdata['document']['uid'], 
              content: gotdata['document']['content'], 
              createdAt: DateTime.fromMillisecondsSinceEpoch(gotdata['document']['createdAt']), 
              id: gotdata['document']['_id']);
            error = ErrorModel(error: null, data: documentModel);
            // print('error model created');
            break;
          default:
          error = ErrorModel(error: null, data: null);
        }
    }catch(e){
      error = ErrorModel(error: e.toString(), data: null);
    }

    return error;


  }

  Future<ErrorModel> getDocuments(String token) async {
    ErrorModel error = ErrorModel(error: 'Something went wrong please try again', data: null);
    try{
      final res = await _client.get(
        Uri.parse('$baseUri/docs/me'),
        headers: {
          'Content-type':'application/json; charset=UTF-8',
          'x-auth-token' : token,
        }
      );
        // print('this is the status code for documet ${res.statusCode}');
        // print(jsonDecode(res.body)['docs'][0]['_id']);
        switch(res.statusCode){
          case 200 :
          List data = jsonDecode(res.body)['docs'];
          List<DocumentModel> documents = [];
          for(int i=0;i<data.length;i++){
            DocumentModel documentModel = DocumentModel(
              title: data[i]['title'], 
              uid: data[i]['uid'], 
              content: data[i]['content'], 
              createdAt: DateTime.fromMillisecondsSinceEpoch(data[i]['createdAt']), 
              id: data[i]['_id']);
            documents.add(documentModel);
          }
            // print(documents);
            error = ErrorModel(error: null, data: documents);
            // print('error model created');
            break;
          default:
          error = ErrorModel(error: null, data: null);
        }
    }catch(e){
      error = ErrorModel(error: e.toString(), data: null);
    }

    return error;


  }

  void updateTitle(String token,String title,String id) async {
    try{
      final res = await _client.post(
        Uri.parse('$baseUri/docs/title'),
        headers: {
          'Content-type':'application/json; charset=UTF-8',
          'x-auth-token' : token
        },
        body: jsonEncode({
          'id' : id,
          'title' : title,
        })
      ); 
    }catch(e){
      print(e);
    }
  }

  Future<ErrorModel> getDocumentByID(String token,String id)async{

    ErrorModel error = ErrorModel(error: 'something went wrong', data: null);
    try{
      final res = await _client.get(
        Uri.parse('$baseUri/docs/$id'),
        headers: {
          'Content-type':'application/json; charset=UTF-8',
          'x-auth-token' : token
        }
      );

      switch(res.statusCode){
        case 200:
          final data = jsonDecode(res.body)['doc'];
          print(data);
          DocumentModel document = DocumentModel(
            title: data['title'], 
            uid: data['uid'], 
            content: data['content'], 
            createdAt: DateTime.fromMicrosecondsSinceEpoch(data['createdAt']), 
            id: data['_id']);
          // DocumentModel document = DocumentModel(
          //   title: 'docs1', 
          //   uid: '6612e8d4d10ef5d7f12d0553', 
          //   content: [], 
          //   createdAt: DateTime.fromMicrosecondsSinceEpoch(1712592397034), 
          //   id: '661416106cbf90ecec8ed82a');
          //   print('documet created $document');
          error = ErrorModel(error: null, data: document);
          print(error);
          break;
      }
    }catch(e){
      error = ErrorModel(error: 'failed to get document by that id', data: null);
    }

    return error;
  }
}