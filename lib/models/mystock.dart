class MyStock {
  String myStockId;
  String shortName;
  String longName;
  num buyPrice;
  String imageUri;
  num quantity;
  num ronRate;

  MyStock(
      {this.myStockId,
      this.shortName,
      this.longName,
      this.buyPrice,
      this.imageUri,
      this.quantity,
      this.ronRate});
}
