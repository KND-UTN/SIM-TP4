import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:web_montecarlo/controllers/table_controller.dart';
import 'package:web_montecarlo/models/experiment.dart';
import 'package:web_montecarlo/widgets/custom_datatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TablePage extends StatefulWidget {
  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  @override
  void initState() {
    final tablePageController =
        Provider.of<TableController>(context, listen: false);
    tablePageController.controllerN.text = '0';
    tablePageController.controllerDesde.text = '0';
    tablePageController.controllerHasta.text = '0';
    tablePageController.controllerStock.text = '15';
    tablePageController.controllerQ.text = '15';
    tablePageController.controllerR.text = '10';
    tablePageController.controllerKo.text = '50';
    tablePageController.controllerKm.text = '5';
    tablePageController.controllerKs.text = '8';

    super.initState();
  }

  Future<List<Experiment>> _getExperiments(List<String> values) async {
    List<Experiment> list = [];

    final queryParams = {
      "inicial": values[3],
      "q": values[4],
      "r": values[5],
      "ko": values[6],
      "km": values[7],
      "ks": values[8],
      "desde": values[1],
      "hasta": values[2],
      "n": values[0]
    };

    print(queryParams);

    var uri = Uri.http('181.165.188.208:5000 ', '/procesar', queryParams);
    Response res = await http.get(uri);

    List data = jsonDecode(res.body);

    for (var row in data) {
      list.add(Experiment.fromJson(row));
    }
    return Future.value(list);
  }

  @override
  Widget build(BuildContext context) {
    final tablePageController = Provider.of<TableController>(context);

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
                    setState(() {});
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w100),
                      ))),
                ),
              ],
            ),
            Container(
              color: Colors.white70,
              width: 3,
              height: MediaQuery.of(context).size.height,
            ),
            Expanded(
              child: FutureBuilder(
                  future: _getExperiments([
                    tablePageController.controllerN.text,
                    tablePageController.controllerDesde.text,
                    tablePageController.controllerHasta.text,
                    tablePageController.controllerStock.text,
                    tablePageController.controllerQ.text,
                    tablePageController.controllerR.text,
                    tablePageController.controllerKo.text,
                    tablePageController.controllerKm.text,
                    tablePageController.controllerKs.text,
                  ]),
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
                          return Text('Complete todos los campos');
                        }

                        List<Experiment> list = [];
                        
                        list.addAll(snapshot.data!);

                        if (list.isNotEmpty) list.removeLast();

                        return Column(
                          children: [
                            Expanded(
                                flex: 5,
                                child: CustomDataTable(
                                  experiments: list,
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

class _DashBoard extends StatefulWidget {
  @override
  __DashBoardState createState() => __DashBoardState();
}

class __DashBoardState extends State<_DashBoard> {
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
                hintText: 'Ingrese N...',
                controller: tablePageController.controllerN,
                label: 'N:'),
            _DashBoardForm(
                hintText: 'Desde...',
                controller: tablePageController.controllerDesde,
                label: 'Desde:'),
            _DashBoardForm(
                hintText: 'Hasta...',
                controller: tablePageController.controllerHasta,
                label: 'Hasta:'),
            SizedBox(height: 30),
            _DashBoardForm(
                hintText: '',
                controller: tablePageController.controllerStock,
                label: 'Stock:'),
            _DashBoardForm(
                hintText: '',
                controller: tablePageController.controllerQ,
                label: 'Q:'),
            _DashBoardForm(
                hintText: '',
                controller: tablePageController.controllerR,
                label: 'R:'),
            _DashBoardForm(
                hintText: '',
                controller: tablePageController.controllerKo,
                label: 'Ko:'),
            _DashBoardForm(
                hintText: '',
                controller: tablePageController.controllerKm,
                label: 'Km:'),
            _DashBoardForm(
                hintText: '',
                controller: tablePageController.controllerKs,
                label: 'Ks:'),
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
