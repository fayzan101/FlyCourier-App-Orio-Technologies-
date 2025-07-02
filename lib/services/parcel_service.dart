import 'package:dio/dio.dart';
import '../models/parcel_model.dart';

class ParcelService {
  static Future<ParcelModel?> getParcelByTrackingNumber(String trackingNumber) async {
    final dio = Dio();
    const url = 'https://thegoexpress.com/api/loadsheet_by_cn';
    final headers = {
      'Authorization': 'zainKhan:demo@1234',
      'Content-Type': 'application/json',
    };
    try {
      final trimmedTrackingNumber = trackingNumber.toString().trim();
      print('Tracking number sent to API: "' + trimmedTrackingNumber + '"');
      final response = await dio.post(
        url,
        data: {'shipment_no': trimmedTrackingNumber},
        options: Options(headers: headers),
      );
      print('API response: \\n${response.data}');
      if (response.statusCode == 200 && response.data['status'] == 1) {
        final body = response.data['data']['body'];
        if (body is List && body.isNotEmpty) {
          final item = body[0];
          return ParcelModel(
            shipmentNo: item['shipment_no']?.toString() ?? '',
            shipmentDate: item['shipment_date']?.toString() ?? '',
            tpcnno: item['tpcnno']?.toString() ?? '',
            tpname: item['tpname']?.toString() ?? '',
            shipmentReference: item['shipment_reference']?.toString() ?? '',
            consigneeName: item['consignee_name']?.toString() ?? '',
            consigneeContact: item['consignee_contact']?.toString() ?? '',
            productDetail: item['product_detail']?.toString() ?? '',
            consigneeAddress: item['consignee_address']?.toString() ?? '',
            destinationCity: item['destination_city']?.toString() ?? '',
            peices: item['peices']?.toString() ?? '',
            weight: item['weight']?.toString() ?? '',
            cashCollect: item['cash_collect']?.toString() ?? '',
            createdBy: item['created_by']?.toString() ?? '',
          );
        }
      }
      return null;
    } catch (e) {
      print('API error: $e');
      return null;
    }
  }

  static Future<Response?> createLoadsheet(String shipmentNo) async {
    final dio = Dio();
    const url = 'https://thegoexpress.com/api/create_loadsheet';
    final headers = {
      'Authorization': 'zainKhan:demo@1234',
      'Content-Type': 'application/json',
    };
    try {
      final response = await dio.post(
        url,
        data: {'shipment_no': shipmentNo},
        options: Options(headers: headers),
      );
      return response;
    } catch (e) {
      print('API error: $e');
      return null;
    }
  }
}