import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/currency_utils.dart';
import '../../../../domain/entities/plan.dart';
import '../../../../domain/entities/plan_item.dart';

/// Available icons for plan items
class PlanItemIcon {
  final IconData icon;
  final String name;

  const PlanItemIcon({required this.icon, required this.name});
}

/// Plan Item Editor page for creating and editing plan items
/// Supports both create and edit modes based on whether an existing item is passed
class PlanItemEditorPage extends StatefulWidget {
  /// The plan this item belongs to
  final Plan plan;

  /// Existing item to edit (null for create mode)
  final PlanItem? existingItem;

  /// Current total of all plan items (for validation)
  final double currentTotalPlanned;

  const PlanItemEditorPage({
    super.key,
    required this.plan,
    this.existingItem,
    this.currentTotalPlanned = 0,
  });

  /// Check if in edit mode
  bool get isEditMode => existingItem != null;

  @override
  State<PlanItemEditorPage> createState() => _PlanItemEditorPageState();
}

class _PlanItemEditorPageState extends State<PlanItemEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isExpenseType = true;
  int _selectedIconIndex = 0;

  // Available icons for selection
  static const List<PlanItemIcon> _availableIcons = [
    PlanItemIcon(icon: Icons.restaurant, name: 'Food'),
    PlanItemIcon(icon: Icons.shopping_cart, name: 'Shopping'),
    PlanItemIcon(icon: Icons.directions_car, name: 'Car'),
    PlanItemIcon(icon: Icons.home, name: 'Home'),
    PlanItemIcon(icon: Icons.directions_bus, name: 'Transport'),
    PlanItemIcon(icon: Icons.local_cafe, name: 'Coffee'),
    PlanItemIcon(icon: Icons.favorite, name: 'Health'),
    PlanItemIcon(icon: Icons.medical_services, name: 'Medical'),
    PlanItemIcon(icon: Icons.school, name: 'Education'),
    PlanItemIcon(icon: Icons.movie, name: 'Entertainment'),
    PlanItemIcon(icon: Icons.flight, name: 'Travel'),
    PlanItemIcon(icon: Icons.card_giftcard, name: 'Gift'),
    PlanItemIcon(icon: Icons.checkroom, name: 'Clothing'),
    PlanItemIcon(icon: Icons.fitness_center, name: 'Fitness'),
    PlanItemIcon(icon: Icons.book, name: 'Books'),
    PlanItemIcon(icon: Icons.phone_android, name: 'Phone'),
    PlanItemIcon(icon: Icons.computer, name: 'Computer'),
    PlanItemIcon(icon: Icons.pets, name: 'Pets'),
    PlanItemIcon(icon: Icons.work, name: 'Work'),
    PlanItemIcon(icon: Icons.attach_money, name: 'Salary'),
    PlanItemIcon(icon: Icons.savings, name: 'Savings'),
    PlanItemIcon(icon: Icons.trending_up, name: 'Investment'),
    PlanItemIcon(icon: Icons.account_balance, name: 'Bank'),
    PlanItemIcon(icon: Icons.category, name: 'Other'),
  ];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.existingItem != null) {
      final item = widget.existingItem!;
      _nameController.text = item.name;
      _amountController.text = item.expectedAmount.toStringAsFixed(2);
      // Try to find matching icon
      _selectedIconIndex = _findIconIndexByName(item.name);
    }
  }

  int _findIconIndexByName(String name) {
    final lowerName = name.toLowerCase();
    for (int i = 0; i < _availableIcons.length; i++) {
      if (lowerName.contains(_availableIcons[i].name.toLowerCase())) {
        return i;
      }
    }
    return 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final expectedIncome = widget.plan.expectedIncome ?? 0;

      // Calculate new total (subtract existing item amount if editing)
      final existingItemAmount = widget.existingItem?.expectedAmount ?? 0;
      final newTotalPlanned =
          widget.currentTotalPlanned - existingItemAmount + amount;

      // Validate: new total should not exceed expected income
      if (expectedIncome > 0 && newTotalPlanned > expectedIncome) {
        final availableBudget =
            expectedIncome - widget.currentTotalPlanned + existingItemAmount;
        _showValidationError(
          'Budget Exceeded',
          'Adding this item (${CurrencyUtils.formatCurrency(amount)}) would exceed your plan budget.\n\n'
              'Available budget: ${CurrencyUtils.formatCurrency(availableBudget.clamp(0, double.infinity))}\n'
              'Expected income: ${CurrencyUtils.formatCurrency(expectedIncome)}\n'
              'Current planned: ${CurrencyUtils.formatCurrency(widget.currentTotalPlanned - existingItemAmount)}\n\n'
              'Please reduce the amount or increase your plan\'s expected income.',
        );
        return;
      }

      final result = {
        'name': _nameController.text.trim(),
        'amount': amount,
        'isExpense': _isExpenseType,
        'iconIndex': _selectedIconIndex,
        'description': _descriptionController.text.trim(),
      };

      if (widget.existingItem != null) {
        result['id'] = widget.existingItem!.id;
      }

      Navigator.of(context).pop(result);
    }
  }

  void _showValidationError(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 18))),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4D648D),
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  double get _previewAmount {
    final text = _amountController.text;
    if (text.isEmpty) return 0;
    return double.tryParse(text) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.existingItem != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(isEditMode),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Plan Context
                        _buildPlanContext(),

                        const SizedBox(height: 24),

                        // Item Name
                        _buildNameField(),

                        const SizedBox(height: 24),

                        // Type Selector
                        _buildTypeSelector(),

                        const SizedBox(height: 24),

                        // Icon Selector
                        _buildIconSelector(),

                        const SizedBox(height: 24),

                        // Planned Amount
                        _buildAmountField(),

                        const SizedBox(height: 24),

                        // Description
                        _buildDescriptionField(),

                        const SizedBox(height: 24),

                        // Preview Section
                        _buildPreviewSection(),

                        const SizedBox(height: 24),

                        // Helper Note
                        _buildHelperNote(),

                        // Bottom padding for action bar
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Action Bar
      bottomNavigationBar: _buildBottomActionBar(isEditMode),
    );
  }

  Widget _buildHeader(bool isEditMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF4D648D),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              isEditMode ? 'Edit Plan Item' : 'Create Plan Item',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Placeholder for symmetry
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildPlanContext() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adding to Plan',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.plan.formattedPeriod,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Item Name ',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            children: [
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'e.g. Food & Dining, Rent, Salary',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4D648D)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a category name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Type ',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            children: [
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTypeButton(
                label: 'Expense',
                icon: Icons.trending_down,
                isSelected: _isExpenseType,
                onTap: () => setState(() => _isExpenseType = true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTypeButton(
                label: 'Income',
                icon: Icons.trending_up,
                isSelected: !_isExpenseType,
                onTap: () => setState(() => _isExpenseType = false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF4D648D) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color:
                  isSelected ? const Color(0xFF4D648D) : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color:
                    isSelected ? const Color(0xFF4D648D) : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Icon ',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            children: [
              TextSpan(
                text: '(Optional)',
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Choose an icon to represent this plan item',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 12),

        // Selected Icon Display
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF4D648D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _availableIcons[_selectedIconIndex].icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tap below to change icon',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Icon Grid
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: _availableIcons.length,
            itemBuilder: (context, index) {
              final isSelected = index == _selectedIconIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedIconIndex = index),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF4D648D) : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF4D648D)
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _availableIcons[index].icon,
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                    size: 20,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Planned Amount ',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            children: [
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _amountController,
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixText: '฿ ',
            prefixStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4D648D)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          onChanged: (_) => setState(() {}),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Text(
          'This is your intended budget for this category',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Description ',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            children: [
              TextSpan(
                text: '(Optional)',
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Add notes about this plan item...',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4D648D)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewSection() {
    final amount = _previewAmount;
    final expectedIncome = widget.plan.expectedIncome ?? 0;
    final existingItemAmount = widget.existingItem?.expectedAmount ?? 0;
    final newTotalPlanned =
        widget.currentTotalPlanned - existingItemAmount + amount;
    final availableBudget =
        expectedIncome - widget.currentTotalPlanned + existingItemAmount;
    final hasBudgetIssue =
        expectedIncome > 0 && amount > 0 && newTotalPlanned > expectedIncome;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasBudgetIssue ? Colors.orange.shade50 : Colors.grey.shade50,
        border: Border.all(
          color: hasBudgetIssue ? Colors.orange.shade300 : Colors.grey.shade200,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Preview',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              if (hasBudgetIssue) ...[
                const Spacer(),
                Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: Colors.orange.shade700,
                ),
                const SizedBox(width: 4),
                Text(
                  'Exceeds Budget',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          _buildPreviewRow('Planned', amount),
          const SizedBox(height: 8),
          _buildPreviewRow('Actual', 0),
          const SizedBox(height: 8),
          _buildPreviewRow('Remaining', amount),
          if (expectedIncome > 0) ...[
            const SizedBox(height: 12),
            Divider(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 12),
            _buildPreviewRowWithColor(
              'Available Budget',
              CurrencyUtils.formatCurrency(
                  availableBudget.clamp(0, double.infinity)),
              Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            _buildPreviewRowWithColor(
              'After Adding',
              CurrencyUtils.formatCurrency((availableBudget - amount)
                  .clamp(double.negativeInfinity, double.infinity)),
              hasBudgetIssue ? Colors.red.shade600 : Colors.green.shade600,
            ),
          ],
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade600),
            ),
          ),
          if (hasBudgetIssue) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.orange.shade800,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This amount exceeds your available budget. Reduce the amount or increase plan income.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreviewRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          CurrencyUtils.formatCurrency(amount),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewRowWithColor(
      String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildHelperNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 16,
            color: Colors.grey.shade500,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Plan Items',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Plan items represent your intentions. They don\'t lock money or restrict spending—they help you stay aware of your goals.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(bool isEditMode) {
    final isValid = _nameController.text.trim().isNotEmpty &&
        _amountController.text.isNotEmpty &&
        (double.tryParse(_amountController.text) ?? 0) > 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: isValid ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isValid ? const Color(0xFF4D648D) : Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(isEditMode ? 'Save Changes' : 'Save Plan Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
