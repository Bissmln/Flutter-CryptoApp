import 'package:flutter/material.dart';
import 'package:project_crypto/model/crypto.dart';
import 'package:project_crypto/utils/constants.dart';
import 'package:project_crypto/utils/notification_helper.dart'; 

class DetailScreen extends StatelessWidget {
  final Crypto crypto;

  DetailScreen({required this.crypto});

  void _showNotification() {
    NotificationHelper.showNotification(
      title: crypto.name,
      body:
          "${crypto.symbol.toUpperCase()} - \$${crypto.currentPrice.toStringAsFixed(2)}",
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isPositive = crypto.priceChangePercentage24h >= 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(crypto.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showNotification, 
            tooltip: 'Show Notification',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1E3A8A).withOpacity(0.1),
              const Color(0xFF0F172A),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    // Icon besar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.currency_bitcoin,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Judul
                    Text(
                      crypto.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Sub‐judul
                    Text(
                      "${crypto.symbol.toUpperCase()} • Rank #${crypto.marketCapRank}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Rating (bintang)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Rating: ',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              size: 20,
                              color: index <
                                      (crypto.marketCapRank <= 10
                                          ? 5
                                          : crypto.marketCapRank <= 20
                                              ? 4
                                              : 3)
                                  ? Colors.amber
                                  : Colors.grey,
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${crypto.marketCapRank <= 10 ? 5 : crypto.marketCapRank <= 20 ? 4 : 3}/5",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _priceRow('Current Price:',
                        "\$${crypto.currentPrice.toStringAsFixed(2)}"),
                    const SizedBox(height: 12),
                    _changeRow(isPositive),
                    const SizedBox(height: 12),
                    _priceRow(
                        'Market Cap:',
                        "${(crypto.marketCap / 1000000000).toStringAsFixed(2)}B",
                        isBold: true),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getCryptoDescription(crypto.id),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    // Additional info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Key Features:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureItem("Market Rank: #${crypto.marketCapRank}"),
                          _buildFeatureItem("Symbol: ${crypto.symbol.toUpperCase()}"),
                          _buildFeatureItem(
                              "Current trading at \$${crypto.currentPrice.toStringAsFixed(2)}"),
                          _buildFeatureItem(
                              "${isPositive ? 'Gaining' : 'Losing'} ${crypto.priceChangePercentage24h.abs().toStringAsFixed(2)}% in 24h"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 40, 180, 255),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF3B82F6), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: isBold ? 20 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _changeRow(bool isPositive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '24h Change:',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        Row(
          children: [
            Icon(
              isPositive ? Icons.trending_up : Icons.trending_down,
              color: isPositive ? Colors.green : Colors.red,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              "${crypto.priceChangePercentage24h.toStringAsFixed(2)}%",
              style: TextStyle(
                color: isPositive ? Colors.green : Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getCryptoDescription(String id) {
    const Map<String, String> descriptions = {
      'bitcoin':
          'Bitcoin is the world\'s first and most well‑known cryptocurrency. '
              'Created by the pseudonymous Satoshi Nakamoto in 2009, Bitcoin operates on a decentralized network using blockchain technology. '
              'It serves as a digital store of value and medium of exchange, often referred to as "digital gold." '
              'Bitcoin\'s limited supply of 21 million coins and its decentralized nature make it attractive to investors seeking an alternative to traditional currencies. '
              'The network is secured by miners who validate transactions and maintain the blockchain ledger.',
      'ethereum':
          'Ethereum is a decentralized, open‑source blockchain platform that enables smart contracts and decentralized applications (DApps). '
              'Created by Vitalik Buterin in 2015, Ethereum introduced the concept of programmable money through its native cryptocurrency, Ether (ETH). '
              'The platform serves as the foundation for thousands of DeFi protocols, NFT marketplaces, and other blockchain‑based applications. '
              'Ethereum is currently transitioning from a Proof‑of‑Work to a Proof‑of‑Stake consensus mechanism to improve scalability and reduce energy consumption.',
      'binancecoin':
          'Binance Coin (BNB) is the native cryptocurrency of the Binance ecosystem, one of the world\'s largest cryptocurrency exchanges. '
              'Originally created as an ERC‑20 token on Ethereum, BNB has since migrated to Binance Smart Chain (BSC). '
              'BNB serves multiple purposes including trading fee discounts on Binance, participation in token sales, and as gas fees for BSC transactions. '
              'The coin has evolved from a simple utility token to a cornerstone of the broader Binance ecosystem.',
      'solana':
          'Solana is a high‑performance blockchain platform designed for decentralized applications and cryptocurrencies. '
              'Known for its fast transaction speeds and low costs, Solana can process thousands of transactions per second using its unique Proof‑of‑History consensus mechanism. '
              'The platform has become popular for NFT projects, DeFi protocols, and gaming applications. SOL is the native token used for staking, transaction fees, and governance within the Solana ecosystem.',
      'cardano':
          'Cardano is a blockchain platform built on peer‑reviewed research and evidence‑based methods. '
              'Founded by Ethereum co‑founder Charles Hoskinson, Cardano aims to provide a more sustainable and scalable blockchain solution. '
              'The platform uses a unique Proof‑of‑Stake consensus mechanism called Ouroboros and focuses on academic rigor and formal verification. '
              'ADA, the native token, is used for staking, governance, and transaction fees within the Cardano ecosystem.',
      'ripple':
          'XRP is a digital asset designed for payments and was created by Ripple Labs. '
              'Unlike Bitcoin and Ethereum, XRP was pre‑mined with 100 billion tokens created at inception. '
              'XRP is designed to facilitate fast, low‑cost international money transfers and has partnerships with various financial institutions worldwide. '
              'The XRP Ledger uses a unique consensus algorithm that doesn\'t require mining, making it more energy‑efficient than traditional cryptocurrencies.',
      'polkadot':
          'Polkadot is a multi‑chain blockchain platform that enables different blockchains to transfer messages and value in a trust‑free fashion. '
              'Created by Ethereum co‑founder Gavin Wood, Polkadot aims to enable a completely decentralized web where users are in control. '
              'The platform consists of a main chain called the Relay Chain and multiple parallel chains called parachains. '
              'DOT tokens are used for governance, staking, and bonding new parachains to the network.',
      'dogecoin':
          'Dogecoin started as a meme cryptocurrency based on the popular "Doge" internet meme featuring a Shiba Inu dog. '
              'Created in 2013 by Billy Markus and Jackson Palmer, Dogecoin was initially intended as a fun and friendly cryptocurrency. '
              'Despite its humorous origins, Dogecoin has gained significant popularity and adoption, partly due to endorsements from celebrities like Elon Musk. '
              'The cryptocurrency has an unlimited supply and is often used for tipping and charitable donations.',
      'avalanche-2':
          'Avalanche is a layer‑1 blockchain platform that aims to provide high throughput, fast finality, and low fees. '
              'The platform uses a novel consensus protocol that can process thousands of transactions per second while maintaining decentralization and security. '
              'Avalanche supports smart contracts and is compatible with Ethereum, allowing developers to easily port their DApps. '
              'AVAX is the native token used for staking, governance, and transaction fees.',
      'chainlink':
          'Chainlink is a decentralized oracle network that enables smart contracts to securely access off‑chain data feeds, web APIs, and traditional bank payments. '
              'The platform bridges the gap between blockchain and real‑world data, making smart contracts more useful and practical. '
              'Chainlink\'s decentralized network of oracles ensures data reliability and prevents single points of failure. '
              'LINK tokens are used to pay node operators for providing data and services to smart contracts.',
    };

    return descriptions[id] ??
        'This cryptocurrency is an innovative digital asset that operates on blockchain technology. '
            'It represents a new paradigm in digital finance, offering unique features and use cases within the cryptocurrency ecosystem. '
            'The token has gained recognition in the crypto community for its technological approach and market performance. '
            'As with all cryptocurrencies, it operates in a decentralized manner, providing users with financial sovereignty and innovative blockchain‑based solutions. '
            'The project continues to evolve and adapt to the changing landscape of digital assets and blockchain technology.';
  }
}
