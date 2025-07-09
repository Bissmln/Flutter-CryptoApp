import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_crypto/model/crypto.dart';
import 'package:project_crypto/utils/constants.dart';

class CryptoService {
  static const String baseUrl = 'https://api.coingecko.com/api/v3';
  static Future<List<Crypto>> fetchCryptos() async {
    try {
      final response = await http.get(
        Uri.parse(
            '$API_BASE_URL/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=false'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Crypto.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cryptocurrencies');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}