import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class TableController extends ChangeNotifier {

  TextEditingController _controllerN = TextEditingController();
  TextEditingController _controllerDesde = TextEditingController();
  TextEditingController _controllerHasta = TextEditingController();
  int _n = 0;
  int _desde = 0;
  int _hasta = 0;

  TextEditingController get controllerN => this._controllerN;
  TextEditingController get controllerDesde => this._controllerDesde;
  TextEditingController get controllerHasta => this._controllerHasta;
  int get n => this._n;
  int get desde => this._desde;
  int get hasta => this._hasta;

  set n(n) => _n = n;
  set desde(n) => _desde = n;
  set hasta(n) => _hasta = n;


}