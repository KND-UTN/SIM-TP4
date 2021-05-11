import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_montecarlo/controllers/table_controller.dart';
import 'package:web_montecarlo/models/experiment.dart';
import 'package:web_montecarlo/widgets/custom_datatable.dart';
import 'package:http/http.dart' as http;

class TablePage extends StatefulWidget {
  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {

  int n = 0;
  int desde = 0;
  int hasta = 0;


  Future<List<Experiment>> _getExperiments() async {


     // mandar n, desde, hasta.
     //var url = Uri.parse('https://example.com/whatsit/create');
     // ar data = await http.post(url, body: {'name': 'doodle', 'color': 'blue'});

    var data = {
      "Reloj": 0,
      "RND Demanda": 0.45,
      "Demanda": 4,
      "RND Demora": 0.65,
      "Demora": 6,
      "Pedido": true,
      "Llegada": 7,
      "Disponible": 15,
      "Stock": 15,
      "Ko": 45.3,
      "Km": 324.4,
      "ks": 50.3,
      "Costo Total": 23.5,
      "Costo AC": 0.0
    };

    // return data;

    return Future.delayed(Duration(milliseconds: 1000)).then((value) => Future.value([Experiment.fromJson(data)]));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 200,
          leading: Center(
            child: Text(
              'Ejercicio 8 - Stock',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          toolbarHeight: 70,
          title: Center(
              child: Text(
            'MonteCarlo',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
        body: Row(
          children: [
            Column(
              children: [
                _DashBoard(),
                InkWell(
                onTap: () {

                  final tablePageController = Provider.of<TableController>(context, listen: false);

                  n = int.parse(tablePageController.controllerN.text);
                  desde = int.parse(tablePageController.controllerDesde.text);
                  hasta = int.parse(tablePageController.controllerHasta.text);





                  setState(() {
                  });      
                },
                child: Container(
                    height: 40,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.red[300],
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                        child: Text(
                      'Test',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w100),
                    ))))
              ],
            ),
            Container(
              color: Colors.white,
              width: 3,
              height: MediaQuery.of(context).size.height,
            ),
            Expanded(
              child: FutureBuilder(
                future: _getExperiments(),
                builder:
                  (context, AsyncSnapshot<List<Experiment>?> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Error');

                    }
                    return Column(
                      children: [
                        Expanded(
                            flex: 5,
                            child: CustomDataTable(
                              experiments: snapshot.data!,
                            )),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              'Resultado',
                              style: TextStyle(fontSize: 25),
                            )),
                        Expanded(
                            flex: 1,
                            child: CustomDataTable(
                              experiments: snapshot.data!.isEmpty
                                  ? []
                                  : [snapshot.data!.last],
                            )),
                      ],
                    );
                }
              }),
            ),
          ],
        ));
  }
}

class _DashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final tablePageController = Provider.of<TableController>(context);
    

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _DashBoardForm(
                hintText: 'Ingrese N...', controller: tablePageController.controllerN, label: 'N:'),
            _DashBoardForm(
                hintText: 'Desde...',
                controller: tablePageController.controllerDesde,
                label: 'Desde:'),
            _DashBoardForm(
                hintText: 'Hasta...',
                controller: tablePageController.controllerHasta,
                label: 'Hasta:'),
            SizedBox(
              height: 20,
            ),
            
          ],
        ),
      ),
    );
  }
}

class _DashBoardForm extends StatelessWidget {
  final String hintText;
  final String label;
  final TextEditingController controller;

  _DashBoardForm({
    required this.hintText,
    required this.controller,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 30,
          ),
          SizedBox(
            width: 200,
            child: Container(
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(5)),
              child: TextField(
                controller: controller,
                decoration: new InputDecoration(
                    labelStyle: TextStyle(fontSize: 16),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 14, top: 11, right: 15),
                    hintText: hintText),
              ),
            ),
          )
        ],
      ),
    );
  }
}
