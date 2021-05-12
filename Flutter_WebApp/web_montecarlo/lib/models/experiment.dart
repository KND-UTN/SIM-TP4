
// To parse this JSON data, do
//
//     final experiment = experimentFromJson(jsonString);

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:convert';

import 'package:web_montecarlo/helpers/helpers.dart';

Experiment experimentFromJson(String str) => Experiment.fromJson(json.decode(str));

String experimentToJson(Experiment data) => json.encode(data.toJson());

class Experiment {
    Experiment({
        required this.reloj,
        required this.rndDemanda,
        required this.demanda,
        required this.rndDemora,
        required this.demora,
        required this.pedido,
        required this.llegada,
        required this.disponible,
        required this.stock,
        required this.ko,
        required this.km,
        required this.ks,
        required this.costoTotal,
        required this.costoAc,
    });

    String reloj;
    String rndDemanda;
    String demanda;
    String rndDemora;
    String demora;
    String pedido;
    String llegada;
    String disponible;
    String stock;
    String ko;
    String km;
    String ks;
    String costoTotal;
    String costoAc;

    factory Experiment.fromJson(Map<String, dynamic> json) => Experiment(
        reloj: json["Reloj"].toString(),
        rndDemanda: trunc(json["RND Demanda"].toString()),
        demanda: json["Demanda"].toString(),
        rndDemora: json["RND Demora"] != 0 ? trunc(json["RND Demora"].toString()) : '', 
        demora: json["Demora"] != null ? json["Demora"].toString() : '',
        pedido: json["Pedido"] ? 'SI' : 'NO',
        llegada: json["Llegada"] != null ? json["Llegada"].toString() : '',
        disponible: json["Disponible"] != 0 ? json["Disponible"].toString() : '',
        stock: json["Stock"] != null ? json["Stock"].toString() : '',
        ko: json["Ko"].toString(),
        km: json["Km"].toString(),
        ks: json["Ks"].toString(),
        costoTotal: json["Costo Total"].toString(),
        costoAc: json["Costo AC"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "Reloj": reloj,
        "RND Demanda": rndDemanda,
        "Demanda": demanda,
        "RND Demora": rndDemora,
        "Demora": demora,
        "Pedido": pedido,
        "Llegada": llegada,
        "Disponible": disponible,
        "Stock": stock,
        "Ko": ko,
        "Km": km,
        "Ks": ks,
        "Costo Total": costoTotal,
        "Costo AC": costoAc,
    };
}


class ExperimentDataSource extends DataGridSource {

  List<DataGridRow> _experimentData = [];

  ExperimentDataSource({required List<Experiment> experimentData}) {
    _experimentData = experimentData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'Reloj', value: e.reloj),
              DataGridCell<String>(columnName: 'RND Demanda', value: e.rndDemanda),
              DataGridCell<String>(columnName: 'Demanda', value: e.demanda),
              DataGridCell<String>(columnName: 'RND Demora', value: e.rndDemora),
              DataGridCell<String>(columnName: 'Demora', value: e.demora),
              DataGridCell<String>(columnName: 'Pedido', value: e.pedido),
              DataGridCell<String>(columnName: 'Llegada', value: e.llegada),
              DataGridCell<String>(columnName: 'Disponible', value: e.disponible),
              DataGridCell<String>(columnName: 'Stock', value: e.stock),
              DataGridCell<String>(columnName: 'Ko', value: e.ko),
              DataGridCell<String>(columnName: 'Km', value: e.km),
              DataGridCell<String>(columnName: 'Ks', value: e.ks),
              DataGridCell<String>(columnName: 'Costo Total', value: e.costoTotal),
              DataGridCell<String>(columnName: 'Costo Acumulado', value: e.costoAc),              
            ]))
        .toList();
  }
  
  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }

  @override
  List<DataGridRow> get rows => _experimentData;

  

}
