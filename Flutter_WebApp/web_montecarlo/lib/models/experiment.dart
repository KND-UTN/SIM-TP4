
// To parse this JSON data, do
//
//     final experiment = experimentFromJson(jsonString);

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:convert';

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

    int reloj;
    double rndDemanda;
    int demanda;
    double rndDemora;
    int demora;
    bool pedido;
    int llegada;
    int disponible;
    int stock;
    double ko;
    double km;
    double ks;
    double costoTotal;
    double costoAc;

    factory Experiment.fromJson(Map<String, dynamic> json) => Experiment(
        reloj: json["Reloj"],
        rndDemanda: json["RND Demanda"].toDouble(),
        demanda: json["Demanda"],
        rndDemora: json["RND Demora"].toDouble(),
        demora: json["Demora"],
        pedido: json["Pedido"],
        llegada: json["Llegada"],
        disponible: json["Disponible"],
        stock: json["Stock"],
        ko: json["Ko"].toDouble(),
        km: json["Km"].toDouble(),
        ks: json["ks"].toDouble(),
        costoTotal: json["Costo Total"].toDouble(),
        costoAc: json["Costo AC"],
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
        "ks": ks,
        "Costo Total": costoTotal,
        "Costo AC": costoAc,
    };
}


class ExperimentDataSource extends DataGridSource {

  List<DataGridRow> _experimentData = [];

  ExperimentDataSource({required List<Experiment> experimentData}) {
    _experimentData = experimentData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'Reloj', value: e.reloj),
              DataGridCell<double>(columnName: 'RND Demanda', value: e.rndDemanda),
              DataGridCell<int>(columnName: 'Demanda', value: e.demanda),
              DataGridCell<double>(columnName: 'RND Demora', value: e.rndDemora),
              DataGridCell<bool>(columnName: 'Pedido', value: e.pedido),
              DataGridCell<int>(columnName: 'Llegada', value: e.llegada),
              DataGridCell<int>(columnName: 'Disponible', value: e.disponible),
              DataGridCell<int>(columnName: 'Stock', value: e.stock),
              DataGridCell<double>(columnName: 'Ko', value: e.ko),
              DataGridCell<double>(columnName: 'Km', value: e.km),
              DataGridCell<double>(columnName: 'Ks', value: e.ks),
              DataGridCell<double>(columnName: 'Costo Total', value: e.costoTotal),
              DataGridCell<double>(columnName: 'Costo Acumulado', value: e.costoAc),              
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
