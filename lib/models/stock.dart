class Stock {
  String shortName;
  String longName;
  num nowPrice;
  num oldPrice;
  String companyDescription;
  String imageUri;
  String statistic;

  Stock(
      {this.shortName,
      this.longName,
      this.nowPrice,
      this.oldPrice,
      this.imageUri,
      this.statistic,
      this.companyDescription});
}
