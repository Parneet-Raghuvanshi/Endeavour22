import 'dart:async';

import 'package:endeavour22/marketwatch/main_model.dart';
import 'package:endeavour22/marketwatch/proifle_model.dart';
import 'package:endeavour22/marketwatch/stock_model.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class MarketWatchProvider with ChangeNotifier {
  ProfileModel? _model;
  List<StockModel> _stocks = [];
  List<MainModel> _mainStocks = [];
  int _totalWorth = 0;
  bool _isOpen = false;
  bool _finished = false;
  final _profileDB = FirebaseDatabase.instance.ref().child('marketProfile');
  final _stocksDB = FirebaseDatabase.instance.ref().child('marketStocks');
  final _toggleDB = FirebaseDatabase.instance
      .ref()
      .child('toggle')
      .child('marketWatchInternal');
  final _finishDB =
      FirebaseDatabase.instance.ref().child('toggle').child('marketWatch');
  late StreamSubscription<DatabaseEvent> _profileStream;
  late StreamSubscription<DatabaseEvent> _stocksStream;
  late StreamSubscription<DatabaseEvent> _toggleStream;
  late StreamSubscription<DatabaseEvent> _finishStream;

  ProfileModel? get profile => _model;
  List<StockModel> get stocks => _stocks;
  List<MainModel> get mainStocks => _mainStocks;
  bool get toggleStatus => _isOpen;
  bool get finished => _finished;
  int get totalWorth => _totalWorth;

  Future<void> fetchProfileModel(String userId) async {
    _profileStream = await _profileDB.child(userId).onValue.listen((event) {
      if (event.snapshot.value != null) {
        final profileData = ProfileModel.fromMap(event.snapshot.value as Map);
        _model = profileData;
        setupMainStocks();
      }
    });
  }

  Future<void> fetchStocks() async {
    _stocksStream = await _stocksDB.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final stocksData =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        _stocks = stocksData.values.map((e) => StockModel.fromMap(e)).toList();
        setupMainStocks();
      }
    });
  }

  Future<void> subscribeToToggle() async {
    _toggleStream = _toggleDB.onValue.listen((event) {
      if (event.snapshot.value == true) {
        _isOpen = true;
        notifyListeners();
      } else {
        _isOpen = false;
        notifyListeners();
      }
    });
  }

  Future<void> subscribeToFinish() async {
    _finishStream = _finishDB.onValue.listen((event) {
      if (event.snapshot.value == true) {
        _finished = false;
        notifyListeners();
      } else {
        _finished = true;
        notifyListeners();
      }
    });
  }

  void setupMainStocks() {
    if (_model != null) {
      _mainStocks.clear();
      _model!.company.forEach((element) {
        var stock = _stocks.firstWhere((e) => element.id == e.id);
        var mainData = MainModel(
          name: stock.name,
          id: element.id,
          rate: stock.rate,
          stocks: element.stocks,
          worth: element.stocks * stock.rate,
          isUp: stock.isUp,
        );
        _mainStocks.add(mainData);
      });
      calculateWorth();
    }
    notifyListeners();
  }

  Future<void> sellStocks(int qty, MainModel model, String userId) async {
    // UPDATE USER TOTAL AMOUNT AND WORTH
    int total = model.rate * qty;
    await _profileDB.child(userId).child('amount').set(_model!.amount + total);
    // UPDATE USER STOCKS...
    await _profileDB
        .child(userId)
        .child('company')
        .child(model.id)
        .child('stocks')
        .set(model.stocks - qty);
    calculateWorth();
  }

  Future<void> buyStocks(
      int qty, MainModel model, String userId, BuildContext context) async {
    // UPDATE USER TOTAL AMOUNT AND WORTH
    int total = model.rate * qty;
    if (total <= _model!.amount) {
      await _profileDB
          .child(userId)
          .child('amount')
          .set(_model!.amount - total);
      // UPDATE USER STOCKS...
      await _profileDB
          .child(userId)
          .child('company')
          .child(model.id)
          .child('stocks')
          .set(model.stocks + qty);
      calculateWorth();
    } else {
      showErrorFlush(
          context: context, message: "Don't have enough money to buy...");
    }
  }

  void calculateWorth() {
    _totalWorth = 0;
    _mainStocks.forEach((element) {
      _totalWorth += element.worth;
    });
  }

  @override
  void dispose() {
    _profileStream.cancel();
    _stocksStream.cancel();
    _toggleStream.cancel();
    _finishStream.cancel();
    super.dispose();
  }
}
