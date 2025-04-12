import 'package:flutter/material.dart';

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

  void _submitBooking() {
    final booking = {
      'Service': _serviceController.text,
      'Date': _dateController.text,
      'Time': _timeController.text,
      'Address': _addressController.text,
    };

    final confirmationMessage =
        "✅ Your booking for ${booking['Service']} on ${booking['Date']} at ${booking['Time']} has been confirmed.";

    Navigator.pop(context, confirmationMessage);
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _buildTextField("Service", _serviceController),
            const SizedBox(height: 16),
            _buildTextField("Date", _dateController),
            const SizedBox(height: 16),
            _buildTextField("Time", _timeController),
            const SizedBox(height: 16),
            _buildTextField("Address", _addressController),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Confirm Booking",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}