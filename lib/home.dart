import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF00A3FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to logout?', 
          style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
            },
            child: const Text('Logout', style: TextStyle(color: Color(0xFF00A3FF))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A2E),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Color(0xFF00A3FF),
            child: Icon(Icons.person, color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () => _showSnackBar(context, 'No new notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: _buildBody(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0:
              if (ModalRoute.of(context)?.settings.name != '/home') {
                Navigator.pushReplacementNamed(context, '/home');
              }
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

  Widget _buildBody(BuildContext context) {
    final transactions = [
      _TransactionData('Alex Mwangi', 'KSh 500.00', 'received', '2h ago', DateTime.now().subtract(const Duration(hours: 2))),
      _TransactionData('Jane Adhiambo', 'KSh 200.00', 'sent', '5h ago', DateTime.now().subtract(const Duration(hours: 5))),
      _TransactionData('Mike Johnson', 'KSh 1,000.00', 'received', '1d ago', DateTime.now().subtract(const Duration(days: 1))),
      _TransactionData('Sam Musyoki', 'KSh 300.00', 'sent', '2d ago', DateTime.now().subtract(const Duration(days: 2))),
      _TransactionData('Emma Njambi', 'KSh 750.00', 'received', '3d ago', DateTime.now().subtract(const Duration(days: 3))),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 24),
          _buildQuickActions(context),
          const SizedBox(height: 32),
          _buildTransactionsSection(context, transactions),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00A3FF), Color(0xFF0066CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back!', 
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Your account is protected by ScamSniper',
            style: TextStyle(color: Colors.white70, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: const [
            _ActionCard(Icons.send, 'Send Money'),
            _ActionCard(Icons.request_page, 'Request Money'),
            _ActionCard(Icons.payment, 'Lipa na M-Pesa'),
            _ActionCard(Icons.receipt, 'Pay Bills'),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionsSection(BuildContext context, List<_TransactionData> transactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Transactions',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => _showSnackBar(context, 'View all transactions'),
              child: const Text('View All', style: TextStyle(color: Color(0xFF00A3FF))),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) => _TransactionItem(
            transaction: transactions[index],
            onTap: () {
              Navigator.pushNamed(context, '/transaction',
                arguments: {
                  'name': transactions[index].name,
                  'amount': transactions[index].amount,
                  'type': transactions[index].type,
                  'timeAgo': transactions[index].timeAgo,
                  'date': transactions[index].date,
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TransactionData {
  final String name;
  final String amount;
  final String type;
  final String timeAgo;
  final DateTime date;

  const _TransactionData(this.name, this.amount, this.type, this.timeAgo, this.date);
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ActionCard(this.icon, this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: const Color(0xFF00A3FF)),
          const SizedBox(height: 8),
          Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final _TransactionData transaction;
  final VoidCallback onTap;

  const _TransactionItem({
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isReceived = transaction.type == 'received';
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: isReceived ? Colors.green[100] : Colors.red[100],
              child: Icon(
                isReceived ? Icons.arrow_downward : Icons.arrow_upward,
                color: isReceived ? Colors.green : Colors.red,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isReceived ? 'Received from ${transaction.name}' : 'Sent to ${transaction.name}',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(transaction.timeAgo,
                    style: const TextStyle(color: Colors.white54, fontSize: 14)),
                ],
              ),
            ),
            Text(
              '${isReceived ? '+' : '-'}${transaction.amount}',
              style: TextStyle(
                color: isReceived ? Colors.green : Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}