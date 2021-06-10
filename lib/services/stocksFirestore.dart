import 'dart:core';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smsflutter/models/currency.dart';
import 'package:smsflutter/models/mystock.dart';
import 'package:smsflutter/models/mystockgroup.dart';
import 'package:smsflutter/models/stock.dart';
import 'package:smsflutter/services/auth.dart';
import 'package:charts_flutter/flutter.dart';

// Class used to communicate with Firestore database
class StocksFirestore {
  final CollectionReference stocks = Firestore.instance.collection('stocks');
  final CollectionReference myStocks =
      Firestore.instance.collection('mystocks');
  final CollectionReference budgets = Firestore.instance.collection('budgets');
  // Shared by all instances in order to keep the same value across the app
  static num userBudget;
  // Needed to update the right user's budget
  static String _budgetID;
  // Needed to initialize the currency value with the one saved as preferences
  Currency _currencyDummy = Currency();

  // Get the current logged in user's budget as stream
  Stream<num> get budget {
    Query query = budgets.where('userid', isEqualTo: Auth().userID);
    return query.snapshots().map(_toBudget);
  }

  // Get the list of available stocks on the market as stream
  Stream<List<Stock>> get stocksList {
    return stocks.snapshots().map(_toStock);
  }

  // Get the list of current logged in user owned stocks as stream
  Stream<List<MyStock>> get myStockList {
    Query query = myStocks.where('userid', isEqualTo: Auth().userID);
    return query.snapshots().map(_toMyStock);
  }

  // Get a specific stock price to show the current price on sell option
  Stream<num> getMyStock(String myStockShortName) {
    Query query = stocks.where('shortname', isEqualTo: myStockShortName);
    return query.snapshots().map(_toNum);
  }

  // Get the list of current logged in user owned stocks as stream, used for statistics
  Stream<List<MyStockGroup>> getMyStockGroup() {
    Query query = myStocks.where('userid', isEqualTo: Auth().userID);
    return query.snapshots().map(_toGroup);
  }

  // Insert a stock into the list of current looged in user; buy process
  Future insertMyStock({Stock stock, num quantity}) async {
    // Only integer values allowed, slider returns double
    quantity = quantity.round();
    if (Currency.lang != 'ro') {
      if (userBudget - stock.nowPrice.toDouble() * quantity >= 0)
        await budgets.document(_budgetID).updateData(
            {'budget': userBudget - stock.nowPrice.toDouble() * quantity});
      else
        throw Exception();
    }
    // If Ro is the language, convert the budget and the nowPrice to euro
    else {
      if (userBudget / Currency.currency -
              stock.nowPrice.toDouble() / Currency.currency * quantity >=
          0)
        await budgets.document(_budgetID).updateData({
          'budget': userBudget / Currency.currency -
              stock.nowPrice.toDouble() / Currency.currency * quantity
        });
      else
        throw Exception();
    }
    // Exceptions are thrown because the process should end if the user doesn't have enough money

    // Find the stock to add to the same group or insert a new one if none exists
    Query query = myStocks
        .where('userid', isEqualTo: Auth().userID)
        .where('buyprice',
            isEqualTo: Currency.lang != 'ro'
                ? stock.nowPrice
                : stock.nowPrice / Currency.currency)
        .where('shortname', isEqualTo: stock.shortName);

    // If Ro, the RonRate matters for grouping
    if (Currency.lang == 'ro')
      query = query.where('ronrate', isEqualTo: Currency.currency);
    QuerySnapshot snapshot = await query.getDocuments();
    DocumentSnapshot doc =
        snapshot.documents.firstWhere((doc) => doc.exists, orElse: () => null);
    if (doc != null)
      await myStocks.document(doc.documentID).updateData({
        'quantity': doc.data['quantity'] + quantity,
      });
    else
      await myStocks.document().setData({
        'buyprice': Currency.lang != 'ro'
            ? stock.nowPrice
            : stock.nowPrice / Currency.currency,
        'imageuri': stock.imageUri,
        'longname': stock.longName,
        'shortname': stock.shortName,
        'quantity': quantity,
        'ronrate': Currency.currency,
        'userid': Auth().userID
      });
  }

