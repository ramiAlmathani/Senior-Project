import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senior_project/services/firebase_Services.dart';

class BookingScreen extends StatefulWidget {
  final String? service;
  final String? date;
  final String? time;

  const BookingScreen({
    super.key,
    this.service,
    this.date,
    this.time,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late TextEditingController _serviceController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  final TextEditingController _addressController = TextEditingController();

  final FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _serviceController = TextEditingController(text: widget.service ?? '');
    _dateController = TextEditingController(text: widget.date ?? '');
    _timeController = TextEditingController(text: widget.time ?? '');
  }

  @override
  void dispose() {
    _serviceController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitBooking() async {
    final service = _serviceController.text.trim();
    final date = _dateController.text.trim();
    final time = _timeController.text.trim();
    final address = _addressController.text.trim();

    if (service.isEmpty || date.isEmpty || time.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    try {
      await firebaseService.createBookingRequest(
        service: service,
        date: date,
        time: time,
        address: address,
      );

      final confirmationMessage =
          "✅ Your booking for $service on $date at $time has been confirmed.";

      if (context.mounted) {
        Navigator.pop(context, confirmationMessage);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed: $e')),
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF007EA7)),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Book a Service'),
        backgroundColor: const Color(0xFF007EA7),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField("Service", _serviceController),
              const SizedBox(height: 18),
              _buildTextField("Date", _dateController),
              const SizedBox(height: 18),
              _buildTextField("Time", _timeController),
              const SizedBox(height: 18),
              _buildTextField("Address", _addressController),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007EA7),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    "Confirm Booking",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
