import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smsflutter/models/currency.dart';
import 'package:smsflutter/models/mystock.dart';
import 'package:smsflutter/models/mystockgroup.dart';
import 'package:smsflutter/models/stock.dart';
import 'package:smsflutter/services/auth.dart';

class StocksFirestore {
  final CollectionReference stocks = Firestore.instance.collection('stocks');
  final CollectionReference myStocks =
      Firestore.instance.collection('mystocks');
  final CollectionReference budgets = Firestore.instance.collection('budgets');
  static num userBudget;
  static String _budgetID;
  Currency _currencyDummy = Currency();

  Stream<num> get budget {
    Query query = budgets.where('userid', isEqualTo: Auth().userID);
    return query.snapshots().map(_toBudget);
  }

  Stream<List<Stock>> get stocksList {
    return stocks.snapshots().map(_toStock);
  }

  Stream<List<MyStock>> get myStockList {
    Query query = myStocks.where('userid', isEqualTo: Auth().userID);
    return query.snapshots().map(_toMyStock);
  }

  Stream<num> getMyStock(String myStockShortName) {
    Query query = stocks.where('shortname', isEqualTo: myStockShortName);
    return query.snapshots().map(_toNum);
  }

  Stream<List<MyStockGroup>> getMyStockGroup() {
    Query query = myStocks.where('userid', isEqualTo: Auth().userID);
    return query.snapshots().map(_toGroup);
  }

  Future insertMyStock({Stock stock, num quantity}) async {
    quantity = quantity.round();
    if (Currency.lang != 'ro') {
      if (userBudget - stock.nowPrice.toDouble() * quantity >= 0)
        await budgets.document(_budgetID).updateData(
            {'budget': userBudget - stock.nowPrice.toDouble() * quantity});
      else
        throw Exception();
    } else {
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
    Query query = myStocks
        .where('userid', isEqualTo: Auth().userID)
        .where('buyprice',
            isEqualTo: Currency.lang != 'ro'
                ? stock.nowPrice
                : stock.nowPrice / Currency.currency)
        .where('shortname', isEqualTo: stock.shortName);
    if (Currency.lang == 'ro')
      query = query.where('ronrate', isEqualTo: Currency.currency);
    QuerySnapshot snapshot = await query.getDocuments();
    DocumentSnapshot doc =
        snapshot.documents.firstWhere((doc) => doc.exists, orElse: () => null);
    if (doc != null)
      await myStocks.document(doc.documentID).updateData({
        'quantity': doc != null ? doc.data['quantity'] + quantity : quantity,
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

  Future updateMyStock({MyStock myStock, num quantity}) async {
    try {
      quantity = quantity.round();
      if (myStock.quantity == quantity)
        await myStocks.document(myStock.myStockId).delete();
      else
        await myStocks
            .document(myStock.myStockId)
            .updateData({'quantity': myStock.quantity - quantity});
      await budgets.document(_budgetID).updateData({
        'budget': Currency.lang != 'ro'
            ? userBudget + myStock.buyPrice.toDouble() * quantity
            : userBudget / Currency.currency +
                myStock.buyPrice.toDouble() / Currency.currency * quantity
      });
    } catch (e) {}
  }

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
      MyStockGroup myStockGroup = list.firstWhere(
          (element) => element.name == myStock.shortName,
          orElse: () => null);
      if (myStockGroup != null)
        myStockGroup.quantity += myStock.quantity;
      else
        list.add(
            MyStockGroup(name: myStock.shortName, quantity: myStock.quantity));
    }

    return list;
  }

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

  num _toNum(QuerySnapshot snapshot) {
    var doc = snapshot.documents.firstWhere(
        (element) => element.data['shortname'] != null,
        orElse: () => null);
    if (doc != null) {
      return doc.data['nowprice'];
    } else
      return 0;
  }

  List<MyStock> _toMyStock(QuerySnapshot snapshot) {
    return snapshot.documents
        .map(
          (doc) => MyStock(
              myStockId: doc.documentID,
              shortName: doc.data['shortname'],
              longName: doc.data['longname'],
              buyPrice: doc.data['buyprice'] * doc.data['ronrate'],
              imageUri: doc.data['imageuri'],
              quantity: doc.data['quantity'],
              ronRate: doc.data['ronrate']),
        )
        .toList();
  }

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
