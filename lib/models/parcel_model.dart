class ParcelModel {
  final String id;
  final String trackingNumber;
  final String recipientName;
  final String recipientPhone;
  final String recipientAddress;
  final String senderName;
  final String senderPhone;
  final String senderAddress;
  final String weight;
  final String dimensions;
  final String status;
  final String currentLocation;
  final String estimatedDelivery;
  final String? pickupDate;
  final String? deliveryDate;
  final String notes;
  final String packageType;
  final String insuranceValue;
  final String shippingCost;

  ParcelModel({
    required this.id,
    required this.trackingNumber,
    required this.recipientName,
    required this.recipientPhone,
    required this.recipientAddress,
    required this.senderName,
    required this.senderPhone,
    required this.senderAddress,
    required this.weight,
    required this.dimensions,
    required this.status,
    required this.currentLocation,
    required this.estimatedDelivery,
    this.pickupDate,
    this.deliveryDate,
    required this.notes,
    required this.packageType,
    required this.insuranceValue,
    required this.shippingCost,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trackingNumber': trackingNumber,
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
      'recipientAddress': recipientAddress,
      'senderName': senderName,
      'senderPhone': senderPhone,
      'senderAddress': senderAddress,
      'weight': weight,
      'dimensions': dimensions,
      'status': status,
      'currentLocation': currentLocation,
      'estimatedDelivery': estimatedDelivery,
      'pickupDate': pickupDate,
      'deliveryDate': deliveryDate,
      'notes': notes,
      'packageType': packageType,
      'insuranceValue': insuranceValue,
      'shippingCost': shippingCost,
    };
  }

  factory ParcelModel.fromJson(Map<String, dynamic> json) {
    return ParcelModel(
      id: json['id'] ?? '',
      trackingNumber: json['trackingNumber'] ?? '',
      recipientName: json['recipientName'] ?? '',
      recipientPhone: json['recipientPhone'] ?? '',
      recipientAddress: json['recipientAddress'] ?? '',
      senderName: json['senderName'] ?? '',
      senderPhone: json['senderPhone'] ?? '',
      senderAddress: json['senderAddress'] ?? '',
      weight: json['weight'] ?? '',
      dimensions: json['dimensions'] ?? '',
      status: json['status'] ?? '',
      currentLocation: json['currentLocation'] ?? '',
      estimatedDelivery: json['estimatedDelivery'] ?? '',
      pickupDate: json['pickupDate'],
      deliveryDate: json['deliveryDate'],
      notes: json['notes'] ?? '',
      packageType: json['packageType'] ?? '',
      insuranceValue: json['insuranceValue'] ?? '',
      shippingCost: json['shippingCost'] ?? '',
    );
  }

  // Create a copy of the parcel with updated fields
  ParcelModel copyWith({
    String? id,
    String? trackingNumber,
    String? recipientName,
    String? recipientPhone,
    String? recipientAddress,
    String? senderName,
    String? senderPhone,
    String? senderAddress,
    String? weight,
    String? dimensions,
    String? status,
    String? currentLocation,
    String? estimatedDelivery,
    String? pickupDate,
    String? deliveryDate,
    String? notes,
    String? packageType,
    String? insuranceValue,
    String? shippingCost,
  }) {
    return ParcelModel(
      id: id ?? this.id,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      recipientName: recipientName ?? this.recipientName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      recipientAddress: recipientAddress ?? this.recipientAddress,
      senderName: senderName ?? this.senderName,
      senderPhone: senderPhone ?? this.senderPhone,
      senderAddress: senderAddress ?? this.senderAddress,
      weight: weight ?? this.weight,
      dimensions: dimensions ?? this.dimensions,
      status: status ?? this.status,
      currentLocation: currentLocation ?? this.currentLocation,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      pickupDate: pickupDate ?? this.pickupDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      notes: notes ?? this.notes,
      packageType: packageType ?? this.packageType,
      insuranceValue: insuranceValue ?? this.insuranceValue,
      shippingCost: shippingCost ?? this.shippingCost,
    );
  }

  // Get status color for UI
  String get statusColor {
    switch (status.toLowerCase()) {
      case 'delivered':
        return '#4CAF50'; // Green
      case 'out for delivery':
        return '#FF9800'; // Orange
      case 'in transit':
        return '#2196F3'; // Blue
      case 'pending pickup':
        return '#9C27B0'; // Purple
      case 'processed':
        return '#607D8B'; // Blue Grey
      case 'received':
        return '#795548'; // Brown
      default:
        return '#757575'; // Grey
    }
  }

  // Get status icon for UI
  String get statusIcon {
    switch (status.toLowerCase()) {
      case 'delivered':
        return 'check_circle';
      case 'out for delivery':
        return 'local_shipping';
      case 'in transit':
        return 'flight';
      case 'pending pickup':
        return 'schedule';
      case 'processed':
        return 'inventory';
      case 'received':
        return 'inbox';
      default:
        return 'info';
    }
  }

  @override
  String toString() {
    return 'ParcelModel(id: $id, trackingNumber: $trackingNumber, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ParcelModel && other.trackingNumber == trackingNumber;
  }

  @override
  int get hashCode => trackingNumber.hashCode;
} 