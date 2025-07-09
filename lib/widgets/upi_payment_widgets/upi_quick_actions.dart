import 'package:flutter/material.dart';

class UPIQuickActions extends StatelessWidget {
  UPIQuickActions({super.key});

  final List<_QuickAction> actions = const [
    _QuickAction(
      label: 'Send Money',
      icon: Icons.send,
      route: '/send_money',
    ),
    _QuickAction(
      label: 'Request Money',
      icon: Icons.request_page,
      route: '/request_money',
    ),
    _QuickAction(
      label: 'Scan and Pay',
      icon: Icons.qr_code_scanner,
      route: '/scan_pay',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: actions.map((action) {
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, action.route),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(action.icon, color: Colors.white, size: 32),
                const SizedBox(height: 8),
                Text(
                  action.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _QuickAction {
  final String label;
  final IconData icon;
  final String route;
  const _QuickAction({required this.label, required this.icon, required this.route});
}