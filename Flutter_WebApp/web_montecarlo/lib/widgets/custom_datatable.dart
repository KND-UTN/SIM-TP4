import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_montecarlo/models/experiment.dart';

class CustomDataTable extends StatefulWidget {
  @override
  _CustomDataTableState createState() => _CustomDataTableState();

  late final List<Experiment> experiments;

  CustomDataTable({required this.experiments});
}

class _CustomDataTableState extends State<CustomDataTable> {
 
  late ExperimentDataSource _expDataSource;

  @override
  void initState() {
    super.initState();
    
    _expDataSource = ExperimentDataSource(experimentData: widget.experiments);
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid  (
      source: _expDataSource,
      columnWidthMode: ColumnWidthMode.fill,
      columns: <GridColumn>[
        GridTextColumn(
            columnName: 'Reloj',
            label: Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: Text(
                  'Reloj',
                ))),
        GridTextColumn(
            columnName: 'RND Demanda',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('RND Demanda'))),
        GridTextColumn(
            columnName: 'Demanda',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  'Demanda',
                  overflow: TextOverflow.ellipsis,
                ))),
        GridTextColumn(
            columnName: 'RND Demora',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('RND Demora'))),
        GridTextColumn(
            columnName: 'Pedido',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Pedido'))),
        GridTextColumn(
            columnName: 'Llegada',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Llegada'))),
        GridTextColumn(
            columnName: 'Disponible',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Disponible'))),
        GridTextColumn(
            columnName: 'Stock',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Stock'))),
        GridTextColumn(
            columnName: 'Ko',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Ko'))),
        GridTextColumn(
            columnName: 'Km',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Km'))),
        GridTextColumn(
            columnName: 'Ks',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Ks'))),
        GridTextColumn(
            columnName: 'Costo Total',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Costo Total'))),
        GridTextColumn(
            columnName: 'Costo Acumulado',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Costo Acumulado'))),
      ],
    );
  }
}
