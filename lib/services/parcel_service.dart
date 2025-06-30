import 'dart:async';
import '../models/parcel_model.dart';

class ParcelService {
  // Simulate API delay
  static const Duration _apiDelay = Duration(milliseconds: 800);

  // Mock parcel data
  static final List<Map<String, dynamic>> _mockParcels = [
    {
      'id': 'PK001',
      'trackingNumber': 'TRK123456789',
      'recipientName': 'John Doe',
      'recipientPhone': '+92 300 1234567',
      'recipientAddress': 'House #123, Street 5, Gulberg III, Lahore',
      'senderName': 'Amazon Pakistan',
      'senderPhone': '+92 21 1234567',
      'senderAddress': 'Amazon Warehouse, Karachi',
      'weight': '2.5 kg',
      'dimensions': '30x20x15 cm',
      'status': 'In Transit',
      'currentLocation': 'Lahore Hub',
      'estimatedDelivery': '2024-01-15',
      'pickupDate': '2024-01-10',
      'deliveryDate': null,
      'notes': 'Fragile item - Handle with care',
      'packageType': 'Electronics',
      'insuranceValue': 'Rs. 25,000',
      'shippingCost': 'Rs. 500',
    },
    {
      'id': 'PK002',
      'trackingNumber': 'TRK987654321',
      'recipientName': 'Sarah Ahmed',
      'recipientPhone': '+92 301 9876543',
      'recipientAddress': 'Apartment 45, Block 7, Clifton, Karachi',
      'senderName': 'Daraz',
      'senderPhone': '+92 21 9876543',
      'senderAddress': 'Daraz Warehouse, Lahore',
      'weight': '1.2 kg',
      'dimensions': '25x15x10 cm',
      'status': 'Out for Delivery',
      'currentLocation': 'Karachi Local',
      'estimatedDelivery': '2024-01-12',
      'pickupDate': '2024-01-08',
      'deliveryDate': null,
      'notes': 'Signature required',
      'packageType': 'Clothing',
      'insuranceValue': 'Rs. 8,000',
      'shippingCost': 'Rs. 300',
    },
    {
      'id': 'PK003',
      'trackingNumber': 'TRK456789123',
      'recipientName': 'Ali Hassan',
      'recipientPhone': '+92 302 4567891',
      'recipientAddress': 'Shop #12, Mall Road, Rawalpindi',
      'senderName': 'Shopify Store',
      'senderPhone': '+92 51 4567891',
      'senderAddress': 'Shopify Warehouse, Islamabad',
      'weight': '3.8 kg',
      'dimensions': '40x30x25 cm',
      'status': 'Delivered',
      'currentLocation': 'Rawalpindi',
      'estimatedDelivery': '2024-01-10',
      'pickupDate': '2024-01-05',
      'deliveryDate': '2024-01-10',
      'notes': 'Left with neighbor',
      'packageType': 'Home & Garden',
      'insuranceValue': 'Rs. 15,000',
      'shippingCost': 'Rs. 450',
    },
    {
      'id': 'PK004',
      'trackingNumber': 'TRK789123456',
      'recipientName': 'Fatima Khan',
      'recipientPhone': '+92 303 7891234',
      'recipientAddress': 'Villa 8, Defence Housing Authority, Islamabad',
      'senderName': 'WooCommerce Store',
      'senderPhone': '+92 51 7891234',
      'senderAddress': 'WooCommerce Warehouse, Lahore',
      'weight': '0.8 kg',
      'dimensions': '20x15x8 cm',
      'status': 'Pending Pickup',
      'currentLocation': 'Lahore Hub',
      'estimatedDelivery': '2024-01-18',
      'pickupDate': null,
      'deliveryDate': null,
      'notes': 'Awaiting pickup confirmation',
      'packageType': 'Jewelry',
      'insuranceValue': 'Rs. 50,000',
      'shippingCost': 'Rs. 800',
    },
    {
      'id': 'PK005',
      'trackingNumber': 'TRK321654987',
      'recipientName': 'Ahmed Raza',
      'recipientPhone': '+92 304 3216549',
      'recipientAddress': 'Office 15, Business District, Faisalabad',
      'senderName': 'Etsy Seller',
      'senderPhone': '+92 41 3216549',
      'senderAddress': 'Etsy Warehouse, Karachi',
      'weight': '1.5 kg',
      'dimensions': '28x18x12 cm',
      'status': 'In Transit',
      'currentLocation': 'Faisalabad Hub',
      'estimatedDelivery': '2024-01-16',
      'pickupDate': '2024-01-11',
      'deliveryDate': null,
      'notes': 'Business hours delivery preferred',
      'packageType': 'Books',
      'insuranceValue': 'Rs. 12,000',
      'shippingCost': 'Rs. 350',
    },
  ];

