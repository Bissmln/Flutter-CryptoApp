import 'package:flutter/material.dart';
import 'package:project_crypto/model/crypto.dart';
import 'package:project_crypto/service/crypto_service.dart'; 
import 'package:project_crypto/screens/detail_screen.dart'; 
import 'package:project_crypto/screens/change_password_screen.dart';
import 'package:project_crypto/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Crypto> cryptos = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    _loadCryptos();
  }

  // Logika ini sudah bagus, tidak perlu diubah
  Future<void> _loadCryptos() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      List<Crypto> fetchedCryptos = await CryptoService.fetchCryptos();
      setState(() {
        cryptos = fetchedCryptos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString().replaceFirst('Exception: ', ''); 
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor, 
      appBar: AppBar(
        title: const Text('CryptoTracker', style: kBodyLarge),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCryptos, 
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kPrimaryColor.withOpacity(0.1),
              kScaffoldBackgroundColor,
            ],
          ),
        ),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error.isNotEmpty) {
      return Center(
        child: Text(
          'Gagal memuat data:\n$error',
          textAlign: TextAlign.center,
          style: kBodyMedium,
        ),
      );
    }
    return ListView.builder(
      itemCount: cryptos.length,
      itemBuilder: (context, index) {
        final crypto = cryptos[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(crypto: crypto),
              ),
            );
          },
          child: Card(
            color: kCardBackgroundColor,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: Image.network(crypto.image, width: 40),
              title: Text(crypto.name, style: kBodyLarge),
              subtitle: Text(crypto.symbol.toUpperCase(), style: kBodyMedium),
              trailing: Text(
                '\$${crypto.currentPrice.toStringAsFixed(2)}',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }
}