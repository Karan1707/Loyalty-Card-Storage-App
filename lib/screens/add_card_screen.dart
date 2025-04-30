import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:io';
import '../models/loyalty_card.dart';
import '../services/card_provider.dart';

class AddCardScreen extends StatefulWidget {
  final LoyaltyCard? card;

  const AddCardScreen({super.key, this.card});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _pointsController = TextEditingController();
  DateTime? _expiryDate;
  String? _barcodeData;
  String? _barcodeFormat;
  String? _cardImagePath;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    if (widget.card != null) {
      _cardNameController.text = widget.card!.cardName;
      _cardNumberController.text = widget.card!.cardNumber;
      _storeNameController.text = widget.card!.storeName ?? '';
      _pointsController.text = widget.card!.points.toString();
      _expiryDate = widget.card!.expiryDate;
      _barcodeData = widget.card!.barcodeData;
      _barcodeFormat = widget.card!.barcodeFormat;
      _cardImagePath = widget.card!.cardImagePath;
    }
  }

  @override
  void dispose() {
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _storeNameController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card == null ? 'Add Card' : 'Edit Card'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardNameController,
                decoration: const InputDecoration(
                  labelText: 'Card Name',
                  prefixIcon: Icon(Icons.credit_card),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a card name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _storeNameController,
                decoration: const InputDecoration(
                  labelText: 'Store Name',
                  prefixIcon: Icon(Icons.store),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a card number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pointsController,
                decoration: const InputDecoration(
                  labelText: 'Points',
                  prefixIcon: Icon(Icons.star),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  _expiryDate == null
                      ? 'Select Expiry Date'
                      : 'Expiry Date: ${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _expiryDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                    );
                    if (date != null) {
                      setState(() {
                        _expiryDate = date;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _startScanning,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan Barcode'),
              ),
              if (_barcodeData != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Barcode Format: $_barcodeFormat',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'Barcode Data: $_barcodeData',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveCard,
                child: const Text('Save Card'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: _cardImagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_cardImagePath!),
                  fit: BoxFit.cover,
                ),
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate, size: 48),
                    SizedBox(height: 8),
                    Text('Add Card Image'),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _cardImagePath = pickedFile.path;
      });
    }
  }

  void _startScanning() {
    setState(() {
      _isScanning = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            AppBar(
              title: const Text('Scan Barcode'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isScanning = false;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Expanded(
              child: MobileScanner(
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    setState(() {
                      _barcodeData = barcodes.first.rawValue;
                      _barcodeFormat = barcodes.first.format.name;
                      _isScanning = false;
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCard() {
    if (_formKey.currentState!.validate()) {
      final card = LoyaltyCard(
        id: widget.card?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        cardName: _cardNameController.text,
        cardNumber: _cardNumberController.text,
        storeName: _storeNameController.text.isEmpty ? null : _storeNameController.text,
        points: int.tryParse(_pointsController.text) ?? 0,
        expiryDate: _expiryDate,
        barcodeData: _barcodeData,
        barcodeFormat: _barcodeFormat,
        cardImagePath: _cardImagePath,
        lastUpdated: DateTime.now(),
        isSynced: false,
      );

      if (widget.card == null) {
        context.read<CardProvider>().addCard(card);
      } else {
        context.read<CardProvider>().updateCard(card);
      }

      Navigator.pop(context);
    }
  }
} 