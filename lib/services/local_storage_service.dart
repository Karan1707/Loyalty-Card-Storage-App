import 'package:hive_flutter/hive_flutter.dart';
import '../models/loyalty_card.dart';

class LocalStorageService {
  static const String _boxName = 'loyaltyCards';
  late Box<LoyaltyCard> _loyaltyCardsBox;

  Future<void> init() async {
    _loyaltyCardsBox = await Hive.openBox<LoyaltyCard>(_boxName);
  }

  Future<void> addCard(LoyaltyCard card) async {
    await _loyaltyCardsBox.put(card.id, card);
  }

  Future<void> updateCard(LoyaltyCard card) async {
    await _loyaltyCardsBox.put(card.id, card);
  }

  Future<void> deleteCard(String cardId) async {
    await _loyaltyCardsBox.delete(cardId);
  }

  List<LoyaltyCard> getAllCards() {
    return _loyaltyCardsBox.values.toList();
  }

  LoyaltyCard? getCard(String cardId) {
    return _loyaltyCardsBox.get(cardId);
  }

  Future<void> clearAllCards() async {
    await _loyaltyCardsBox.clear();
  }

  Future<void> close() async {
    await _loyaltyCardsBox.close();
  }
} 