import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/loyalty_card.dart';

class CardDetailsScreen extends StatelessWidget {
  final LoyaltyCard card;

  const CardDetailsScreen({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(card.cardName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (card.cardImagePath != null)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(card.cardImagePath!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Card Number', card.cardNumber),
                    if (card.storeName != null)
                      _buildInfoRow('Store', card.storeName!),
                    if (card.points > 0)
                      _buildInfoRow('Points', card.points.toString()),
                    if (card.expiryDate != null)
                      _buildInfoRow(
                        'Expiry Date',
                        '${card.expiryDate!.day}/${card.expiryDate!.month}/${card.expiryDate!.year}',
                        isExpired: card.expiryDate!.isBefore(DateTime.now()),
                      ),
                  ],
                ),
              ),
            ),
            if (card.barcodeData != null) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Barcode (${card.barcodeFormat})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      QrImageView(
                        data: card.barcodeData!,
                        version: QrVersions.auto,
                        size: 200,
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isExpired = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: isExpired ? Colors.red : null,
            ),
          ),
        ],
      ),
    );
  }
} 