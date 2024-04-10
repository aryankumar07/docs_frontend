import 'package:docs/constants/colors.dart';
import 'package:docs/models/document_model.dart';
import 'package:docs/models/error_model.dart';
import 'package:docs/repository/auth_repo.dart';
import 'package:docs/repository/documet_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {

  TextEditingController titleController = TextEditingController(text: 'untitled Document');

  QuillController _controller = QuillController.basic();

  ErrorModel? error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchdocumetdata();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
  }

  void updateTitle(WidgetRef ref,String title){
      print('updating title');
      String token = ref.read(userProvider)!.token;
      ref.read(documetnRepProvider).updateTitle(token, title, widget.id);
      // setState(() {
      // titleController.text = title;
      // print('chainging title');
      // });
  }

  void fetchdocumetdata() async {
    print('fetching document');
    String token = ref.read(userProvider)!.token;
    error = await ref.read(documetnRepProvider).getDocumentByID(token, widget.id);

    if(error!.data!!=null){
      titleController.text = (error!.data as DocumentModel).title;
      setState(() {});
    }

  }

  

  

  @override
  Widget build(BuildContext context) { 

    return Scaffold(
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(top: 10,left: 10,bottom: 10,right: 110),
          //   child: ElevatedButton.icon(
          //     onPressed: (){}, 
          //     icon: Icon(Icons.edit_document,size: 16,color: BlueColor,), 
          //     label: Text('Editable Document',style: TextStyle(color: BlackColor),),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: WhiteColor,
          //       elevation: 0,
          //     ),
          //     ),
          // ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: (){}, 
              icon: Icon(Icons.lock,size: 16,), 
              label: Text('Share'),
              style: ElevatedButton.styleFrom(
                backgroundColor: BlueColor
              ),
              ),
          ),
        ],
        title: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/images/docs-logo.png',
                    height: 40,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: BlueColor,
                        ),
                      ),
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                    onSubmitted: (value)=>updateTitle(ref, value),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1), 
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: GreyColor,
                width: .5
              )
            ),
          )),
      ),
      body: QuillProvider(
  configurations: QuillConfigurations(
    controller: _controller,
    sharedConfigurations: const QuillSharedConfigurations(
      locale: Locale('de'),
    ),
  ),
  child: Column(
    children: [
      const QuillToolbar(),
      Expanded(
        child: QuillEditor.basic(
          configurations: const QuillEditorConfigurations(
            readOnly: false,
          ),
        ),
      )
    ],
  ),
)
    ); 
  }
}