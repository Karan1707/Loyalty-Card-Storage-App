import 'package:hive/hive.dart';

part 'loyalty_card.g.dart';

@HiveType(typeId: 0)
class LoyaltyCard extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String cardName;

  @HiveField(2)
  String cardNumber;

  @HiveField(3)
  String? barcodeData;

  @HiveField(4)
  String? barcodeFormat;

  @HiveField(5)
  DateTime? expiryDate;

  @HiveField(6)
  String? storeName;

  @HiveField(7)
  String? cardImagePath;

  @HiveField(8)
  int points;

  @HiveField(9)
  DateTime lastUpdated;

  @HiveField(10)
  bool isSynced;

  LoyaltyCard({
    required this.id,
    required this.cardName,
    required this.cardNumber,
    this.barcodeData,
    this.barcodeFormat,
    this.expiryDate,
    this.storeName,
    this.cardImagePath,
    this.points = 0,
    required this.lastUpdated,
    this.isSynced = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardName': cardName,
      'cardNumber': cardNumber,
      'barcodeData': barcodeData,
      'barcodeFormat': barcodeFormat,
      'expiryDate': expiryDate?.toIso8601String(),
      'storeName': storeName,
      'cardImagePath': cardImagePath,
      'points': points,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  factory LoyaltyCard.fromJson(Map<String, dynamic> json) {
    return LoyaltyCard(
      id: json['id'],
      cardName: json['cardName'],
      cardNumber: json['cardNumber'],
      barcodeData: json['barcodeData'],
      barcodeFormat: json['barcodeFormat'],
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      storeName: json['storeName'],
      cardImagePath: json['cardImagePath'],
      points: json['points'] ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated']),
      isSynced: json['isSynced'] ?? false,
    );
  }
} 