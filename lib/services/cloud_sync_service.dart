import 'package:flutter/foundation.dart';
import '../models/loyalty_card.dart';

class CloudSyncService {
  Future<void> syncCard(LoyaltyCard card) async {
    // Stub implementation - no cloud sync in web version
  }

  Future<void> deleteCard(String cardId) async {
    // Stub implementation - no cloud sync in web version
  }

  Future<List<LoyaltyCard>> getAllCards() async {
    // Stub implementation - no cloud sync in web version
    return [];
  }

  Future<void> syncAllCards(List<LoyaltyCard> cards) async {
    // Stub implementation - no cloud sync in web version
  }
} 