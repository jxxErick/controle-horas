import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:horas_v1/helpers/hour_helpers.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../models/hour.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Hour> listHours = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(user: widget.user),
      appBar: AppBar(
        title: Text('Horas V3'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: (listHours.isEmpty)
          ? const Center(
              child: Text('Nada por aqui.\nVamos registrar um dia de trabalho?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  )),
            )
          : ListView(
              padding: EdgeInsets.only(left: 4, right: 4),
              children: List.generate(
                listHours.length,
                (index) {
                  Hour model = listHours[index];
                  return Dismissible(
                    key: ValueKey<Hour>(model),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 12),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      remove(model);
                    },
                    child: Card(
                      elevation: 2,
                      child: Column(
                        children: [
                          ListTile(
                            onLongPress: () {},
                            onTap: () {},
                            leading: Icon(
                              Icons.list_alt_rounded,
                              size: 56,
                            ),
                            title: Text(
                                "Data: ${model.data} - Horas: ${HoursHelper.minutesToHours(model.minutos)}"),
                            subtitle: Text(model.descricao!),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }


  showFormModal(Hour? model){
    String title = "Adicionar";
    String confirmationButton = "Salvar";
    String skipButton = "Cancelar";

    TextEditingController dataController = TextEditingController();
    final dataMaskFormatter = MaskTextInputFormatter(mask: '##/##/####');
    TextEditingController minutesController = TextEditingController();
    final minutesMaskFormatter = MaskTextInputFormatter(mask: '##:##');
    TextEditingController descricaoController = TextEditingController();

    if(model != null){
      title = "Editar";
      confirmationButton = "Atualizar";
      dataController.text = model.data;
      minutesController.text = HoursHelper.minutesToHours(model.minutos);
      if(model.descricao != null){
        descricaoController.text = model.descricao!;
      }
    }

    showModalBottomSheet(context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (context){
      return Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall,),
            TextFormField(
              controller: dataController,
              inputFormatters: [dataMaskFormatter],
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: 'Data',
                hintText: 'DD/MM/AAAA',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: minutesController,
              inputFormatters: [minutesMaskFormatter],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Horas',
                hintText: 'HH:MM',
              ),
            ),
            SizedBox(height: 16,),
            TextFormField(
              controller: descricaoController,
              decoration: InputDecoration(
                labelText: 'Descrição',
              ),
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text(skipButton)),
                SizedBox(width: 8,),
                ElevatedButton(onPressed: () {}, child: Text(confirmationButton),),
              ],
            ),
            SizedBox(height: 180,)
          ],
        )
      );
    },
    );
  }

  void remove(Hour model) {}

}
