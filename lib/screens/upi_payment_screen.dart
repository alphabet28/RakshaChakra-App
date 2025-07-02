import 'package:flutter/material.dart';
import 'package:raksha/widgets/app_drawer.dart';

class UPIPaymentScreen extends StatefulWidget {
  const UPIPaymentScreen({super.key});

  @override
  State<UPIPaymentScreen> createState() => _UPIPaymentScreenState();
}

class _UPIPaymentScreenState extends State<UPIPaymentScreen> {
  final List<_UPIAction> _actions = [
    _UPIAction(
      label: 'Send Money to Contact / UPI ID',
      icon: Icons.send_to_mobile,
    ),
    _UPIAction(
      label: 'Send Money to Account Number',
      icon: Icons.account_balance,
    ),
    _UPIAction(
      label: 'Scan Any QR',
      icon: Icons.qr_code_scanner,
    ),
    _UPIAction(
      label: 'Receive Money',
      icon: Icons.call_received,
    ),
    _UPIAction(
      label: 'UPI Mandate',
      icon: Icons.assignment,
    ),
    _UPIAction(
      label: 'Pending Money Requests',
      icon: Icons.pending_actions,
    ),
    _UPIAction(
      label: 'Manage UPI ID / Number',
      icon: Icons.manage_accounts,
    ),
    _UPIAction(
      label: 'UPI Transaction History',
      icon: Icons.history,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF667EEA),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        title: const Text(
          'UPI Payments',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.payment,
                    size: 40,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  // Text(
                  //   'UPI Payments',
                  //   style: TextStyle(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  SizedBox(height: 5),
                  Text(
                    'Choose an action below',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
              children: _actions.map((action) => _buildActionBox(action)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBox(_UPIAction action) {
    return GestureDetector(
      onTap: () {
        switch (action.label) {
          case 'Send Money to Contact / UPI ID':
          case 'Send Money to Account Number':
          case 'Scan Any QR':
          case 'Receive Money':
            Navigator.pushNamed(context, '/transfer');
            break;
          case 'UPI Mandate':
            Navigator.pushNamed(context, '/upi_mandate');
            break;
          case 'Pending Money Requests':
            Navigator.pushNamed(context, '/pending_requests');
            break;
          case 'Manage UPI ID / Number':
            Navigator.pushNamed(context, '/manage_upi');
            break;
          case 'UPI Transaction History':
            Navigator.pushNamed(context, '/transactions');
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFF667EEA).withOpacity(0.15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(action.icon, size: 40, color: const Color(0xFF667EEA)),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                action.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UPIAction {
  final String label;
  final IconData icon;
  const _UPIAction({required this.label, required this.icon});
}