  // Used to update a specific stock owned by the current logged in user; sell process
  Future updateMyStock({MyStock myStock, num quantity}) async {
    // Only integer values allowed, slider returns double
    quantity = quantity.round();
    // Delete if the users sells all of the specific actions
    if (myStock.quantity == quantity)
      await myStocks.document(myStock.myStockId).delete();
    else
      await myStocks
          .document(myStock.myStockId)
          .updateData({'quantity': myStock.quantity - quantity});

    // Convert prices depending on the system language
    await budgets.document(_budgetID).updateData({
      'budget': Currency.lang != 'ro'
          ? userBudget + myStock.buyPrice.toDouble() * quantity
          : userBudget / Currency.currency +
              myStock.buyPrice.toDouble() / Currency.currency * quantity
    });
  }

  // Method used for grouping actions in order to create the chart properly
  List<MyStockGroup> _toGroup(QuerySnapshot snapshot) {
    List<MyStockGroup> list = <MyStockGroup>[];
    List<MyStock> listMyStock = <MyStock>[];

    for (var doc in snapshot.documents) {
      listMyStock.add(MyStock(
          myStockId: doc.documentID,
          shortName: doc.data['shortname'],
          longName: doc.data['longname'],
          buyPrice: doc.data['buyprice'],
          imageUri: doc.data['imageuri'],
          quantity: doc.data['quantity'],
          ronRate: doc.data['ronrate']));
    }
    for (var myStock in listMyStock) {
      // Check if the group already exists
      MyStockGroup myStockGroup = list.firstWhere(
          (element) => element.name == myStock.shortName,
          orElse: () => null);
      if (myStockGroup != null)
        myStockGroup.quantity += myStock.quantity;
      else
        list.add(MyStockGroup(
            name: myStock.shortName,
            quantity: myStock.quantity,
            colorOfBar: Color(
                r: Random().nextInt(254) + 1,
                g: Random().nextInt(254) + 1,
                b: Random().nextInt(254) + 1)));
    }

    return list;
  }

  // Method used to convert each market stock received from the db
  // Prices are changed ONLY inside the app, not inside the db
  List<Stock> _toStock(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((doc) => Stock(
            shortName: doc.data['shortname'],
            longName: doc.data['longname'],
            nowPrice: Currency.lang != 'ro'
                ? doc.data['nowprice']
                : doc.data['nowprice'] * Currency.currency,
            oldPrice: Currency.lang != 'ro'
                ? doc.data['oldprice']
                : doc.data['oldprice'] * Currency.currency,
            statistic: Currency.lang != 'ro'
                ? (doc.data['nowprice'] - doc.data['oldprice'])
                    .toStringAsFixed(2)
                : (doc.data['nowprice'] * Currency.currency -
                        doc.data['oldprice'] * Currency.currency)
                    .toStringAsFixed(2),
            imageUri: doc.data['imageuri'],
            companyDescription: doc.data['companydescription']))
        .toList();
  }

  // Method used to convert the nowPrice of a stock, used for showing the
  // user the current price when sell process is started
  num _toNum(QuerySnapshot snapshot) {
    var doc = snapshot.documents.firstWhere(
        (element) => element.data['shortname'] != null,
        orElse: () => null);
    if (doc != null) {
      if (Currency.lang == 'ro')
        return doc.data['nowprice'] * Currency.currency;
      else
        return doc.data['nowprice'];
    } else
      return 0;
  }

  // Method used to convert each owned stock received from the db
  // Prices are changed ONLY inside the app, not inside the db
  List<MyStock> _toMyStock(QuerySnapshot snapshot) {
    return snapshot.documents
        .map(
          (doc) => MyStock(
              myStockId: doc.documentID,
              shortName: doc.data['shortname'],
              longName: doc.data['longname'],
              buyPrice: Currency.lang != 'ro'
                  ? doc.data['buyprice']
                  : doc.data['buyprice'] * doc.data['ronrate'],
              imageUri: doc.data['imageuri'],
              quantity: doc.data['quantity'],
              ronRate: doc.data['ronrate']),
        )
        .toList();
  }

  // Method used to convert the budget received from the db
  // Values are changed ONLY inside the app, not inside the db
  num _toBudget(QuerySnapshot snapshot) {
    var doc = snapshot.documents.firstWhere(
        (element) => element.data['budget'] >= 0,
        orElse: () => null);
    if (doc != null) {
      if (Currency.lang == 'ro')
        userBudget = doc.data['budget'] * Currency.currency;
      else
        userBudget = doc.data['budget'];
      _budgetID = doc.documentID;
      return userBudget;
    } else
      return 0;
  }
}
