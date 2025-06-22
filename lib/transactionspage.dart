import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatelessWidget {
  final String name;
  final String amount;
  final String type;
  final String timeAgo;
  final DateTime date;

  const TransactionPage({
    super.key,
    required this.name,
    required this.amount,
    required this.type,
    required this.timeAgo,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final isReceived = type == 'received';
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final formattedDate = dateFormat.format(date);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details', 
          style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A2E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: const Color(0xFF1A1A2E),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTransactionCard(isReceived, formattedDate),
            const SizedBox(height: 20),
            _buildBackButton(context),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Home is selected
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/account');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/alerts');
              break;
          }
        },
        backgroundColor: const Color(0xFF1A1A2E),
        selectedItemColor: const Color(0xFF00A3FF),
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Alerts'),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(bool isReceived, String formattedDate) {
    return Card(
      color: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTransactionHeader(isReceived, formattedDate),
            const SizedBox(height: 16),
            _buildAmountDisplay(isReceived),
            const SizedBox(height: 16),
            _buildDetailRow('Transaction Type:', isReceived ? 'Received' : 'Sent'),
            const SizedBox(height: 8),
            _buildDetailRow('Time:', timeAgo),
            const SizedBox(height: 8),
            _buildDetailRow('Date:', formattedDate),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHeader(bool isReceived, String formattedDate) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: isReceived ? Colors.green[100] : Colors.red[100],
          child: Icon(
            isReceived ? Icons.arrow_downward : Icons.arrow_upward,
            color: isReceived ? Colors.green : Colors.red,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isReceived ? 'Received from $name' : 'Sent to $name',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formattedDate,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountDisplay(bool isReceived) {
    return Center(
      child: Text(
        '${isReceived ? '+' : '-'}$amount',
        style: TextStyle(
          color: isReceived ? Colors.green : Colors.red,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00A3FF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Back to Home', 
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}