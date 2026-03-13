import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/location_service.dart';
import 'qr_scanner_screen.dart';

class CheckinScreen extends StatefulWidget {
  const CheckinScreen({super.key});

  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prevTopicController = TextEditingController();
  final _expectedTopicController = TextEditingController();
  
  String? _scannedQR;
  Position? _currentPosition;
  int _moodScore = 3;
  bool _isLoading = false;

  final Map<int, String> moodEmojis = {
    1: '😡', // Very negative
    2: '🙁', // Negative
    3: '😐', // Neutral
    4: '🙂', // Positive
    5: '😄', // Very positive
  };

  Future<void> _scanQR() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
    );
    if (result != null) {
      setState(() => _scannedQR = result.toString());
      _getLocation(); // Fetch location automatically after successful scan
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
          'student_id': 'STD_1305216', // Simulated Student ID for Midterm
          'check_in_time': FieldValue.serverTimestamp(),
          'check_in_location': GeoPoint(_currentPosition!.latitude, _currentPosition!.longitude),
          'previous_topic': _prevTopicController.text,
          'expected_topic': _expectedTopicController.text,
          'mood_score': _moodScore,
          'type': 'check_in', // Log Type
        });

        if (mounted) {
          setState(() => _isLoading = false);
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Success'),
              content: const Text('Check-in and Reflection saved successfully to Firebase!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx); // Close dialog
                    Navigator.pop(context); // Go back to Home
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
      appBar: AppBar(title: const Text('Check-in Before Class')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Scanning Steps
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
                           backgroundColor: _scannedQR == null ? const Color(0xFF4F46E5) : Colors.green,
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
              const Text('Learning Reflection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _prevTopicController,
                decoration: const InputDecoration(labelText: 'Topic covered in the previous class', prefixIcon: Icon(Icons.history)),
                validator: (val) => val!.isEmpty ? 'Please enter previous topic' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _expectedTopicController,
                decoration: const InputDecoration(labelText: 'What do you expect to learn today?', prefixIcon: Icon(Icons.lightbulb_outline)),
                validator: (val) => val!.isEmpty ? 'Please enter expectations' : null,
              ),
              const SizedBox(height: 24),
              
              const Text('Mood before class', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: moodEmojis.entries.map((e) {
                  final isSelected = _moodScore == e.key;
                  return GestureDetector(
                    onTap: () => setState(() => _moodScore = e.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF4F46E5).withOpacity(0.1) : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: isSelected ? const Color(0xFF4F46E5) : Colors.transparent, width: 2),
                      ),
                      child: Text(e.value, style: const TextStyle(fontSize: 32)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              
              _isLoading 
                 ? const Center(child: CircularProgressIndicator()) 
                 : ElevatedButton(
                     onPressed: _submitForm,
                     child: const Text('Submit Check-in'),
                   ),
            ],
          ),
        ),
      ),
    );
  }
}
