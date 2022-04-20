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
  final _profileDB =
      FirebaseDatabase.instance.reference().child('marketProfile');
  final _stocksDB = FirebaseDatabase.instance.reference().child('marketStocks');
  late StreamSubscription<DatabaseEvent> _profileStream;
  late StreamSubscription<DatabaseEvent> _stocksStream;

  ProfileModel? get profile => _model;
  List<StockModel> get stocks => _stocks;
  List<MainModel> get mainStocks => _mainStocks;

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
    } else {
      showErrorFlush(
          context: context, message: "Don't have enough money to buy...");
    }
  }

  @override
  void dispose() {
    _profileStream.cancel();
    _stocksStream.cancel();
    super.dispose();
  }
}
