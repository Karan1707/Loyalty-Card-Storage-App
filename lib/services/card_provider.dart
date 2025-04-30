import 'package:flutter/foundation.dart';
import '../models/loyalty_card.dart';
import 'local_storage_service.dart';
import 'cloud_sync_service.dart';
import 'notification_service.dart';

class CardProvider with ChangeNotifier {
  final LocalStorageService _localStorage = LocalStorageService();
  final CloudSyncService _cloudSync = CloudSyncService();
  final NotificationService _notifications = NotificationService();

  List<LoyaltyCard> _cards = [];
  bool _isLoading = false;
  String? _error;

  List<LoyaltyCard> get cards => _cards;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _localStorage.init();
      if (!kIsWeb) {
        await _notifications.init();
        await _syncWithCloud();
      }
      _cards = _localStorage.getAllCards();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCard(LoyaltyCard card) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _localStorage.addCard(card);
      if (!kIsWeb) {
        await _cloudSync.syncCard(card);
        await _notifications.scheduleExpiryNotification(card);
        await _notifications.schedulePointsNotification(card);
      }
      _cards = _localStorage.getAllCards();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCard(LoyaltyCard card) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _localStorage.updateCard(card);
      if (!kIsWeb) {
        await _cloudSync.syncCard(card);
        await _notifications.scheduleExpiryNotification(card);
        await _notifications.schedulePointsNotification(card);
      }
      _cards = _localStorage.getAllCards();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCard(String cardId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _localStorage.deleteCard(cardId);
      if (!kIsWeb) {
        await _cloudSync.deleteCard(cardId);
        await _notifications.cancelNotification(cardId.hashCode);
        await _notifications.cancelNotification(cardId.hashCode + 1);
      }
      _cards = _localStorage.getAllCards();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _syncWithCloud() async {
    try {
      final cloudCards = await _cloudSync.getAllCards();
      final localCards = _localStorage.getAllCards();

      // Update local cards with cloud data
      for (final cloudCard in cloudCards) {
        final localCard = localCards.firstWhere(
          (card) => card.id == cloudCard.id,
          orElse: () => cloudCard,
        );

        if (localCard.lastUpdated.isBefore(cloudCard.lastUpdated)) {
          await _localStorage.updateCard(cloudCard);
        }
      }

      // Sync local changes to cloud
      final unsyncedCards = localCards.where((card) => !card.isSynced).toList();
      if (unsyncedCards.isNotEmpty) {
        await _cloudSync.syncAllCards(unsyncedCards);
        for (final card in unsyncedCards) {
          card.isSynced = true;
          await _localStorage.updateCard(card);
        }
      }

      _cards = _localStorage.getAllCards();
    } catch (e) {
      _error = e.toString();
    }
  }
} 