import 'package:dio/dio.dart';

class CurrencyService {
  final Dio _dio;
  static const String _baseUrl = 'https://api.frankfurter.dev/v1';
  static const double _usdToPkr = 278.50;

  CurrencyService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: _baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  String _normalize(String code) {
    final upper = code.trim().toUpperCase();
    if (upper == 'GDP') return 'GBP';
    return upper;
  }

  Future<double> convertCurrency({
    required double amount,
    required String from,
    required String to,
  }) async {
    final fromCode = _normalize(from);
    final toCode = _normalize(to);

    if (fromCode == toCode) {
      return amount;
    }

    try {
      if ((fromCode == 'USD' || fromCode == 'GBP') &&
          (toCode == 'USD' || toCode == 'GBP')) {
        final response = await _dio.get(
          '/latest',
          queryParameters: {
            'amount': amount,
            'from': fromCode,
            'to': toCode,
          },
        );

        if (response.statusCode == 200 && response.data != null) {
          final rates = response.data['rates'] as Map<String, dynamic>?;
          if (rates != null && rates.containsKey(toCode)) {
            return (rates[toCode] as num).toDouble();
          }
        }
      }

      if (fromCode == 'USD' && toCode == 'PKR') {
        return amount * _usdToPkr;
      }

      if (fromCode == 'PKR' && toCode == 'USD') {
        return amount / _usdToPkr;
      }

      if (fromCode == 'GBP' && toCode == 'PKR') {
        final response = await _dio.get(
          '/latest',
          queryParameters: {'amount': 1, 'from': 'GBP', 'to': 'USD'},
        );
        final gbpToUsd = (response.data['rates']['USD'] as num).toDouble();
        return (amount * gbpToUsd) * _usdToPkr;
      }

      if (fromCode == 'PKR' && toCode == 'GBP') {
        final response = await _dio.get(
          '/latest',
          queryParameters: {'amount': 1, 'from': 'USD', 'to': 'GBP'},
        );
        final usdToGbp = (response.data['rates']['GBP'] as num).toDouble();
        return (amount / _usdToPkr) * usdToGbp;
      }

      throw Exception('Unsupported currency pair: $from -> $to');
    } catch (e) {
      throw Exception('Could not fetch rates from Frankfurter API: $e');
    }
  }
}