  // Get parcel details by tracking number (simulates API call)
  static Future<ParcelModel?> getParcelByTrackingNumber(String trackingNumber) async {
    await Future.delayed(_apiDelay); // Simulate network delay
    
    try {
      final parcelData = _mockParcels.firstWhere(
        (parcel) => parcel['trackingNumber'] == trackingNumber,
        orElse: () => throw Exception('Parcel not found'),
      );
      
      return ParcelModel.fromJson(parcelData);
    } catch (e) {
      return null; // Return null if parcel not found
    }
  }

  // Get parcel details by ID (simulates API call)
  static Future<ParcelModel?> getParcelById(String id) async {
    await Future.delayed(_apiDelay); // Simulate network delay
    
    try {
      final parcelData = _mockParcels.firstWhere(
        (parcel) => parcel['id'] == id,
        orElse: () => throw Exception('Parcel not found'),
      );
      
      return ParcelModel.fromJson(parcelData);
    } catch (e) {
      return null; // Return null if parcel not found
    }
  }

  // Search parcels by various criteria (simulates API call)
  static Future<List<ParcelModel>> searchParcels({
    String? recipientName,
    String? status,
    String? location,
  }) async {
    await Future.delayed(_apiDelay); // Simulate network delay
    
    List<Map<String, dynamic>> filteredParcels = _mockParcels;
    
    if (recipientName != null && recipientName.isNotEmpty) {
      filteredParcels = filteredParcels.where((parcel) =>
        parcel['recipientName'].toString().toLowerCase().contains(recipientName.toLowerCase())
      ).toList();
    }
    
    if (status != null && status.isNotEmpty) {
      filteredParcels = filteredParcels.where((parcel) =>
        parcel['status'].toString().toLowerCase() == status.toLowerCase()
      ).toList();
    }
    
    if (location != null && location.isNotEmpty) {
      filteredParcels = filteredParcels.where((parcel) =>
        parcel['currentLocation'].toString().toLowerCase().contains(location.toLowerCase())
      ).toList();
    }
    
    return filteredParcels.map((parcel) => ParcelModel.fromJson(parcel)).toList();
  }

  // Get all parcels (simulates API call)
  static Future<List<ParcelModel>> getAllParcels() async {
    await Future.delayed(_apiDelay); // Simulate network delay
    
    return _mockParcels.map((parcel) => ParcelModel.fromJson(parcel)).toList();
  }

  // Update parcel status (simulates API call)
  static Future<bool> updateParcelStatus(String trackingNumber, String newStatus) async {
    await Future.delayed(_apiDelay); // Simulate network delay
    
    try {
      final parcelIndex = _mockParcels.indexWhere(
        (parcel) => parcel['trackingNumber'] == trackingNumber,
      );
      
      if (parcelIndex != -1) {
        _mockParcels[parcelIndex]['status'] = newStatus;
        
        // Update delivery date if status is "Delivered"
        if (newStatus == 'Delivered') {
          _mockParcels[parcelIndex]['deliveryDate'] = DateTime.now().toIso8601String().split('T')[0];
        }
        
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Add new parcel (simulates API call)
  static Future<bool> addParcel(ParcelModel parcel) async {
    await Future.delayed(_apiDelay); // Simulate network delay
    
    try {
      _mockParcels.add(parcel.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get parcel tracking history (simulates API call)
  static Future<List<TrackingEvent>> getTrackingHistory(String trackingNumber) async {
    await Future.delayed(_apiDelay); // Simulate network delay
    
    // Mock tracking events
    final trackingEvents = [
      TrackingEvent(
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        location: 'Lahore Hub',
        status: 'In Transit',
        description: 'Package departed from sorting facility',
      ),
      TrackingEvent(
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        location: 'Karachi Hub',
        status: 'Processed',
        description: 'Package processed and ready for shipment',
      ),
      TrackingEvent(
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        location: 'Karachi Hub',
        status: 'Received',
        description: 'Package received at origin facility',
      ),
    ];
    
    return trackingEvents;
  }
}

// Tracking event model
class TrackingEvent {
  final DateTime timestamp;
  final String location;
  final String status;
  final String description;

  TrackingEvent({
    required this.timestamp,
    required this.location,
    required this.status,
    required this.description,
  });
} 