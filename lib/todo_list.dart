import 'package:flutter/material.dart';
import 'package:todo_app/loading.dart';
import 'package:todo_app/services/database_services.dart';

import 'model/todo.dart';

//stl
class TodoList extends StatefulWidget {

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  var backgroundApp = 'white';
  
  bool isComplet = false;
  TextEditingController todoTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child:StreamBuilder<List<Todo>>(
          stream: DatabaseService().listTodos(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Loading();
            }
            // print(snapshot.data![0].title);
            List<Todo>? todos = snapshot.data;
            return Padding(
              padding:EdgeInsets.all(25),
              child:Column(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("All todos",style: TextStyle(
                  color: Colors.white,
                  fontSize:30,
                  fontWeight:FontWeight.bold),
                ),
                Divider(),
                SizedBox(height: 20),
                ListView.separated(
                  separatorBuilder: (context,index) => Divider(color : Colors.grey[800]),
                  shrinkWrap: true,
                  itemCount:todos!.length,
                  itemBuilder: (context,index){
                    return Dismissible (
                    key:Key(todos![index].title),
                    background: Container(
                      padding: EdgeInsets.only(left:20),
                      alignment: Alignment.centerLeft,
                      child:Icon(Icons.delete),
                      color:Colors.red,
                    ),
                    onDismissed: (direction) async{
                     await DatabaseService().remoteTodo(todos![index].uid);
                    },
                  child: ListTile(
                  // return ListTile(
                    onTap: (){
                    DatabaseService().completTask(todos![index].uid);
                    },
                    leading: Container(
                      padding:EdgeInsets.all(2),
                      height:30,
                      width:30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle
                      ),
                      child: todos[index].isComplet ? Icon(Icons.check,color : Colors.white) : Container(),
                    ),
                    title: Text(todos![index].title,
                    style:TextStyle(
                      fontSize:20, 
                      fontWeight:FontWeight.w600,
                      color:Colors.grey[200],
                      decoration:  todos[index].isComplet ? TextDecoration.lineThrough:null
                      )),
                  ));
                }),
              ]),
            );
          }
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child:Icon(Icons.add),
        backgroundColor:Theme.of(context).primaryColor,
        onPressed: (){
          showDialog(
          builder: (context) => 
          SimpleDialog(
            contentPadding: EdgeInsets.symmetric(horizontal:25,vertical:20),
            backgroundColor:Colors.grey[800],
            shape:RoundedRectangleBorder(
              borderRadius:BorderRadius.circular(20),
            ),
            title:Row(
              children:[
                Text("Add Todo",style:TextStyle(fontSize:20,color:Colors.white,)),
                Spacer(),
                IconButton(
                  icon:Icon(
                    Icons.cancel,
                    color:Colors.grey,
                  ),
                  onPressed:()=> Navigator.pop(context)
                )
              ]
            ),
            children:[
              Divider(),
              TextFormField(
                controller: todoTitleController,
                style:TextStyle(
                  fontSize:18,
                  height:1.5,
                  color:Colors.white,
                ),
                autofocus:true,
                decoration:InputDecoration(
                  hintText:"eg. exercise",
                  hintStyle:TextStyle(
                    color:Colors.white70,
                  ),
                  border:InputBorder.none,
                )
              ),
              SizedBox(
                height:50,
                width:MediaQuery.of(context).size.width,
                child: FlatButton(
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("Add"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: ()async{
                    if(todoTitleController.text.isNotEmpty){
                     await DatabaseService().createNewTodo(todoTitleController.text.trim());
                     todoTitleController.text = '';
                     print(todoTitleController.text);
                      Navigator.pop(context);
                    }
                  }
                )
              )
            ]
          ), context: context,
         );
        },
      ),
    );
  }
}