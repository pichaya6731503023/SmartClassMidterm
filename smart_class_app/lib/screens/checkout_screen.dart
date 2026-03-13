import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/location_service.dart';
import 'qr_scanner_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _learnedTopicController = TextEditingController();
  final _feedbackController = TextEditingController();
  
  String? _scannedQR;
  Position? _currentPosition;
  bool _isLoading = false;

  Future<void> _scanQR() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
    );
    if (result != null) {
      setState(() => _scannedQR = result.toString());
      _getLocation();
    }
  }

  Future<void> _getLocation() async {
    try {
      Position? pos = await LocationService.getCurrentLocation();
      setState(() => _currentPosition = pos);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _submitForm() async {
    if (_scannedQR == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please scan Class QR Code first')));
      return;
    }
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pending Location Verification')));
      return;
    }
    
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        await FirebaseFirestore.instance.collection('class_sessions').add({
          'session_id': _scannedQR,
          'student_id': 'STD_1305216', // Simulated Student ID
          'check_out_time': FieldValue.serverTimestamp(),
          'check_out_location': GeoPoint(_currentPosition!.latitude, _currentPosition!.longitude),
          'learned_topic': _learnedTopicController.text,
          'feedback': _feedbackController.text,
          'type': 'check_out', // Log Type
        });

        if (mounted) {
          setState(() => _isLoading = false);
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Success'),
              content: const Text('Check-out and Feedback saved to Firebase!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                )
              ],
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Firebase Error: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finish Class (Check-out)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.qr_code_scanner),
                        label: Text(_scannedQR == null ? 'Scan Class QR Code' : 'QR Scanned successfully'),
                        style: ElevatedButton.styleFrom(
                           backgroundColor: _scannedQR == null ? const Color(0xFF10B981) : Colors.green,
                           minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: _scanQR,
                      ),
                      const SizedBox(height: 12),
                      if (_scannedQR != null) Text('Class ID: $_scannedQR', style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (_currentPosition != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Location Verified (Lat: ${_currentPosition!.latitude.toStringAsFixed(3)}, Lng: ${_currentPosition!.longitude.toStringAsFixed(3)})',
                            style: TextStyle(color: Colors.green.shade700, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Post-class Reflection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _learnedTopicController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'What did you learn today?', alignLabelWithHint: true),
                validator: (val) => val!.isEmpty ? 'Please enter what you learned' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _feedbackController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Feedback about class or instructor', alignLabelWithHint: true),
                validator: (val) => val!.isEmpty ? 'Please enter your feedback' : null,
              ),
              const SizedBox(height: 32),
              
              _isLoading 
                 ? const Center(child: CircularProgressIndicator()) 
                 : ElevatedButton(
                     style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                     onPressed: _submitForm,
                     child: const Text('Submit Check-out'),
                   ),
            ],
          ),
        ),
      ),
    );
  }
}
