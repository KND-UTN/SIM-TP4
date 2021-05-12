import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TableController extends ChangeNotifier {
  TextEditingController _controllerN = TextEditingController();
  TextEditingController _controllerDesde = TextEditingController();
  TextEditingController _controllerHasta = TextEditingController();
  TextEditingController _controllerQ = TextEditingController();
  TextEditingController _controllerR = TextEditingController();
  TextEditingController _controllerStock = TextEditingController();
  TextEditingController _controllerKo = TextEditingController();
  TextEditingController _controllerKm = TextEditingController();
  TextEditingController _controllerKs = TextEditingController();
  get controllerQ => this._controllerQ;

  set controllerQ(value) => this._controllerQ = value;

  get controllerR => this._controllerR;

  set controllerR(value) => this._controllerR = value;

  get controllerStock => this._controllerStock;

  set controllerStock(value) => this._controllerStock = value;

  get controllerKo => this._controllerKo;

  set controllerKo(value) => this._controllerKo = value;

  get controllerKm => this._controllerKm;

  set controllerKm(value) => this._controllerKm = value;

  get controllerKs => this._controllerKs;

  set controllerKs(value) => this._controllerKs = value;

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
