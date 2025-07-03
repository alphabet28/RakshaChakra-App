import 'package:flutter/material.dart';

class AddPayeeScreen extends StatefulWidget {
  const AddPayeeScreen({super.key});

  @override
  State<AddPayeeScreen> createState() => _AddPayeeScreenState();
}

class _AddPayeeScreenState extends State<AddPayeeScreen> {
  final _formKey = GlobalKey<FormState>();
  int _step1 = 0; // 0: Bank, 1: Credit Card, 2: Cardless Cash
  String? _bankAccountName;
  String? _accountName;
  String? _accountNumber;
  String? _reAccountNumber;
  String? _creditCardNumber;
  String? _reCreditCardNumber;
  String? _cardName;
  String? _beneficiaryNickname;
  String? _mobileNumber;
  int _payeeIdType = 0; // 0: Voter ID, 1: PAN
  String? _payeeIdValue;

  List<String> bankAccountNames = [
    'Savings Account',
    'Current Account',
    'Salary Account',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Payee')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Step 1 Dropdown
              const Text('Step 1 - Select Transfer Type', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ToggleButtons(
                isSelected: [
                  _step1 == 0,
                  _step1 == 1,
                  _step1 == 2,
                ],
                onPressed: (index) {
                  setState(() {
                    _step1 = index;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Bank Accounts'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Credit Card'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Cardless Cash'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Step 2 - Dynamic Fields
              if (_step1 == 0) ..._buildBankAccountFields(),
              if (_step1 == 1) ..._buildCreditCardFields(),
              if (_step1 == 2) ..._buildCardlessCashFields(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBankAccountFields() {
    return [
      const Text('Step 2 - Account Category', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: 'Select Bank Account'),
        value: _bankAccountName,
        items: bankAccountNames.map((name) => DropdownMenuItem(value: name, child: Text(name))).toList(),
        onChanged: (val) => setState(() => _bankAccountName = val),
        validator: (val) => val == null ? 'Please select a bank account' : null,
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Account Name'),
        onChanged: (val) => _accountName = val,
        validator: (val) => val == null || val.isEmpty ? 'Enter account name' : null,
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Account Number'),
        keyboardType: TextInputType.number,
        onChanged: (val) => _accountNumber = val,
        validator: (val) {
          if (val == null || val.isEmpty) return 'Enter account number';
          if (val.length < 10 || val.length > 18) return 'Invalid account number';
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Re-enter Account Number'),
        keyboardType: TextInputType.number,
        onChanged: (val) => _reAccountNumber = val,
        validator: (val) {
          if (val == null || val.isEmpty) return 'Re-enter account number';
          if (val != _accountNumber) return 'Account numbers do not match';
          return null;
        },
      ),
      const SizedBox(height: 8),
      const Text('Please ensure that the payee account number that you enter is correct', style: TextStyle(color: Colors.red)),
      const SizedBox(height: 24),
      Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Continue logic
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payee added successfully!')));
                }
              },
              child: const Text('Continue'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildCreditCardFields() {
    return [
      const Text('Step 2 - Indian Credit Card', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Credit Card Number'),
        keyboardType: TextInputType.number,
        onChanged: (val) => _creditCardNumber = val,
        validator: (val) {
          if (val == null || val.isEmpty) return 'Enter credit card number';
          if (val.length < 12 || val.length > 19) return 'Invalid credit card number';
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Re-enter Credit Card Number'),
        keyboardType: TextInputType.number,
        onChanged: (val) => _reCreditCardNumber = val,
        validator: (val) {
          if (val == null || val.isEmpty) return 'Re-enter credit card number';
          if (val != _creditCardNumber) return 'Credit card numbers do not match';
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Name on Card'),
        onChanged: (val) => _cardName = val,
        validator: (val) => val == null || val.isEmpty ? 'Enter name on card' : null,
      ),
      const SizedBox(height: 24),
      Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payee added successfully!')));
                }
              },
              child: const Text('Continue'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildCardlessCashFields() {
    return [
      const Text('Step 2 - Cashless Cash Withdrawal', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Beneficiary Nickname'),
        onChanged: (val) => _beneficiaryNickname = val,
        validator: (val) => val == null || val.isEmpty ? 'Enter beneficiary nickname' : null,
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Mobile Number'),
        keyboardType: TextInputType.phone,
        onChanged: (val) => _mobileNumber = val,
        validator: (val) {
          if (val == null || val.isEmpty) return 'Enter IFSC code';
          if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(val)) return 'Invalid IFSC code';
          return null;
        },
      ),
      const SizedBox(height: 16),
      const Text('Payee ID (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      ToggleButtons(
        isSelected: [_payeeIdType == 0, _payeeIdType == 1],
        onPressed: (index) {
          setState(() {
            _payeeIdType = index;
            _payeeIdValue = null;
          });
        },
        borderRadius: BorderRadius.circular(8),
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('Voter ID'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('PAN'),
          ),
        ],
      ),
      const SizedBox(height: 8),
      TextFormField(
        decoration: InputDecoration(labelText: _payeeIdType == 0 ? 'Voter ID (Optional)' : 'PAN (Optional)'),
        onChanged: (val) => _payeeIdValue = val,
      ),
      const SizedBox(height: 24),
      Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payee added successfully!')));
                }
              },
              child: const Text('Continue'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    ];
  }
} 